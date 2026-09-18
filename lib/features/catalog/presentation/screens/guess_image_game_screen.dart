import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_network_image.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/components/ali_paywall_dialog.dart';
import '../../domain/models/catalog_category_model.dart';
import '../../domain/models/catalog_item_model.dart';
import '../../domain/models/catalog_defaults.dart';

enum GuessResultStatus {
  idle,
  listening,
  correct,
  incorrect,
}

/// Layar Full-Page Tebak Gambar Interaktif Kosa Kata untuk Anak (Mode Game Edukasi)
class GuessImageGameScreen extends StatefulWidget {
  final List<CatalogItemModel>? items;
  final int initialIndex;
  final String? initialCategoryId;

  const GuessImageGameScreen({
    super.key,
    this.items,
    this.initialIndex = 0,
    this.initialCategoryId,
  });

  @override
  State<GuessImageGameScreen> createState() => _GuessImageGameScreenState();
}

class _GuessImageGameScreenState extends State<GuessImageGameScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isSpeechAvailable = false;
  bool _isListening = false;
  String _recognizedText = '';
  GuessResultStatus _status = GuessResultStatus.idle;
  String _feedbackMessage = '';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final Random _random = Random();

  // Pujian ceria, alami & tidak kaku saat anak benar
  static const List<String> _praiseExpressions = [
    'Wah, hebat banget! Betul sekali, ini ',
    'Keren! Pinter banget, ya betul ini ',
    'Yeay, tepat sekali! Ini adalah ',
    'Mantap! Bener banget, ini namanya ',
    'Wah, jagoan! Betul, ini ',
  ];

  // Kalimat penyemangat lembut, hangat & tidak kaku saat belum pas
  static const List<String> _tryAgainExpressions = [
    'Hmm, belum pas nih. Coba perhatikan gambarnya lagi ya!',
    'Hampir betul! Ayo coba sebutkan sekali lagi pelan-pelan!',
    'Bukan itu sayang, ayo coba tebak lagi!',
    'Wah sedikit lagi tepat! Coba lihat lagi bentuknya apa ini ya?',
  ];

  bool _isAutoListeningEnabled = true;
  bool _isEvaluating = false;

  late List<CatalogItemModel> _allItems;
  late List<CatalogItemModel> _items;
  List<CatalogCategoryModel> _categories = [];
  String _selectedCategoryId = 'all';
  bool _isLoadingItems = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId ?? 'all';
    _allItems = widget.items ?? [];
    _applyCategoryFilter();
    _currentIndex = widget.initialIndex;
    if (_currentIndex >= _items.length) {
      _currentIndex = 0;
    }
    _pageController = PageController(initialPage: _currentIndex);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadCategoriesAndItems();
  }

  void _applyCategoryFilter() {
    if (_selectedCategoryId == 'all') {
      _items = List.from(_allItems);
    } else {
      _items = _allItems.where((i) => i.categoryId == _selectedCategoryId).toList();
    }
    _items = CatalogDefaults.sortCatalogItems(_items);
  }

  Future<void> _loadCategoriesAndItems() async {
    var cats = await SupabaseService.getCatalogCategories();
    for (final defaultCat in CatalogDefaults.defaultCategories) {
      if (!cats.any((c) => c.id == defaultCat.id)) {
        cats.add(defaultCat);
      }
    }
    if (mounted) {
      setState(() => _categories = cats);
    }

    if (_allItems.isEmpty) {
      setState(() => _isLoadingItems = true);
      var loaded = await SupabaseService.getCatalogItems();
      if (!loaded.any((i) => i.categoryId == 'hijaiyah')) {
        loaded = [...loaded, ...CatalogDefaults.hijaiyahItems];
      }
      if (!loaded.any((i) => i.categoryId == 'alfabet_angka')) {
        loaded = [...loaded, ...CatalogDefaults.alphaNumItems];
      }
      if (mounted) {
        setState(() {
          _allItems = loaded;
          _applyCategoryFilter();
          _isLoadingItems = false;
          _currentIndex = 0;
        });
        _initSpeechAndAutoListen();
      }
    } else {
      // Jika _allItems sudah ada tapi belum ada hijaiyah atau alfabet_angka
      var updated = _allItems;
      if (!updated.any((i) => i.categoryId == 'hijaiyah')) {
        updated = [...updated, ...CatalogDefaults.hijaiyahItems];
      }
      if (!updated.any((i) => i.categoryId == 'alfabet_angka')) {
        updated = [...updated, ...CatalogDefaults.alphaNumItems];
      }
      if (updated.length != _allItems.length && mounted) {
        setState(() {
          _allItems = updated;
          _applyCategoryFilter();
        });
      }
      _initSpeechAndAutoListen();
    }
  }

  CatalogItemModel get _currentItem => _items[_currentIndex];

  String _selectedLocaleId = 'id_ID';

  Future<void> _initSpeechAndAutoListen() async {
    try {
      // 1. Minta izin mikrofon secara eksplisit via permission_handler
      var micStatus = await Permission.microphone.status;
      if (!micStatus.isGranted) {
        micStatus = await Permission.microphone.request();
      }

      final available = await _speech.initialize(
        onError: (err) {
          debugPrint('Speech recognition error: ${err.errorMsg}');
          if (mounted) {
            setState(() {
              _isListening = false;
              if (_status == GuessResultStatus.listening) {
                _status = GuessResultStatus.idle;
              }
            });
            // Auto-restart listening jika masih aktif
            if (_isAutoListeningEnabled && _status != GuessResultStatus.correct && !_isEvaluating) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (mounted && _isAutoListeningEnabled && !_isListening && !_isEvaluating) {
                  _startContinuousListening();
                }
              });
            }
          }
        },
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() => _isListening = false);
              // Lanjut mendengarkan secara otomatis
              if (_isAutoListeningEnabled && _status != GuessResultStatus.correct && !_isEvaluating) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted && _isAutoListeningEnabled && !_isListening && _status != GuessResultStatus.correct && !_isEvaluating) {
                    _startContinuousListening();
                  }
                });
              }
            }
          }
        },
      );

      if (mounted) {
        setState(() => _isSpeechAvailable = available);
        if (available) {
          // Cari locale Bahasa Indonesia dari daftar model yang terpasang di perangkat
          try {
            final locales = await _speech.locales();
            for (final loc in locales) {
              final id = loc.localeId.toLowerCase().replaceAll('-', '_');
              if (id.contains('id_id') || id.startsWith('id')) {
                _selectedLocaleId = loc.localeId;
                break;
              }
            }
          } catch (e) {
            debugPrint('Locales fetch note: $e');
          }

          if (_isAutoListeningEnabled) {
            _startContinuousListening();
          }
        } else {
          setState(() {
            _feedbackMessage = 'Mikrofon belum diizinkan atau tidak aktif. Ketuk ikon pensil di bawah untuk mengetik ya!';
          });
        }
      }
    } catch (e) {
      debugPrint('Error init speech: $e');
    }
  }

  @override
  void dispose() {
    _isAutoListeningEnabled = false;
    _pulseController.dispose();
    _speech.stop();
    _speech.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startContinuousListening() async {
    if (_isListening) {
      try {
        await _speech.stop();
      } catch (_) {}
      _isListening = false;
    }

    if (!_isSpeechAvailable) {
      final initOk = await _speech.initialize();
      if (!initOk) return;
      _isSpeechAvailable = true;
    }

    if (!mounted || _isEvaluating) return;

    setState(() {
      _isListening = true;
      _status = GuessResultStatus.listening;
      _recognizedText = '';
      _feedbackMessage = 'Sebutkan nama bendanya ya... ${UserProfileService.childName} sedang dengar!';
    });

    try {
      await _speech.listen(
        localeId: _selectedLocaleId,
        listenFor: const Duration(seconds: 45),
        pauseFor: const Duration(seconds: 4),
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
          listenMode: stt.ListenMode.confirmation,
        ),
        onResult: (result) {
          if (!mounted) return;
          final words = result.recognizedWords.trim();
          if (words.isNotEmpty) {
            setState(() {
              _recognizedText = words;
            });
            _evaluateGuess(words, isFinal: result.finalResult);
          }
        },
      );
    } catch (e) {
      debugPrint('Speech listen failed: $e');
      if (mounted) {
        setState(() => _isListening = false);
      }
    }
  }

  void _evaluateGuess(String rawGuess, {bool isFinal = false}) async {
    if (rawGuess.trim().isEmpty || _isEvaluating) return;

    final targetName = _currentItem.name.toLowerCase().trim();
    final guess = rawGuess.toLowerCase().trim();

    // Cek kecocokan target kosa kata
    bool isMatch = false;

    // Ekstrak nama murni jika terdapat format "ا (Alif)" -> target bisa "alif", "a", atau phonics
    final phonics = (_currentItem.phonics ?? '').toLowerCase().trim();
    final insideParenMatch = RegExp(r'\((.*?)\)').firstMatch(targetName);
    final insideParen = insideParenMatch != null ? insideParenMatch.group(1)?.toLowerCase().trim() : null;

    if (guess.contains(targetName) || targetName.contains(guess)) {
      isMatch = true;
    } else if (phonics.isNotEmpty && (guess.contains(phonics) || phonics.contains(guess))) {
      isMatch = true;
    } else if (insideParen != null && insideParen.isNotEmpty && (guess.contains(insideParen) || insideParen.contains(guess))) {
      isMatch = true;
    } else {
      // Normalisasi karakter & tanda baca
      final cleanTarget = targetName.replaceAll('-', ' ').replaceAll('_', ' ');
      final cleanGuess = guess.replaceAll('-', ' ').replaceAll('_', ' ');

      if (cleanGuess.contains(cleanTarget) || cleanTarget.contains(cleanGuess)) {
        isMatch = true;
      } else {
        // Cek per kata (misal jika anak menyebut "itu kucing" atau "gambar kucing")
        final targetWords = cleanTarget.split(' ').where((w) => w.length >= 2).toList();
        final guessWords = cleanGuess.split(' ').where((w) => w.length >= 2).toList();

        for (final tw in targetWords) {
          for (final gw in guessWords) {
            if (gw == tw || (gw.length >= 3 && tw.contains(gw)) || (tw.length >= 3 && gw.contains(tw))) {
              isMatch = true;
              break;
            }
          }
          if (isMatch) break;
        }

        // Cek kemiripan ejaan / fonetik jika Google STT menduga kata Inggris yang mirip
        if (!isMatch && _currentItem.syllables.isNotEmpty) {
          final joinedSyllables = _currentItem.syllables.join().toLowerCase();
          if (cleanGuess.replaceAll(' ', '').contains(joinedSyllables)) {
            isMatch = true;
          }
        }
      }
    }

    if (isMatch) {
      _isEvaluating = true;
      await _speech.stop();
      final praise = _praiseExpressions[_random.nextInt(_praiseExpressions.length)];
      final fullFeedback = '$praise${_currentItem.name}!';

      if (mounted) {
        setState(() {
          _status = GuessResultStatus.correct;
          _feedbackMessage = fullFeedback;
          _isListening = false;
        });
      }

      // Ucapkan apresiasi hangat dengan suara TTS yang natural
      await AudioEngineService.speakWord(text: fullFeedback);

      // Log aktivitas speech progress anak
      SupabaseService.logChildActivity(
        activityType: 'guess_game_speech',
        targetLabel: _currentItem.name,
        category: _currentItem.categoryId,
        success: true,
        metadata: {'recognized_text': _recognizedText},
      );

      // Otomatis berpindah ke gambar berikutnya setelah anak berhasil menebak!
      await Future.delayed(const Duration(milliseconds: 2500));
      if (mounted && _status == GuessResultStatus.correct) {
        _isEvaluating = false;
        if (_currentIndex < _items.length - 1) {
          _goToNext();
        } else {
          _startContinuousListening();
        }
      } else {
        _isEvaluating = false;
      }
    } else if (isFinal) {
      // Hanya beri feedback suara 'belum tepat' jika kalimat sudah selesai diucapkan (bukan saat anak masih bicara di tengah kata)
      _isEvaluating = true;
      final retryMsg = _tryAgainExpressions[_random.nextInt(_tryAgainExpressions.length)];
      if (mounted) {
        setState(() {
          _status = GuessResultStatus.incorrect;
          _feedbackMessage = retryMsg;
        });
      }

      // Beri feedback suara lembut
      await AudioEngineService.speakWord(text: retryMsg);

      // Kembalikan ke mode mendengarkan otomatis
      await Future.delayed(const Duration(milliseconds: 1400));
      _isEvaluating = false;
      if (mounted && _isAutoListeningEnabled && _status != GuessResultStatus.correct) {
        _startContinuousListening();
      }
    }
  }

  void _giveAudioHint() {
    if (_currentItem.categoryId == 'hijaiyah') {
      final phonetic = AudioEngineService.getArabicPhoneticFallback(_currentItem.name);
      AudioEngineService.speakWord(
        text: _currentItem.name,
        phoneticFallback: phonetic,
        audioUrl: _currentItem.audioUrl,
      );
    } else {
      AudioEngineService.speakWord(
        text: 'Ini adalah ${_currentItem.name}',
        audioUrl: _currentItem.audioUrl,
      );
    }
  }

  void _goToNext() {
    if (!SubscriptionService.isPro && _currentIndex >= 9) {
      _speech.stop();
      AliPaywallDialog.show(
        context,
        featureName: 'Semua Soal Tebak Gambar',
        featureDescription: 'Anda telah menyelesaikan 10 soal tebak gambar gratis! Buka ratusan tantangan tebak gambar interaktif lainnya bersama Ali Pro.',
      );
      return;
    }

    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _showFallbackInputModal() {
    final textCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ketik Tebakan Kamu ✍️',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (val) {
                  Navigator.pop(ctx);
                  _evaluateGuess(val);
                },
                decoration: InputDecoration(
                  hintText: 'Contoh: ${_currentItem.name}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AliButton(
                  label: 'Tebak Sekarang',
                  variant: AliButtonVariant.primaryHighContrast,
                  onPressed: () {
                    Navigator.pop(ctx);
                    _evaluateGuess(textCtrl.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingItems) {
      return const Scaffold(
        backgroundColor: AppColors.pureBlack,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.accentLemon),
              SizedBox(height: 16),
              Text(
                'Menyiapkan gambar tebakan...',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.pureBlack,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'Belum ada data kosa kata',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    final media = MediaQuery.sizeOf(context);
    final isTabletOrWeb = media.width >= 700;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // 1. Top Navigation Bar (Header)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // Tombol Kembali
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderCard),
                            boxShadow: AppShadows.cardShadow,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Main Tebak Gambar ✨',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            'Sebutkan nama bendanya ya!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Indikator Nomor Item
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePillDark,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.cardShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_currentIndex + 1}',
                              style: const TextStyle(
                                color: AppColors.accentLemon,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              ' / ${_items.length}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Tombol Audio Hint / Bantuan Bunyi Suara
                      InkWell(
                        onTap: _giveAudioHint,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderCard),
                            boxShadow: AppShadows.cardShadow,
                          ),
                          child: const AliIcon(Iconsax.volume_high, color: AppColors.textPrimary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                // 1b. Horizontal Category Filter Chips
                if (_categories.isNotEmpty)
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(top: 4, bottom: 6),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCategoryChip('all', 'Semua', '🌟', count: _allItems.length),
                        ..._categories.map((cat) {
                          final count = _allItems.where((i) => i.categoryId == cat.id).length;
                          return _buildCategoryChip(cat.id, cat.nameId, _getCategoryEmoji(cat.id), count: count);
                        }),
                      ],
                    ),
                  ),

                // 2. Main Content Area (Responsive Card)
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTabletOrWeb ? 680 : double.infinity,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Card Besar Gambar (Page View)
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _items.length,
                              onPageChanged: (index) async {
                                _isEvaluating = false;
                                try {
                                  await _speech.stop();
                                } catch (_) {}
                                if (!SubscriptionService.isPro && index >= 10) {
                                  _pageController.jumpToPage(9);
                                  AliPaywallDialog.show(
                                    context,
                                    featureName: 'Semua Soal Tebak Gambar',
                                    featureDescription: 'Anda telah menyelesaikan 10 soal tebak gambar gratis! Buka ratusan tantangan tebak gambar interaktif lainnya bersama Ali Pro.',
                                  );
                                  return;
                                }
                                if (mounted) {
                                  setState(() {
                                    _currentIndex = index;
                                    _status = GuessResultStatus.idle;
                                    _recognizedText = '';
                                    _feedbackMessage = '';
                                    _isListening = false;
                                  });
                                }
                                if (_isAutoListeningEnabled) {
                                  Future.delayed(const Duration(milliseconds: 400), () {
                                    if (mounted && _isAutoListeningEnabled && !_isListening && !_isEvaluating) {
                                      _startContinuousListening();
                                    }
                                  });
                                }
                              },
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                final isCurrentItem = index == _currentIndex;
                                return Center(
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceCard,
                                        borderRadius: BorderRadius.circular(AppRadius.r24),
                                        border: Border.all(
                                          color: isCurrentItem && _status == GuessResultStatus.correct
                                              ? const Color(0xFF22C55E)
                                              : isCurrentItem && _status == GuessResultStatus.incorrect
                                                  ? const Color(0xFFEF4444)
                                                  : AppColors.borderCard,
                                          width: (isCurrentItem && _status != GuessResultStatus.idle) ? 2.0 : 1.0,
                                        ),
                                        boxShadow: AppShadows.cardShadow,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(AppRadius.r24),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            // 1. Full Image or Rich Typographic Card (when imageUrl is empty)
                                            if (item.imageUrl.trim().isNotEmpty) ...[
                                              AliNetworkImage(
                                                imageUrl: item.imageUrl,
                                                fit: BoxFit.cover,
                                                errorWidget: Container(
                                                  color: AppColors.surfacePillDark,
                                                  child: const Center(
                                                    child: AliIcon(Iconsax.image, size: 48, color: AppColors.accentLemon),
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              // Typographic Art Card for Hijaiyah, Alphabet & Numbers
                                              Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xFF1E293B),
                                                      Color(0xFF0F172A),
                                                    ],
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    // Soft ambient circle
                                                    Positioned(
                                                      top: -30,
                                                      right: -30,
                                                      child: Container(
                                                        width: 180,
                                                        height: 180,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: AppColors.accentLemon.withValues(alpha: 0.08),
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        item.emoji != null && item.emoji!.isNotEmpty
                                                            ? item.emoji!
                                                            : (item.name.isNotEmpty ? item.name[0] : '✨'),
                                                        style: const TextStyle(
                                                          fontSize: 108,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.accentLemon,
                                                          height: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],

                                            // 2. Subtle ambient gradient
                                            Positioned.fill(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black.withValues(alpha: 0.20),
                                                      Colors.transparent,
                                                      Colors.black.withValues(alpha: 0.35),
                                                    ],
                                                    stops: const [0.0, 0.4, 1.0],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // 3. Category badge & audio trigger at top (like standard Ali card)
                                            Positioned(
                                              top: AppSpacing.s12,
                                              left: AppSpacing.s12,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.s10,
                                                  vertical: AppSpacing.s6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(alpha: 0.50),
                                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                                  border: Border.all(
                                                    color: Colors.white.withValues(alpha: 0.25),
                                                    width: 0.8,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: const BoxDecoration(
                                                        color: AppColors.accentLemon,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(width: AppSpacing.s6),
                                                    Text(
                                                      item.categoryId.toUpperCase().replaceAll('_', ' '),
                                                      style: AppTypography.bodySmall(color: AppColors.pureWhite),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Audio hint button
                                            Positioned(
                                              top: AppSpacing.s12,
                                              right: AppSpacing.s12,
                                              child: GestureDetector(
                                                onTap: _giveAudioHint,
                                                child: Container(
                                                  padding: const EdgeInsets.all(AppSpacing.s8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withValues(alpha: 0.50),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white.withValues(alpha: 0.25),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                  child: const AliIcon(
                                                    Iconsax.volume_high,
                                                    size: 16,
                                                    color: AppColors.pureWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Tombol Panah Kiri
                            if (_currentIndex > 0)
                              Positioned(
                                left: 12,
                                child: InkWell(
                                  onTap: _goToPrevious,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceCard,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.borderCard, width: 1.5),
                                      boxShadow: AppShadows.cardShadow,
                                    ),
                                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                                  ),
                                ),
                              ),

                            // Tombol Panah Kanan
                            if (_currentIndex < _items.length - 1)
                              Positioned(
                                right: 12,
                                child: InkWell(
                                  onTap: _goToNext,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceCard,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.borderCard, width: 1.5),
                                      boxShadow: AppShadows.cardShadow,
                                    ),
                                    child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textPrimary, size: 20),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Bottom Control & Feedback Panel
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTabletOrWeb ? 680 : double.infinity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Box Feedback Card
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: _getFeedbackBgColor(),
                            borderRadius: BorderRadius.circular(AppRadius.r24),
                            border: Border.all(
                              color: _getFeedbackBorderColor(),
                              width: 1.5,
                            ),
                            boxShadow: AppShadows.cardShadow,
                          ),
                          child: Column(
                            children: [
                              if (_status == GuessResultStatus.correct) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('🎉', style: TextStyle(fontSize: 22)),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _currentItem.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF15803D),
                                          letterSpacing: 0.8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('🌟', style: TextStyle(fontSize: 22)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                _feedbackMessage.isEmpty
                                    ? 'Ayo sebutkan ini gambar apa langsung di depan layar!'
                                    : _feedbackMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _status == GuessResultStatus.correct ? 15 : 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: _getFeedbackTextColor(),
                                  height: 1.3,
                                ),
                              ),
                              if (_recognizedText.isNotEmpty && _status != GuessResultStatus.correct) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Kamu bilang: "$_recognizedText"',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: _getFeedbackTextColor().withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Action Buttons & Live Soundwave
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tombol Ketik Manual (Alternatif orang tua)
                            InkWell(
                              onTap: _showFallbackInputModal,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceCard,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.borderCard),
                                  boxShadow: AppShadows.cardShadow,
                                ),
                                child: const AliIcon(Iconsax.edit_2, color: AppColors.textPrimary, size: 20),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Indikator Mikrofon Otomatis Aktif
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isListening
                                      ? const Color(0xFF15803D)
                                      : AppColors.surfacePillDark,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  border: Border.all(
                                    color: _isListening ? const Color(0xFF4ADE80) : Colors.transparent,
                                    width: 1.5,
                                  ),
                                  boxShadow: _isListening
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF22C55E).withValues(alpha: 0.35),
                                            blurRadius: 14,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : AppShadows.cardShadow,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ScaleTransition(
                                      scale: _isListening ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                                      child: Icon(
                                        _isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                                        size: 20,
                                        color: _isListening ? AppColors.accentLemon : Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        _isListening ? 'Mendengarkan anak...' : 'Suara aktif otomatis',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: _isListening ? Colors.white : Colors.white,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Tombol Lanjut ke Gambar Berikutnya
                            InkWell(
                              onTap: _goToNext,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _status == GuessResultStatus.correct
                                      ? const Color(0xFF22C55E)
                                      : AppColors.surfaceCard,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _status == GuessResultStatus.correct
                                        ? const Color(0xFF4ADE80)
                                        : AppColors.borderCard,
                                  ),
                                  boxShadow: AppShadows.cardShadow,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: _status == GuessResultStatus.correct
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _getFeedbackBgColor() {
    switch (_status) {
      case GuessResultStatus.correct:
        return const Color(0xFFDCFCE7);
      case GuessResultStatus.incorrect:
        return const Color(0xFFFEE2E2);
      case GuessResultStatus.listening:
        return const Color(0xFFE0E7FF);
      case GuessResultStatus.idle:
        return AppColors.surfaceCard;
    }
  }

  Color _getFeedbackBorderColor() {
    switch (_status) {
      case GuessResultStatus.correct:
        return const Color(0xFF22C55E);
      case GuessResultStatus.incorrect:
        return const Color(0xFFEF4444);
      case GuessResultStatus.listening:
        return const Color(0xFF818CF8);
      case GuessResultStatus.idle:
        return AppColors.borderCard;
    }
  }

  Color _getFeedbackTextColor() {
    switch (_status) {
      case GuessResultStatus.correct:
        return const Color(0xFF14532D);
      case GuessResultStatus.incorrect:
        return const Color(0xFF7F1D1D);
      case GuessResultStatus.listening:
        return const Color(0xFF1E1B4B);
      case GuessResultStatus.idle:
        return AppColors.textPrimary;
    }
  }

  String _getCategoryEmoji(String id) {
    switch (id) {
      case 'hewan':
        return '🐱';
      case 'buah_makanan':
        return '🍎';
      case 'benda':
        return '🪑';
      case 'aksi_aac':
        return '🗣️';
      case 'kendaraan':
        return '🚗';
      case 'tubuh':
        return '👁️';
      case 'alam':
        return '☀️';
      case 'hijaiyah':
        return '🕌';
      case 'alfabet_angka':
        return '🔤';
      default:
        return '📦';
    }
  }

  Widget _buildCategoryChip(String id, String label, String emoji, {required int count}) {
    final isSelected = _selectedCategoryId == id;
    final isPro = SubscriptionService.isPro;
    final isFreeCategory = id == 'all' || id == 'hijaiyah' || id == 'huruf_angka' || id == 'alfabet_angka' || id == 'keluarga';
    final isLocked = !isPro && !isFreeCategory;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isLocked) {
              _speech.stop();
              AliPaywallDialog.show(
                context,
                featureName: 'Tebak Gambar $label',
                featureDescription: 'Buka tantangan tebak gambar interaktif kategori $label bersama Ali Pro.',
              );
              return;
            }
            if (_selectedCategoryId == id) return;
            setState(() {
              _selectedCategoryId = id;
              _applyCategoryFilter();
              _currentIndex = 0;
              _status = GuessResultStatus.idle;
              _recognizedText = '';
              _feedbackMessage = '';
              _isListening = false;
            });
            if (_items.isNotEmpty) {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(0);
              }
              if (_isAutoListeningEnabled) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted && _isAutoListeningEnabled && !_isListening && !_isEvaluating) {
                    _startContinuousListening();
                  }
                });
              }
            }
          },
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.pureBlack
                  : (isLocked ? const Color(0xFFF1F5F9) : AppColors.surfaceCard),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isSelected
                    ? AppColors.pureBlack
                    : (isLocked ? const Color(0xFFCBD5E1) : AppColors.borderCard),
                width: 1.2,
              ),
              boxShadow: isSelected ? AppShadows.cardShadow : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLocked) ...[
                  const Icon(Icons.lock_rounded, size: 12, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                ],
                Text(emoji, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isLocked ? const Color(0xFF64748B) : AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.borderCard.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
