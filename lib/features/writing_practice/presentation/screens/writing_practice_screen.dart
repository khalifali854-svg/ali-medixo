import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/local_cache_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/components/ali_network_image.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/components/ali_paywall_dialog.dart';
import '../../domain/models/writing_item_model.dart';
import '../../domain/writing_path_data.dart';
import '../../domain/hijaiyah_svg_data.dart';
import '../components/add_writing_word_modal.dart';
import '../components/ali_celebration_overlay.dart';

class WritingPracticeScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const WritingPracticeScreen({
    super.key,
    this.onBack,
  });

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _DrawingCanvasNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen>
    with TickerProviderStateMixin {
  int _activeLevel = 1; // 1: Angka, 2: Huruf Besar, 3: Huruf Kecil, 4: Kata Pendek, 5: Kosa Kata AAC
  int _currentItemIndex = 0;
  List<WritingItemModel> _items = [];
  bool _isLoading = false;

  // Drawing state (Ultra-responsive zero-lag architecture)
  final _DrawingCanvasNotifier _canvasNotifier = _DrawingCanvasNotifier();
  final List<DrawingStroke> _completedStrokes = [];
  final Map<int, DrawingStroke> _activeStrokes = {};
  Color _strokeColor = AppColors.accentBrand;
  final double _strokeWidth = 14.0;

  // Multi-letter progression for words (Level 4 & 5)
  int _currentCharIndexInWord = 0;

  // "Ali Menuliskan Kembali" animation
  late AnimationController _aliEchoController;
  bool _isAliEchoActive = false;

  // Celebration state
  bool _showCelebration = false;
  String _praiseMessage = '';

  StreamSubscription? _supabaseSubscription;
  Timer? _autoCheckTimer;

  final List<Color> _palette = const [
    AppColors.accentBrand,
    AppColors.accentLime,
    AppColors.accentYellow,
    AppColors.accentCoral,
    Color(0xFF8B5CF6),
    AppColors.pureBlack,
  ];

  @override
  void initState() {
    super.initState();
    _aliEchoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _loadLevelContent(_activeLevel, playSound: false);
  }

  @override
  void dispose() {
    _autoCheckTimer?.cancel();
    _canvasNotifier.dispose();
    _supabaseSubscription?.cancel();
    _aliEchoController.dispose();
    super.dispose();
  }

  // Load items based on level (Angka, Huruf Besar, Huruf Kecil, Kata Pendek, Kosa Kata)
  Future<void> _loadLevelContent(int level, {bool playSound = true}) async {
    setState(() {
      _activeLevel = level;
      _currentItemIndex = 0;
      _currentCharIndexInWord = 0;
      _resetStrokes();
      _isLoading = true;
    });

    List<WritingItemModel> initialItems = [];

    if (level == 1) {
      // Numbers up to 999: Start with 1 to 20, plus easy access to 999
      initialItems = List.generate(999, (i) {
        final num = (i + 1).toString();
        return WritingItemModel(
          id: 'num_$num',
          levelType: 1,
          targetText: num,
          hintLabel: 'Angka $num',
          createdAt: DateTime.now(),
        );
      });
    } else if (level == 2) {
      // Uppercase A-Z
      initialItems = List.generate(26, (i) {
        final char = String.fromCharCode(65 + i);
        return WritingItemModel(
          id: 'upper_$char',
          levelType: 2,
          targetText: char,
          hintLabel: 'Huruf Besar $char',
          createdAt: DateTime.now(),
        );
      });
    } else if (level == 3) {
      // Lowercase a-z
      initialItems = List.generate(26, (i) {
        final char = String.fromCharCode(97 + i);
        return WritingItemModel(
          id: 'lower_$char',
          levelType: 3,
          targetText: char,
          hintLabel: 'Huruf Kecil $char',
          createdAt: DateTime.now(),
        );
      });
    } else if (level == 6) {
      // Level 6: Huruf Hijaiyah (Alif s/d Ya)
      final hijaiyahList = [
        {'char': 'ا', 'name': 'Alif', 'arName': 'أَلِف'},
        {'char': 'ب', 'name': 'Ba', 'arName': 'بَاء'},
        {'char': 'ت', 'name': 'Ta', 'arName': 'تَاء'},
        {'char': 'ث', 'name': 'Tsa', 'arName': 'ثَاء'},
        {'char': 'ج', 'name': 'Jim', 'arName': 'جِيم'},
        {'char': 'ح', 'name': 'Ha', 'arName': 'حَاء'},
        {'char': 'خ', 'name': 'Kha', 'arName': 'خَاء'},
        {'char': 'د', 'name': 'Dal', 'arName': 'دَال'},
        {'char': 'ذ', 'name': 'Dzal', 'arName': 'ذَال'},
        {'char': 'ر', 'name': 'Ra', 'arName': 'رَاء'},
        {'char': 'ز', 'name': 'Zai', 'arName': 'زَاي'},
        {'char': 'س', 'name': 'Sin', 'arName': 'سِين'},
        {'char': 'ش', 'name': 'Syin', 'arName': 'شِين'},
        {'char': 'ص', 'name': 'Shad', 'arName': 'صَاد'},
        {'char': 'ض', 'name': 'Dhad', 'arName': 'ضَاد'},
        {'char': 'ط', 'name': 'Tha', 'arName': 'طَاء'},
        {'char': 'ظ', 'name': 'Zha', 'arName': 'ظَاء'},
        {'char': 'ع', 'name': '\'Ain', 'arName': 'عَيْن'},
        {'char': 'غ', 'name': 'Ghain', 'arName': 'غَيْن'},
        {'char': 'ف', 'name': 'Fa', 'arName': 'فَاء'},
        {'char': 'ق', 'name': 'Qaf', 'arName': 'قَاف'},
        {'char': 'ك', 'name': 'Kaf', 'arName': 'كَاف'},
        {'char': 'ل', 'name': 'Lam', 'arName': 'لَام'},
        {'char': 'م', 'name': 'Mim', 'arName': 'مِيم'},
        {'char': 'ن', 'name': 'Nun', 'arName': 'نُون'},
        {'char': 'و', 'name': 'Wawu', 'arName': 'وَاو'},
        {'char': 'ه', 'name': 'Ha', 'arName': 'هَاء'},
        {'char': 'لا', 'name': 'Lam Alif', 'arName': 'لَا'},
        {'char': 'ء', 'name': 'Hamzah', 'arName': 'هَمْزَة'},
        {'char': 'ي', 'name': 'Ya', 'arName': 'يَاء'},
      ];

      final cachedHijaiyah = await LocalCacheService.getCachedCatalogItems(categoryId: 'hijaiyah');
      final catalogAudioMap = <String, String>{};
      for (final item in cachedHijaiyah) {
        if (item.audioUrl != null && item.audioUrl!.isNotEmpty) {
          if (item.emoji != null && item.emoji!.isNotEmpty) {
            catalogAudioMap[item.emoji!] = item.audioUrl!;
          }
          catalogAudioMap[item.name] = item.audioUrl!;
          catalogAudioMap[item.id] = item.audioUrl!;
        }
      }

      initialItems = hijaiyahList.map((h) {
        final char = h['char']!;
        final customAudio = catalogAudioMap[char] ?? catalogAudioMap[h['name']];
        final audioFile = customAudio ?? AudioEngineService.getHijaiyahAssetAudio(char);
        return WritingItemModel(
          id: 'hijaiyah_$char',
          levelType: 6,
          targetText: char,
          hintLabel: h['arName']!, // Nama berharakat bahasa Arab murni
          audioUrl: audioFile,
          createdAt: DateTime.now(),
        );
      }).toList();
    } else {
      // Level 4 (Kata Pendek) & Level 5 (Kosa Kata AAC Membaca)
      if (level == 5) {
        // Ambil kartu dari Papan Bicara AAC (Membaca)
        final cachedAac = await LocalCacheService.getCachedVocabCards();
        if (cachedAac.isNotEmpty) {
          initialItems = cachedAac.map((c) => WritingItemModel(
            id: 'aac_${c.id}',
            levelType: 5,
            targetText: c.label.toUpperCase(),
            hintLabel: c.label,
            imageUrl: c.imageUrl,
            audioUrl: c.audioUrl,
            createdAt: c.createdAt,
          )).toList();
        } else {
          try {
            final cloudAac = await SupabaseService.getVocabCards();
            if (cloudAac.isNotEmpty) {
              initialItems = cloudAac.map((c) => WritingItemModel(
                id: 'aac_${c.id}',
                levelType: 5,
                targetText: c.label.toUpperCase(),
                hintLabel: c.label,
                imageUrl: c.imageUrl,
                audioUrl: c.audioUrl,
                createdAt: c.createdAt,
              )).toList();
            }
          } catch (e) {
            debugPrint('Fetch AAC cards for writing note: $e');
          }
        }

        if (initialItems.isEmpty) {
          final words = [
            {'t': 'MAKAN', 'h': 'Waktunya Makan', 'img': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&auto=format&fit=crop&q=80'},
            {'t': 'MINUM', 'h': 'Minum Susu', 'img': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300&auto=format&fit=crop&q=80'},
            {'t': 'BOLA', 'h': 'Main Bola', 'img': 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=300&auto=format&fit=crop&q=80'},
            {'t': 'TIDUR', 'h': 'Tidur Nyenyak', 'img': 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=300&auto=format&fit=crop&q=80'},
            {'t': 'BUKU', 'h': 'Membaca Buku', 'img': 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&auto=format&fit=crop&q=80'},
            {'t': 'KUCING', 'h': 'Kucing Lucu', 'img': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=300&auto=format&fit=crop&q=80'},
          ];
          initialItems = words
              .map((w) => WritingItemModel(
                    id: 'seed_l5_${w['t']}',
                    levelType: 5,
                    targetText: w['t']!,
                    hintLabel: w['h'],
                    imageUrl: w['img'],
                    createdAt: DateTime.now(),
                  ))
              .toList();
        }

        // Live stream dari kartu AAC
        _supabaseSubscription?.cancel();
        _supabaseSubscription = SupabaseService.streamVocabCards().listen((cloudCards) {
          if (cloudCards.isNotEmpty && mounted && _activeLevel == 5) {
            final aacItems = cloudCards.map((c) => WritingItemModel(
              id: 'aac_${c.id}',
              levelType: 5,
              targetText: c.label.toUpperCase(),
              hintLabel: c.label,
              imageUrl: c.imageUrl,
              audioUrl: c.audioUrl,
              createdAt: c.createdAt,
            )).toList();
            setState(() {
              _items = aacItems;
            });
          }
        });
      } else {
        // Level 4 (Kata Pendek)
        final cached = await LocalCacheService.getCachedWritingItems(level);
        if (cached.isNotEmpty) {
          initialItems = cached.map((c) {
            final item = WritingItemModel.fromJson(c);
            if (item.targetText == 'IBU') {
              return item.copyWith(
                targetText: UserProfileService.motherCall.toUpperCase(),
                hintLabel: '${UserProfileService.motherCall} Tercinta',
              );
            }
            return item;
          }).toList();
        } else {
          final words = [
            {'t': UserProfileService.fatherCall.toUpperCase(), 'h': '${UserProfileService.fatherCall} Tersayang', 'img': 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=300&auto=format&fit=crop&q=80'},
            {'t': UserProfileService.motherCall.toUpperCase(), 'h': '${UserProfileService.motherCall} Tercinta', 'img': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80'},
            {'t': UserProfileService.childName.toUpperCase(), 'h': 'Namaku ${UserProfileService.childName}', 'img': 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300&auto=format&fit=crop&q=80'},
            {'t': 'TAS', 'h': 'Tas Sekolah', 'img': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&auto=format&fit=crop&q=80'},
            {'t': 'AIR', 'h': 'Air Bersih', 'img': 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?w=300&auto=format&fit=crop&q=80'},
            {'t': 'CAT', 'h': 'Warna Cat', 'img': 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=300&auto=format&fit=crop&q=80'},
            {'t': 'BOLA', 'h': 'Main Bola', 'img': 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=300&auto=format&fit=crop&q=80'},
            {'t': 'BUKU', 'h': 'Buku Belajar', 'img': 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&auto=format&fit=crop&q=80'},
            {'t': 'APEL', 'h': 'Buah Apel', 'img': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=300&auto=format&fit=crop&q=80'},
            {'t': 'SUSU', 'h': 'Minum Susu', 'img': 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300&auto=format&fit=crop&q=80'},
          ];
          initialItems = words
              .map((w) => WritingItemModel(
                    id: 'seed_l4_${w['t']}',
                    levelType: 4,
                    targetText: w['t']!,
                    hintLabel: w['h'],
                    imageUrl: w['img'],
                    createdAt: DateTime.now(),
                  ))
              .toList();
        }

        // Listen to custom writing items stream
        _supabaseSubscription?.cancel();
        _supabaseSubscription = SupabaseService.streamWritingItems(level).listen((data) {
          if (data.isNotEmpty && mounted && _activeLevel == 4) {
            final serverItems = data.map((d) {
              final item = WritingItemModel.fromJson(d);
              if (item.targetText == 'IBU') {
                return item.copyWith(
                  targetText: UserProfileService.motherCall.toUpperCase(),
                  hintLabel: '${UserProfileService.motherCall} Tercinta',
                );
              }
              return item;
            }).toList();
            setState(() {
              _items = serverItems;
            });
            LocalCacheService.cacheWritingItems(data);
          }
        });
      }
    }

    if (mounted) {
      setState(() {
        _items = initialItems;
        _isLoading = false;
      });
      if (playSound) {
        _speakCurrentItemIntro();
      }
    }
  }

  WritingItemModel? get _currentItem {
    if (_items.isEmpty || _currentItemIndex >= _items.length) return null;
    return _items[_currentItemIndex];
  }

  bool get _isMultiCharItem {
    final item = _currentItem;
    if (item == null) return false;
    // Kata pendek (Level 4) dan AAC (Level 5) yang bertahap per huruf.
    // Level 1 (Angka 1-999) langsung menampilkan seluruh digit di kanvas.
    return _activeLevel == 4 || _activeLevel == 5;
  }

  String get _activeTargetChar {
    final item = _currentItem;
    if (item == null) return '';
    if (_isMultiCharItem) {
      if (_currentCharIndexInWord < item.targetText.length) {
        return item.targetText[_currentCharIndexInWord];
      }
    }
    return item.targetText;
  }

  Future<void> _speakCurrentItemIntro() async {
    final item = _currentItem;
    if (item == null) return;
    final lang = AudioEngineService.currentLanguage;
    String textToSpeak = item.targetText;

    String? phonetic;
    if (_activeLevel == 6) {
      // Ucapkan huruf hijaiyah dengan file audio makhraj asli
      textToSpeak = item.targetText;
      phonetic = AudioEngineService.getArabicPhoneticFallback(item.hintLabel ?? item.targetText);
    } else if (lang == 'en-US') {
      if (_activeLevel == 1) {
        textToSpeak = 'Number ${item.targetText}';
      } else if (_activeLevel == 2) {
        textToSpeak = 'Letter ${item.targetText}';
      } else if (_activeLevel == 3) {
        textToSpeak = 'Lowercase ${item.targetText}';
      } else {
        textToSpeak = 'Word ${item.targetText}';
      }
    } else if (lang == 'ar-SA') {
      if (_activeLevel == 1) {
        textToSpeak = 'الرقم ${item.targetText}';
      } else if (_activeLevel == 2 || _activeLevel == 3 || _activeLevel == 6) {
        textToSpeak = 'حرف ${item.targetText}';
      } else {
        textToSpeak = 'كلمة ${item.targetText}';
      }
    } else {
      // Default: Bahasa Indonesia
      if (_activeLevel == 1) {
        textToSpeak = 'Angka ${item.targetText}';
      } else if (_activeLevel == 2) {
        textToSpeak = 'Huruf ${item.targetText}';
      } else if (_activeLevel == 3) {
        textToSpeak = 'Huruf kecil ${item.targetText}';
      } else {
        textToSpeak = 'Kata ${item.targetText}';
      }
    }
    await AudioEngineService.speakWord(
      text: textToSpeak,
      phoneticFallback: phonetic,
      audioUrl: item.audioUrl,
    );
  }


  // Pointer drawing events (Zero-latency direct canvas repaint)
  void _onPointerDown(PointerDownEvent event) {
    if (_isAliEchoActive) return;
    _autoCheckTimer?.cancel();
    _activeStrokes[event.pointer] = DrawingStroke(
      pointerId: event.pointer,
      points: [
        StrokePoint(
          offset: event.localPosition,
          color: _strokeColor,
          strokeWidth: _strokeWidth,
        ),
      ],
      color: _strokeColor,
      strokeWidth: _strokeWidth,
    );
    _canvasNotifier.notify();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_isAliEchoActive) return;
    final stroke = _activeStrokes[event.pointer];
    if (stroke != null) {
      stroke.points.add(
        StrokePoint(
          offset: event.localPosition,
          color: _strokeColor,
          strokeWidth: _strokeWidth,
        ),
      );
      _canvasNotifier.notify();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isAliEchoActive) return;
    final stroke = _activeStrokes.remove(event.pointer);
    if (stroke != null) {
      // Pre-compute & cache Path for instantaneous 120fps repaint
      if (stroke.points.length > 1) {
        final path = Path();
        path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);
        for (int i = 1; i < stroke.points.length; i++) {
          final p0 = stroke.points[i - 1].offset;
          final p1 = stroke.points[i].offset;
          path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        }
        stroke.cachedPath = path;
      }
      _completedStrokes.add(stroke);
      _canvasNotifier.notify();

      _autoCheckTimer?.cancel();

      // Only schedule auto-check if EVERY single line of the pattern has been completed!
      // If child is still writing or any line is missing, DO NOT check prematurely.
      final target = _activeTargetChar;
      final refStrokes = WritingPathData.getStrokesForChar(target);
      final allLinesDrawn = WritingPathData.areAllLinesDrawn(
        userStrokes: _completedStrokes,
        refStrokes: refStrokes,
        canvasSize: _currentCanvasSize,
        charCount: target.length,
      );

      if (allLinesDrawn) {
        _autoCheckTimer = Timer(const Duration(milliseconds: 2500), () {
          if (mounted && !_isAliEchoActive) {
            _evaluateProgress();
          }
        });
      }
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _activeStrokes.remove(event.pointer);
    _canvasNotifier.notify();
  }

  // Check if stroke meets child-friendly threshold (minimum total points + ALL pattern lines covered)
  void _evaluateProgress() {
    final target = _activeTargetChar;
    final refStrokes = WritingPathData.getStrokesForChar(target);

    // Require all lines/strokes of the pattern to be completed
    final allLinesDrawn = WritingPathData.areAllLinesDrawn(
      userStrokes: _completedStrokes,
      refStrokes: refStrokes,
      canvasSize: _currentCanvasSize,
      charCount: target.length,
      charLabel: target,
    );

    if (!allLinesDrawn) return;

    // Measure accuracy on actual rendered canvas size (Threshold dibuat ramah anak & fleksibel)
    final accuracy = WritingPathData.calculateAccuracy(
      userStrokes: _completedStrokes,
      refStrokes: refStrokes,
      canvasSize: _currentCanvasSize,
      charCount: target.length,
      charLabel: target,
    );

    if (accuracy >= 0.28) {
      _triggerAliEchoAndAppreciation();
    }
  }

  void _manualCheckPattern() {
    _autoCheckTimer?.cancel();
    HapticFeedback.mediumImpact();
    final target = _activeTargetChar;
    final refStrokes = WritingPathData.getStrokesForChar(target);

    int totalPointsDrawn = 0;
    for (final s in _completedStrokes) {
      totalPointsDrawn += s.points.length;
    }

    if (totalPointsDrawn < 8) {
      AudioEngineService.speakWord(text: 'Ayo mulai menulis polanya terlebih dahulu ya!');
      return;
    }

    final accuracy = WritingPathData.calculateAccuracy(
      userStrokes: _completedStrokes,
      refStrokes: refStrokes,
      canvasSize: _currentCanvasSize,
      charCount: target.length,
      charLabel: target,
    );

    if (accuracy >= 0.25) {
      _triggerAliEchoAndAppreciation();
    } else {
      AudioEngineService.speakWord(text: 'Bagus! Ayo teruskan coretannya sampai selesai ya!');
    }
  }

  // Ali writes back with smooth animated brush, then praises
  Future<void> _triggerAliEchoAndAppreciation() async {
    if (_isAliEchoActive) return;

    HapticFeedback.heavyImpact();
    setState(() {
      _isAliEchoActive = true;
    });

    // Start Ali's writing animation
    _aliEchoController.reset();
    await _aliEchoController.forward();

    final item = _currentItem;
    if (item == null) return;

    final hasMultipleChars = _isMultiCharItem;
    final lang = AudioEngineService.currentLanguage;

    if (hasMultipleChars && _currentCharIndexInWord < item.targetText.length - 1) {
      // Next letter or digit in the same item
      final isNumber = _activeLevel == 1;
      String nextCharPraise = isNumber
          ? 'Hebat! Angka $_activeTargetChar selesai!'
          : 'Hebat! Huruf $_activeTargetChar selesai!';
      if (lang == 'en-US') {
        nextCharPraise = isNumber
            ? 'Great! Digit $_activeTargetChar is done!'
            : 'Great! Letter $_activeTargetChar is done!';
      } else if (lang == 'ar-SA') {
        nextCharPraise = isNumber
            ? 'ممتاز! رقم $_activeTargetChar انتهى!'
            : 'ممتاز! حرف $_activeTargetChar انتهى!';
      }
      await AudioEngineService.speakWord(text: nextCharPraise);
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _currentCharIndexInWord++;
          _resetStrokes();
          _isAliEchoActive = false;
        });
        String nextPrompt = isNumber
            ? 'Ayo tulis angka $_activeTargetChar'
            : 'Ayo tulis huruf $_activeTargetChar';
        if (lang == 'en-US') {
          nextPrompt = isNumber
              ? 'Now write digit $_activeTargetChar'
              : 'Now write letter $_activeTargetChar';
        } else if (lang == 'ar-SA') {
          nextPrompt = isNumber
              ? 'هيا اكتب رقم $_activeTargetChar'
              : 'هيا اكتب حرف $_activeTargetChar';
        }
        await AudioEngineService.speakWord(text: nextPrompt);
      }
    } else {
      // Completed full character or full word!
      final name = UserProfileService.childName;
      List<String> praises = [
        'Hebat sekali, $name berhasil!',
        'Pintar! Tulisanmu luar biasa!',
        'Masya Allah, hebatnya $name!',
        'Keren banget, $name!',
      ];
      if (lang == 'en-US') {
        praises = [
          'Awesome job, well done!',
          'Brilliant! You did it!',
          'Fantastic writing, super smart!',
          'You are amazing!',
        ];
      } else if (lang == 'ar-SA') {
        praises = [
          'ما شاء الله، ممتاز جداً!',
          'رائع! خطك جميل جداً!',
          'أحسنت يا بطل!',
          'عمل رائع ومتميز!',
        ];
      }
      final chosenPraise = praises[DateTime.now().millisecond % praises.length];

      if (mounted) {
        setState(() {
          _showCelebration = true;
          _praiseMessage = chosenPraise;
        });
      }

      if (_activeLevel == 6) {
        // 1. Putar audio qari asli hurufnya terlebih dahulu
        await AudioEngineService.speakWord(
          text: item.targetText,
          audioUrl: item.audioUrl,
        );
        // Jeda sejenak agar suara qari selesai
        await Future.delayed(const Duration(milliseconds: 700));
        // 2. Berikan kalimat pujian hangat
        await AudioEngineService.speakWord(text: chosenPraise);
      } else {
        await AudioEngineService.speakWord(text: '${item.targetText}! $chosenPraise');
      }

      // Auto advance or wait for user to hit next (allow praise speech to finish completely)
      await Future.delayed(const Duration(milliseconds: 4500));
      if (mounted) {
        if (!SubscriptionService.isPro && _activeLevel == 1 && _currentItemIndex >= 9) {
          setState(() {
            _showCelebration = false;
            _isAliEchoActive = false;
          });
          AliPaywallDialog.show(
            context,
            featureName: 'Latihan Menulis Angka 11 - 999',
            featureDescription: 'Buka latihan tracing angka puluhan, ratusan, hingga 999 tanpa batas bersama Ali Pro.',
          );
          return;
        }
        setState(() {
          _showCelebration = false;
          _isAliEchoActive = false;
          _resetStrokes();
          _currentCharIndexInWord = 0;
          if (_currentItemIndex < _items.length - 1) {
            _currentItemIndex++;
          }
        });
        _speakCurrentItemIntro();
      }
    }
  }

  void _resetStrokes() {
    _autoCheckTimer?.cancel();
    _completedStrokes.clear();
    _activeStrokes.clear();
    _canvasNotifier.notify();
  }

  void _clearCanvas() {
    HapticFeedback.lightImpact();
    _resetStrokes();
    setState(() {
      _isAliEchoActive = false;
    });
  }

  void _openAddWordModal() {
    AddWritingWordModal.show(
      context: context,
      defaultLevelType: _activeLevel == 5 ? 5 : 4,
      onWordAdded: () => _loadLevelContent(_activeLevel),
    );
  }

  void _openNumberPickerDialog() {
    final textController = TextEditingController(text: (_currentItemIndex + 1).toString());
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r24)),
          title: const Row(
            children: [
              Icon(Iconsax.calculator, color: AppColors.accentBrand),
              SizedBox(width: 8),
              Text(
                'Pilih Angka (1 - 999)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ketik angka yang ingin ditulis oleh ${UserProfileService.childName} (1 sampai 999):',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Misal: 25, 100, 999',
                  filled: true,
                  fillColor: AppColors.surfacePill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilihan Cepat:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [1, 10, 25, 50, 100, 250, 500, 999].map((val) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    onTap: () {
                      textController.text = val.toString();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surfacePill,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Text(
                        val.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pureBlack,
                foregroundColor: AppColors.accentLemon,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
              ),
              onPressed: () {
                final val = int.tryParse(textController.text.trim());
                if (val != null && val >= 1 && val <= 999) {
                  if (!SubscriptionService.isPro && val > 10) {
                    Navigator.pop(ctx);
                    AliPaywallDialog.show(
                      context,
                      featureName: 'Latihan Menulis Angka 11 - 999',
                      featureDescription: 'Akses menulis angka puluhan, ratusan hingga 999 lengkap dengan panduan garis stroke bersama Ali Pro.',
                    );
                    return;
                  }
                  Navigator.pop(ctx);
                  final targetIndex = val - 1;
                  if (targetIndex < _items.length) {
                    setState(() {
                      _currentItemIndex = targetIndex;
                      _currentCharIndexInWord = 0;
                      _resetStrokes();
                      _isAliEchoActive = false;
                    });
                    _speakCurrentItemIntro();
                  }
                }
              },
              child: const Text('Pilih Angka', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _currentItem;
    final isWordLevel = _activeLevel == 4 || _activeLevel == 5;
    final media = MediaQuery.sizeOf(context);
    final isTablet = media.shortestSide >= 600;
    final isLandscape = media.width > media.height;

    // =========================================================================
    // 1. TABLET LANDSCAPE: Two-Column Split Screen (Sidebar Kiri + Kanvas Kanan)
    // =========================================================================
    if (isTablet && isLandscape) {
      return Scaffold(
        backgroundColor: AppColors.bgCanvas,
        body: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  // Kolom Kiri (Sidebar Koleksi Kata Bergambar): Lebar 350px
                  SizedBox(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                          child: AliHeaderSection(
                            title: 'Belajar Menulis',
                            subtitle: isWordLevel ? 'Pilih kata untuk mulai menulis' : null,
                            onBackTap: widget.onBack,
                            actionWidget: isWordLevel
                                ? AliButton(
                                    label: '+ Kata',
                                    variant: AliButtonVariant.primaryHighContrast,
                                    onPressed: _openAddWordModal,
                                  )
                                : _activeLevel == 1
                                    ? AliButton(
                                        label: 'Pilih #',
                                        variant: AliButtonVariant.primaryHighContrast,
                                        onPressed: _openNumberPickerDialog,
                                      )
                                    : null,
                            bottomWidget: _buildLevelTabSelector(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: isWordLevel
                              ? _buildTabletSidebarWordList()
                              : _buildTabletSidebarItemGrid(),
                        ),
                      ],
                    ),
                  ),

                  // Garis Pemisah Elegan
                  Container(width: 1.2, color: AppColors.borderCard),

                  // Kolom Kanan: Target Card Besar + Kanvas Lega + Kontrol
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        if (item != null)
                          _buildTargetHeader(item, isWordLevel, imageSize: 84),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _buildCanvasContainer(),
                        ),
                        const SizedBox(height: 8),
                        _buildCheckAndClearRow(),
                        const SizedBox(height: 6),
                        _buildBottomControls(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),

              if (_showCelebration) _buildCelebrationPopup(),
            ],
          ),
        ),
      );
    }

    // =========================================================================
    // 2. MOBILE & TABLET PORTRAIT: Vertical Stack Berbobot Ideal
    // =========================================================================
    final targetImageSize = isTablet ? 76.0 : 56.0;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Header Section (Standardized Design System)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: AliHeaderSection(
                    title: '${UserProfileService.childName} Belajar Menulis',
                    onBackTap: widget.onBack,
                    actionWidget: isWordLevel
                        ? AliButton(
                            label: '+ Tambah Kata',
                            variant: AliButtonVariant.primaryHighContrast,
                            onPressed: _openAddWordModal,
                          )
                        : _activeLevel == 1
                            ? AliButton(
                                label: 'Pilih Angka',
                                variant: AliButtonVariant.primaryHighContrast,
                                onPressed: _openNumberPickerDialog,
                              )
                            : null,
                    bottomWidget: _buildLevelTabSelector(),
                  ),
                ),

                // Strip Pemilih Kata Bergambar (Khusus Level Kata / AAC)
                if (isWordLevel) _buildWordSelectorStrip(isTablet: isTablet),

                const SizedBox(height: 4),

                // Card Target Header (Dengan Gambar Thumbnail & Kotak Huruf)
                if (item != null)
                  _buildTargetHeader(item, isWordLevel, imageSize: targetImageSize),

                const SizedBox(height: 8),

                // Kanvas Menggambar Tracing (Selebar Layar dengan Margin Kiri-Kanan 16)
                Expanded(
                  child: _buildCanvasContainer(),
                ),

                const SizedBox(height: 6),

                // Tombol Hapus & Periksa Tulisan
                _buildCheckAndClearRow(),

                const SizedBox(height: 6),

                // Palette Warna & Navigasi Bawah
                _buildBottomControls(),

                const SizedBox(height: 6),
              ],
            ),

            if (_showCelebration) _buildCelebrationPopup(),
          ],
        ),
      ),
    );
  }

  Size _currentCanvasSize = const Size(360, 360);

  /// Kontainer Kanvas Tracing Selebar Layar dengan Padding Kiri-Kanan 16
  Widget _buildCanvasContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r28),
        border: Border.all(color: AppColors.borderCard, width: 2.0),
        boxShadow: AppShadows.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _currentCanvasSize = Size(constraints.maxWidth, constraints.maxHeight);
            return Stack(
              children: [
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.accentBrand),
                  ),

                // 1. Dotted Reference Guide Layer (RepaintBoundary caches bitmap)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _DottedGuidePainter(
                        refStrokes: WritingPathData.getStrokesForChar(_activeTargetChar),
                        charLabel: _activeTargetChar,
                      ),
                    ),
                  ),
                ),

            // 2. Child's Freeform Stroke Listener (Zero-latency direct canvas repaint)
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: _onPointerDown,
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                onPointerCancel: _onPointerCancel,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _WritingCanvasPainter(
                      repaint: _canvasNotifier,
                      completedStrokes: _completedStrokes,
                      activeStrokesMap: _activeStrokes,
                    ),
                  ),
                ),
              ),
            ),

            // 3. Ali Echo Layer (Animasi Kuas Halus Ali Menuliskan Kembali)
            if (_isAliEchoActive)
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _AliEchoPainter(
                      refStrokes: WritingPathData.getStrokesForChar(_activeTargetChar),
                      charLabel: _activeTargetChar,
                      animation: _aliEchoController,
                    ),
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

  /// Tombol Aksi di Luar Kanvas: Hapus Goresan & Periksa Tulisan
  Widget _buildCheckAndClearRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tombol Hapus / Refresh
          GestureDetector(
            onTap: _clearCanvas,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.borderCard),
                boxShadow: AppShadows.cardShadow,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.refresh, size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 6),
                  Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Tombol Periksa Pola
          GestureDetector(
            onTap: _manualCheckPattern,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfacePillDark,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: AppShadows.floatingDockShadow,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, size: 16, color: AppColors.accentLemon),
                  SizedBox(width: 6),
                  Text(
                    'Periksa Tulisan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Strip Pemilih Kata Bergambar Horizontal (Mobile & Tablet Portrait)
  Widget _buildWordSelectorStrip({bool isTablet = false}) {
    if (_items.isEmpty) return const SizedBox.shrink();

    final stripHeight = isTablet ? 72.0 : 60.0;
    final thumbSize = isTablet ? 44.0 : 36.0;

    return Container(
      height: stripHeight,
      margin: const EdgeInsets.only(top: 4, bottom: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _items[index];
          final isSelected = index == _currentItemIndex;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _currentItemIndex = index;
                _currentCharIndexInWord = 0;
                _resetStrokes();
                _isAliEchoActive = false;
              });
              _speakCurrentItemIntro();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfacePillDark : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(
                  color: isSelected ? AppColors.accentLemon : AppColors.borderCard,
                  width: isSelected ? 1.8 : 1.0,
                ),
                boxShadow: isSelected ? AppShadows.cardShadow : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      child: SizedBox(
                        width: thumbSize,
                        height: thumbSize,
                        child: AliNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else ...[
                    Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accentLemon : AppColors.surfacePill,
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                      child: Center(
                        child: Text(
                          item.targetText.isNotEmpty ? item.targetText[0] : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 18 : 14,
                            color: isSelected ? AppColors.pureBlack : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.targetText,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12.5,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      if (item.hintLabel != null)
                        Text(
                          item.hintLabel!,
                          style: TextStyle(
                            fontSize: isTablet ? 10.5 : 9.5,
                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Sidebar Kolom Kiri Khusus Tablet Landscape (Daftar Kata Bergambar)
  Widget _buildTabletSidebarWordList() {
    if (_items.isEmpty) {
      return const Center(
        child: Text('Belum ada kosa kata.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 8),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _items[index];
        final isSelected = index == _currentItemIndex;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              _currentItemIndex = index;
              _currentCharIndexInWord = 0;
              _resetStrokes();
              _isAliEchoActive = false;
            });
            _speakCurrentItemIntro();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.surfacePillDark : AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(
                color: isSelected ? AppColors.accentLemon : AppColors.borderCard,
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected ? AppShadows.cardShadow : null,
            ),
            child: Row(
              children: [
                if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: AliNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover),
                    ),
                  )
                else
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accentLemon : AppColors.surfacePill,
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: Center(
                      child: Text(
                        item.targetText.isNotEmpty ? item.targetText[0] : '?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.pureBlack : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.targetText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      if (item.hintLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.hintLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.edit_rounded, size: 20, color: AppColors.accentLemon),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Sidebar Kolom Kiri untuk Angka & Huruf (Tablet Landscape Grid)
  Widget _buildTabletSidebarItemGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final isSelected = index == _currentItemIndex;
        final isLocked = !SubscriptionService.isPro && _activeLevel == 1 && index > 9;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            if (isLocked) {
              AliPaywallDialog.show(
                context,
                featureName: 'Latihan Menulis Angka 11 - 999',
                featureDescription: 'Buka latihan tracing angka puluhan, ratusan, hingga 999 tanpa batas bersama Ali Pro.',
              );
              return;
            }
            setState(() {
              _currentItemIndex = index;
              _currentCharIndexInWord = 0;
              _resetStrokes();
              _isAliEchoActive = false;
            });
            _speakCurrentItemIntro();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.surfacePillDark
                  : (isLocked ? const Color(0xFFF1F5F9) : AppColors.surfaceCard),
              borderRadius: BorderRadius.circular(AppRadius.r16),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentLemon
                    : (isLocked ? const Color(0xFFCBD5E1) : AppColors.borderCard),
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  item.targetText,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isSelected
                        ? Colors.white
                        : (isLocked ? const Color(0xFF94A3B8) : AppColors.textPrimary),
                  ),
                ),
                if (isLocked)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(Icons.lock_rounded, size: 12, color: Color(0xFF64748B)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Overlay Apresiasi Bintang
  Widget _buildCelebrationPopup() {
    return Stack(
      children: [
        const AliCelebrationOverlay(),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: AppColors.pureBlack.withOpacity(0.92),
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: AppColors.accentLemon, width: 2),
              boxShadow: AppShadows.floatingDockShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 56, color: AppColors.accentLemon),
                const SizedBox(height: 8),
                Text(
                  _praiseMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }



  // Level Tab Selector (Level 1 s/d 5)
  Widget _buildLevelTabSelector() {
    final levels = [
      {'lvl': 1, 'title': 'L1: 1 2 3', 'desc': 'Angka', 'isFree': true},
      {'lvl': 6, 'title': 'L2: أ ب ت', 'desc': 'Hijaiyah', 'isFree': true},
      {'lvl': 2, 'title': 'L3: A B C', 'desc': 'Kapital', 'isFree': false},
      {'lvl': 3, 'title': 'L4: a b c', 'desc': 'Kecil', 'isFree': false},
      {'lvl': 4, 'title': 'L5: Kata', 'desc': 'Pendek', 'isFree': false},
      {'lvl': 5, 'title': 'L6: AAC', 'desc': 'Kosa Kata', 'isFree': false},
    ];

    final isPro = SubscriptionService.isPro;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Row(
        children: levels.map((lvl) {
          final isSelected = _activeLevel == lvl['lvl'];
          final isFree = (lvl['isFree'] as bool?) ?? false;
          final isLocked = !isPro && !isFree;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                if (isLocked) {
                  AliPaywallDialog.show(
                    context,
                    featureName: 'Latihan Menulis ${lvl['title']}',
                    featureDescription: 'Buka latihan tracing huruf kapital, huruf kecil, kata, dan kosa kata AAC tanpa batas bersama Ali Pro.',
                  );
                  return;
                }
                _loadLevelContent(lvl['lvl'] as int);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.pureBlack
                      : (isLocked ? const Color(0xFFF1F5F9) : AppColors.surfaceCard),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentLemon
                        : (isLocked ? const Color(0xFFCBD5E1) : AppColors.borderCard),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    if (isLocked) ...[
                      const Icon(Icons.lock_rounded, size: 12, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      lvl['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.accentLemon
                            : (isLocked ? const Color(0xFF64748B) : AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${lvl['desc']})',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.pureWhite.withOpacity(0.7)
                            : (isLocked ? const Color(0xFF94A3B8) : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Display target letter or full word with active letter highlighted and image
  Widget _buildTargetHeader(WritingItemModel item, bool isWordLevel, {double imageSize = 64}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.r24),
          border: Border.all(color: AppColors.borderCard, width: 1.2),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar Thumbnail Kartu Kosa Kata (Level 4 & 5)
            if (isWordLevel && item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  AudioEngineService.speakWord(text: item.targetText);
                },
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard, width: 1.2),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AliNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppColors.pureBlack.withValues(alpha: 0.65),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Iconsax.volume_high, size: 11, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Target character / Word letters
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.hintLabel != null && isWordLevel) ...[
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.hintLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            final isHij = _activeLevel == 6;
                            final textToSpeak = isHij ? item.targetText : item.targetText;
                            final phonetic = isHij ? AudioEngineService.getArabicPhoneticFallback(item.hintLabel ?? item.targetText) : null;
                            AudioEngineService.speakWord(
                              text: textToSpeak,
                              phoneticFallback: phonetic,
                              audioUrl: item.audioUrl,
                            );
                          },
                          child: const Icon(Iconsax.volume_high, size: 15, color: AppColors.accentBrand),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                  if (_isMultiCharItem)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxW = constraints.maxWidth;
                        final len = item.targetText.length;
                        if (len == 0) return const SizedBox.shrink();

                        const double gap = 6.0;
                        final double totalGaps = (len - 1) * gap;
                        final double singleRowTileW = (maxW - totalGaps) / len;

                        // Check if fits single row comfortably
                        final bool fitsSingleRow = singleRowTileW >= 30.0;
                        final double tileWidth = fitsSingleRow
                            ? singleRowTileW.clamp(30.0, 48.0)
                            : 34.0;
                        final double tileHeight = tileWidth * 1.15;
                        final double fontSize = (tileWidth * 0.55).clamp(14.0, 22.0);

                        return Wrap(
                          spacing: gap,
                          runSpacing: 6.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: List.generate(len, (i) {
                            final isCurrent = i == _currentCharIndexInWord;
                            final isPassed = i < _currentCharIndexInWord;
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _currentCharIndexInWord = i;
                                  _resetStrokes();
                                  _isAliEchoActive = false;
                                });
                                _speakCurrentItemIntro();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: tileWidth,
                                height: tileHeight,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.accentLemon
                                      : isPassed
                                          ? AppColors.accentLime.withValues(alpha: 0.25)
                                          : AppColors.surfacePill,
                                  borderRadius: BorderRadius.circular(tileWidth > 36 ? AppRadius.r12 : AppRadius.r8),
                                  border: Border.all(
                                    color: isCurrent
                                        ? AppColors.pureBlack
                                        : isPassed
                                            ? AppColors.accentLime
                                            : AppColors.borderCard,
                                    width: isCurrent ? 2.0 : 1.0,
                                  ),
                                  boxShadow: isCurrent ? AppShadows.cardShadow : null,
                                ),
                                child: Text(
                                  item.targetText[i],
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w900,
                                    color: isCurrent ? AppColors.pureBlack : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    )
                  else
                    Row(
                      children: [
                        Text(
                          item.targetText,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            final isHij = _activeLevel == 6;
                            final textToSpeak = isHij ? item.targetText : item.targetText;
                            final phonetic = isHij ? AudioEngineService.getArabicPhoneticFallback(item.hintLabel ?? item.targetText) : null;
                            AudioEngineService.speakWord(
                              text: textToSpeak,
                              phoneticFallback: phonetic,
                              audioUrl: item.audioUrl,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.surfacePill,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: const Icon(Iconsax.volume_high, size: 18, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Contohkan (Demo Goresan Ali Beranimasi)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            AudioEngineService.speakWord(text: 'Lihat Ali contohkan cara menulisnya ya!');
                            _aliEchoController.reset();
                            setState(() => _isAliEchoActive = true);
                            _aliEchoController.forward();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accentLemon,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              border: Border.all(color: AppColors.pureBlack, width: 1.2),
                              boxShadow: AppShadows.cardShadow,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_circle_fill_rounded, size: 16, color: AppColors.pureBlack),
                                SizedBox(width: 4),
                                Text(
                                  'Contohkan',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.pureBlack,
                                    fontFamily: AppTypography.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Palette & Item Switcher (Previous / Next)
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Item Button
          GestureDetector(
            onTap: _currentItemIndex > 0
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _currentItemIndex--;
                      _currentCharIndexInWord = 0;
                      _resetStrokes();
                    });
                    _speakCurrentItemIntro();
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _currentItemIndex > 0 ? AppColors.surfaceCard : AppColors.surfacePill,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.borderCard),
              ),
              child: Icon(
                Iconsax.arrow_left_2,
                size: 20,
                color: _currentItemIndex > 0 ? AppColors.textPrimary : AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),

          // Color Palette Swatches
          Row(
            children: _palette.map((color) {
              final isSelected = _strokeColor == color;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _strokeColor = color);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.pureBlack : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(Icons.check, size: 16, color: AppColors.pureWhite),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),

          // Next Item Button
          GestureDetector(
            onTap: _currentItemIndex < _items.length - 1
                ? () {
                    HapticFeedback.selectionClick();
                    if (!SubscriptionService.isPro && _activeLevel == 1 && _currentItemIndex >= 9) {
                      AliPaywallDialog.show(
                        context,
                        featureName: 'Latihan Menulis Angka 11 - 999',
                        featureDescription: 'Buka latihan tracing angka puluhan, ratusan, hingga 999 tanpa batas bersama Ali Pro.',
                      );
                      return;
                    }
                    setState(() {
                      _currentItemIndex++;
                      _currentCharIndexInWord = 0;
                      _resetStrokes();
                    });
                    _speakCurrentItemIntro();
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _currentItemIndex < _items.length - 1 ? AppColors.surfaceCard : AppColors.surfacePill,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.borderCard),
              ),
              child: Icon(
                Iconsax.arrow_right_3,
                size: 20,
                color: _currentItemIndex < _items.length - 1 ? AppColors.textPrimary : AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// PAINTERS: Dotted Guide, User Drawing Canvas, and Ali Echo
// -------------------------------------------------------------

/// Dotted Line Reference Guide
class _DottedGuidePainter extends CustomPainter {
  final List<NormalizedStroke> refStrokes;
  final String charLabel;

  _DottedGuidePainter({required this.refStrokes, required this.charLabel});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || refStrokes.isEmpty) return;

    final charLen = charLabel.length;
    final fittedRect = WritingPathData.getFittedRect(
      canvasSize: size,
      charCount: charLen,
      charLabel: charLabel,
    );

    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(charLabel);
    
    // Strip Arabic diacritics (Fatha, Kasra, Damma, etc.) to get the base character
    final baseCharLabel = charLabel.replaceAll(RegExp(r'[\u064B-\u065F]'), '');

    // =========================================================================
    // KHUSUS HIJAIYAH: Real Calligraphy Vector Path (Dari SVG) + Dashed Midline
    // =========================================================================
    if (isArabic && HijaiyahSvgData.hasCalligraphy(baseCharLabel)) {
      final calligPath = HijaiyahSvgData.getCalligraphyPath(baseCharLabel, fittedRect);
      if (calligPath != null) {
        // 1. Siluet lorong kaligrafi asli
        final calligFillPaint = Paint()
          ..color = const Color(0xFFF1F5F9)
          ..style = PaintingStyle.fill;
        final calligBorderPaint = Paint()
          ..color = const Color(0xFFCBD5E1)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        canvas.drawPath(calligPath, calligFillPaint);
        canvas.drawPath(calligPath, calligBorderPaint);

        // 2. Garis putus-putus di TENGAH badan (Midline Tracing Guide)
        final strokePaths = <Path>[];
        final allMappedPoints = <List<Offset>>[];

        for (final stroke in refStrokes) {
          if (stroke.points.isEmpty) continue;
          final pts = stroke.points.map((p) => WritingPathData.mapPointToCanvas(p, fittedRect)).toList();
          allMappedPoints.add(pts);
          strokePaths.add(WritingPathData.buildSmoothPath(pts));
        }

        final dottedStrokePaint = Paint()
          ..color = AppColors.pureBlack.withOpacity(0.70)
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        final dotCenterCorePaint = Paint()
          ..color = AppColors.pureBlack.withOpacity(0.75)
          ..style = PaintingStyle.fill;

        int badgeCounter = 1;
        for (int strokeIndex = 0; strokeIndex < strokePaths.length; strokeIndex++) {
          final path = strokePaths[strokeIndex];
          final pts = allMappedPoints[strokeIndex];
          final isDot = strokeIndex == strokePaths.length - 1 && pts.length <= 2;

          if (isDot) {
            final center = pts.first;
            canvas.drawCircle(center, 5.0, dotCenterCorePaint);
            continue;
          }

          _drawDashedPath(
            canvas: canvas,
            path: path,
            paint: dottedStrokePaint,
            dashLength: 7.0,
            dashGap: 6.0,
          );

          // Panah penunjuk arah
          if (pts.length >= 2) {
            final last = pts.last;
            final prev = pts[pts.length - 2];
            final dir = (last - prev);
            if (dir.distance > 0.01) {
              final normDir = dir / dir.distance;
              final perpDir = Offset(-normDir.dy, normDir.dx);
              final arrowHeadPath = Path();
              final tip = last;
              final leftWing = tip - (normDir * 8.0) + (perpDir * 4.5);
              final rightWing = tip - (normDir * 8.0) - (perpDir * 4.5);
              arrowHeadPath.moveTo(tip.dx, tip.dy);
              arrowHeadPath.lineTo(leftWing.dx, leftWing.dy);
              arrowHeadPath.lineTo(rightWing.dx, rightWing.dy);
              arrowHeadPath.close();

              final arrowPaint = Paint()
                ..color = AppColors.pureBlack.withOpacity(0.70)
                ..style = PaintingStyle.fill;
              canvas.drawPath(arrowHeadPath, arrowPaint);
            }
          }

          // Badge nomor urutan
          final start = pts.first;
          final badgeNumber = (badgeCounter++).toString();

          final badgeBgPaint = Paint()..color = AppColors.surfacePillDark;
          canvas.drawCircle(start, 9.5, badgeBgPaint);

          final badgeBorderPaint = Paint()
            ..color = AppColors.accentLemon
            ..strokeWidth = 1.6
            ..style = PaintingStyle.stroke;
          canvas.drawCircle(start, 9.5, badgeBorderPaint);

          final badgeTextPainter = TextPainter(
            text: TextSpan(
              text: badgeNumber,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          badgeTextPainter.paint(
            canvas,
            Offset(start.dx - badgeTextPainter.width / 2, start.dy - badgeTextPainter.height / 2),
          );
        }
        return;
      }
    }

    // Hitung stroke paths utuh (untuk Semua Karakter: Angka, Latin & Hijaiyah)
    final strokePaths = <Path>[];
    final allMappedPoints = <List<Offset>>[];

    for (final stroke in refStrokes) {
      if (stroke.points.isEmpty) continue;
      final pts = stroke.points.map((p) => WritingPathData.mapPointToCanvas(p, fittedRect)).toList();
      allMappedPoints.add(pts);
      strokePaths.add(WritingPathData.buildSmoothPath(pts));
    }

    // 1. Gambar badan lorong acuan (Tube) yang ramping & proporsional
    final tubeWidth = (fittedRect.height * 0.085).clamp(20.0, 36.0);
    final dotRadius = (tubeWidth * 0.38).clamp(8.0, 13.0);

    // Outline luar (Border pembatas halus)
    final outerOutlinePaint = Paint()
      ..color = const Color(0xFFD8DDE3)
      ..strokeWidth = tubeWidth + 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Isi badan huruf (Sangat halus, bersih & tidak bloated)
    final innerBodyPaint = Paint()
      ..color = const Color(0xFFF1F4F7)
      ..strokeWidth = tubeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Paint khusus titik aksen (misal titik huruf Hijaiyah Ba, Ta, Tsa, Jim, Nun, dll)
    final dotFillPaint = Paint()
      ..color = const Color(0xFFF1F4F7)
      ..style = PaintingStyle.fill;
    final dotOutlinePaint = Paint()
      ..color = const Color(0xFFD8DDE3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final dotCenterCorePaint = Paint()
      ..color = AppColors.pureBlack.withOpacity(0.70)
      ..style = PaintingStyle.fill;

    // Filter stroke: stroke utama vs titik
    final isDotStroke = <bool>[];
    for (int i = 0; i < refStrokes.length; i++) {
      final stroke = refStrokes[i];
      if (stroke.points.isEmpty) {
        isDotStroke.add(false);
        continue;
      }
      final pts = allMappedPoints[i];
      double totalDist = 0.0;
      for (int k = 0; k < pts.length - 1; k++) {
        totalDist += (pts[k + 1] - pts[k]).distance;
      }
      // Dianggap titik jika jarak antar titiknya sangat pendek (< 20 px)
      isDotStroke.add(totalDist < 20.0);
    }

    // Gambar tabung goresan untuk semua karakter (Angka, Latin & Hijaiyah)
    for (int i = 0; i < strokePaths.length; i++) {
      if (!isDotStroke[i]) {
        canvas.drawPath(strokePaths[i], outerOutlinePaint);
        canvas.drawPath(strokePaths[i], innerBodyPaint);
      } else {
        final center = allMappedPoints[i].first;
        canvas.drawCircle(center, dotRadius + 1.5, dotOutlinePaint);
        canvas.drawCircle(center, dotRadius, dotFillPaint);
      }
    }

    // 2. Garis putus-putus (Dashed Midline) & Badge nomor
    final dottedStrokePaint = Paint()
      ..color = AppColors.pureBlack.withOpacity(0.65)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    int badgeCounter = 1;
    for (int strokeIndex = 0; strokeIndex < strokePaths.length; strokeIndex++) {
      final path = strokePaths[strokeIndex];
      final pts = allMappedPoints[strokeIndex];
      final isDot = isDotStroke[strokeIndex];

      if (isDot) {
        // Gambar intisari titik hitam di tengah
        final center = pts.first;
        canvas.drawCircle(center, 4.0, dotCenterCorePaint);
        continue;
      }

      _drawDashedPath(
        canvas: canvas,
        path: path,
        paint: dottedStrokePaint,
        dashLength: 7.0,
        dashGap: 6.0,
      );

      // Panah arah goresan di ujung garis
      if (pts.length >= 2) {
        final last = pts.last;
        final prev = pts[pts.length - 2];
        final dir = (last - prev);
        if (dir.distance > 0.01) {
          final normDir = dir / dir.distance;
          final perpDir = Offset(-normDir.dy, normDir.dx);
          final arrowHeadPath = Path();
          final tip = last;
          final leftWing = tip - (normDir * 8.0) + (perpDir * 4.5);
          final rightWing = tip - (normDir * 8.0) - (perpDir * 4.5);
          arrowHeadPath.moveTo(tip.dx, tip.dy);
          arrowHeadPath.lineTo(leftWing.dx, leftWing.dy);
          arrowHeadPath.lineTo(rightWing.dx, rightWing.dy);
          arrowHeadPath.close();

          final arrowPaint = Paint()
            ..color = AppColors.pureBlack.withOpacity(0.70)
            ..style = PaintingStyle.fill;
          canvas.drawPath(arrowHeadPath, arrowPaint);
        }
      }

      // Nomor urutan bulat di awal goresan utama
      final start = pts.first;
      final badgeNumber = (badgeCounter++).toString();

      final badgeBgPaint = Paint()..color = AppColors.surfacePillDark;
      canvas.drawCircle(start, 9.5, badgeBgPaint);

      final badgeBorderPaint = Paint()
        ..color = AppColors.accentLemon
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(start, 9.5, badgeBorderPaint);

      final badgeTextPainter = TextPainter(
        text: TextSpan(
          text: badgeNumber,
          style: const TextStyle(
            color: AppColors.pureWhite,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      badgeTextPainter.paint(
        canvas,
        Offset(start.dx - badgeTextPainter.width / 2, start.dy - badgeTextPainter.height / 2),
      );
    }
  }

  /// Helper untuk menggambar path putus-putus halus tanpa ketergantungan library luar
  void _drawDashedPath({
    required Canvas canvas,
    required Path path,
    required Paint paint,
    required double dashLength,
    required double dashGap,
  }) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + dashLength < metric.length) ? dashLength : (metric.length - distance);
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedGuidePainter oldDelegate) =>
      oldDelegate.charLabel != charLabel;
}

/// Child Freeform Canvas (Ultra Fast, Zero Lag, Repaint-Isolated)
class _WritingCanvasPainter extends CustomPainter {
  final List<DrawingStroke> completedStrokes;
  final Map<int, DrawingStroke> activeStrokesMap;

  _WritingCanvasPainter({
    required Listenable repaint,
    required this.completedStrokes,
    required this.activeStrokesMap,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw cached completed strokes (Ultra Fast: 0 bezier calculations!)
    for (final stroke in completedStrokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.strokeWidth
        ..style = PaintingStyle.stroke;

      if (stroke.cachedPath != null) {
        canvas.drawPath(stroke.cachedPath!, paint);
      } else if (stroke.points.isNotEmpty) {
        if (stroke.points.length == 1) {
          canvas.drawCircle(
            stroke.points.first.offset,
            stroke.strokeWidth / 2,
            paint..style = PaintingStyle.fill,
          );
        } else {
          final path = Path();
          path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);
          for (int i = 1; i < stroke.points.length; i++) {
            final p0 = stroke.points[i - 1].offset;
            final p1 = stroke.points[i].offset;
            path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          }
          canvas.drawPath(path, paint);
        }
      }
    }

    // 2. Draw currently active strokes
    for (final stroke in activeStrokesMap.values) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.strokeWidth
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first.offset,
          stroke.strokeWidth / 2,
          paint..style = PaintingStyle.fill,
        );
        continue;
      }

      final path = Path();
      path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        final p0 = stroke.points[i - 1].offset;
        final p1 = stroke.points[i].offset;
        path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WritingCanvasPainter oldDelegate) => true;
}

/// Ali's Animated Echo Painter (Ali Menuliskan Kembali)
class _AliEchoPainter extends CustomPainter {
  final List<NormalizedStroke> refStrokes;
  final String charLabel;
  final Animation<double> animation;

  _AliEchoPainter({
    required this.refStrokes,
    required this.charLabel,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    if (refStrokes.isEmpty || progress <= 0 || size.width <= 0 || size.height <= 0) return;

    final fittedRect = WritingPathData.getFittedRect(
      canvasSize: size,
      charCount: charLabel.length,
      charLabel: charLabel,
    );

    final aliPaint = Paint()
      ..color = AppColors.accentLemon
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = AppColors.accentLemon.withValues(alpha: 0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final totalStrokes = refStrokes.length;
    final strokeFraction = 1.0 / totalStrokes;

    for (int sIdx = 0; sIdx < totalStrokes; sIdx++) {
      final strokeStartProgress = sIdx * strokeFraction;
      if (progress < strokeStartProgress) break;

      final strokeProgress = ((progress - strokeStartProgress) / strokeFraction).clamp(0.0, 1.0);
      final stroke = refStrokes[sIdx];
      if (stroke.points.isEmpty) continue;

      final pts = stroke.points.map((p) => WritingPathData.mapPointToCanvas(p, fittedRect)).toList();
      double totalDist = 0.0;
      for (int k = 0; k < pts.length - 1; k++) {
        totalDist += (pts[k + 1] - pts[k]).distance;
      }
      final isDot = totalDist < 20.0;

      if (isDot) {
        if (strokeProgress > 0.1) {
          final center = pts.first;
          final dotFill = Paint()
            ..color = AppColors.accentLemon
            ..style = PaintingStyle.fill;
          final dotGlow = Paint()
            ..color = AppColors.accentLemon.withValues(alpha: 0.6)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
          canvas.drawCircle(center, 7.0, dotGlow);
          canvas.drawCircle(center, 5.0, dotFill);
        }
        continue;
      }

      final fullSmooth = WritingPathData.buildSmoothPath(pts);

      if (strokeProgress >= 1.0) {
        canvas.drawPath(fullSmooth, glowPaint);
        canvas.drawPath(fullSmooth, aliPaint);
      } else {
        for (final metric in fullSmooth.computeMetrics()) {
          final targetLen = metric.length * strokeProgress;
          final partialPath = metric.extractPath(0.0, targetLen);
          canvas.drawPath(partialPath, glowPaint);
          canvas.drawPath(partialPath, aliPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AliEchoPainter oldDelegate) => true;
}
