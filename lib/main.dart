import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'core/theme/app_theme_tokens.dart';
import 'core/components/ali_icon.dart';
import 'core/components/ali_header_section.dart';
import 'core/components/ali_list_card_section.dart';
import 'core/components/ali_grid_card_section.dart';
import 'core/components/ali_network_image.dart';
import 'core/components/ali_sentence_deck_card.dart';
import 'core/components/ali_bottom_tabs_dock.dart';
import 'core/components/sentence_builder_bar.dart';
import 'core/components/ali_modal.dart';
import 'core/components/ali_button.dart';
import 'core/components/ali_smart_input.dart';
import 'core/components/ali_form_card.dart';
import 'core/components/ali_smart_image_search_modal.dart';
import 'features/aac_board/domain/models/vocab_card_model.dart';
import 'features/dual_canvas/presentation/screens/dual_canvas_screen.dart';
import 'features/parent_mode/presentation/screens/parent_dashboard_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/writing_practice/presentation/screens/writing_practice_screen.dart';
import 'features/catalog/presentation/screens/catalog_screen.dart';
import 'features/catalog/presentation/screens/guess_image_game_screen.dart';
import 'features/catalog/domain/models/catalog_category_model.dart';
import 'features/visual_schedule/presentation/screens/visual_schedule_screen.dart';
import 'features/choice_board/presentation/screens/choice_board_screen.dart';
import 'core/services/supabase_service.dart';
import 'core/services/audio_engine_service.dart';
import 'core/services/audio_recorder_service.dart';
import 'core/services/local_cache_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'core/components/ali_camera_helper.dart';
import 'features/home_hub/presentation/screens/ali_home_hub_screen.dart';
import 'features/iqro/presentation/screens/iqro_hub_screen.dart';
import 'features/feeding_game/presentation/screens/feeding_game_screen.dart';
import 'features/tree_garden/presentation/screens/tree_garden_screen.dart';
import 'features/reading/presentation/screens/reading_practice_screen.dart';
import 'features/quran/presentation/screens/quran_hub_screen.dart';

import 'core/services/r2_storage_service.dart';

import 'core/services/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/presentation/screens/onboarding_flow_screen.dart';

import 'core/services/subscription_service.dart';
import 'core/components/ali_paywall_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('Supabase initialize error: $e');
  }
  try {
    await AudioEngineService.initialize();
  } catch (e) {
    debugPrint('AudioEngine initialize error: $e');
  }
  try {
    await LocalCacheService.initialize();
  } catch (e) {
    debugPrint('LocalCache initialize error: $e');
  }
  
  // Asynchronous user profile & subscription loading
  UserProfileService.initialize().catchError((e) {
    debugPrint('UserProfileService initialize error: $e');
  });
  SubscriptionService.init().catchError((e) {
    debugPrint('SubscriptionService init error: $e');
  });

  runApp(const AliApp());
}

class AliApp extends StatefulWidget {
  const AliApp({super.key});

  @override
  State<AliApp> createState() => _AliAppState();
}

class _AliAppState extends State<AliApp> {
  bool _isLoadingGate = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkGateState();
  }

  Future<void> _checkGateState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localDone = prefs.getBool('has_completed_onboarding') ?? false;
      final user = SupabaseService.currentUser;

      bool profileDone = false;
      if (user != null) {
        // Cek flag eksplisit onboarding dari user metadata
        final metaDone = user.userMetadata?['has_completed_onboarding'] == true;
        if (metaDone) {
          profileDone = true;
          await prefs.setBool('has_completed_onboarding', true);
        }
      }

      if (mounted) {
        setState(() {
          // Lewati onboarding HANYA jika onboarding sudah diselesaikan (lokal atau user metadata)
          _hasCompletedOnboarding = localDone || profileDone;
          _isLoadingGate = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingGate = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ali - Belajar, Bermain dan Tumbuh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: AppTypography.fontFamily,
        scaffoldBackgroundColor: AppColors.bgCanvas,
      ),
      home: _isLoadingGate
          ? const Scaffold(
              backgroundColor: AppColors.bgCanvas,
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.pureBlack,
                ),
              ),
            )
          : (_hasCompletedOnboarding
              ? const MainNavigationShell()
              : OnboardingFlowScreen(
                  onCompleted: () {
                    setState(() => _hasCompletedOnboarding = true);
                  },
                )),
    );
  }
}

String _categoryIdToName(String categoryId) {
  const uuidToName = {
    'a0000001-0000-0000-0000-000000000001': 'Keluarga',
    'a0000001-0000-0000-0000-000000000002': 'Aktivitas',
    'a0000001-0000-0000-0000-000000000003': 'Hewan',
    'a0000001-0000-0000-0000-000000000004': 'Ekspresi',
  };
  return uuidToName[categoryId] ?? categoryId;
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  int _activeHeaderTab = 0; // 0: Grid Mode, 1: List Deck Mode (Directory style from image copy.png)
  String _selectedCategory = 'Semua';
  final List<SentenceItem> _sentenceTokens = [];
  bool _isPlayingSentence = false;

  final List<String> _categories = ['Semua', 'Keluarga', 'Aktivitas', 'Hewan', 'Ekspresi'];
  final Map<String, String> _categoryNameToId = {
    'Keluarga': 'a0000001-0000-0000-0000-000000000001',
    'Aktivitas': 'a0000001-0000-0000-0000-000000000002',
    'Hewan': 'a0000001-0000-0000-0000-000000000003',
    'Ekspresi': 'a0000001-0000-0000-0000-000000000004',
  };

  List<VocabCardModel> _vocabList = [];
  bool _isLoadingVocab = true;

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
  }

  void _syncCategories(List<VocabCardModel> cards) {
    for (final card in cards) {
      final name = _categoryIdToName(card.categoryId);
      if (name.isNotEmpty && !_categories.contains(name) && name != 'Semua') {
        _categories.add(name);
      }
    }
  }

  Future<String?> _showCreateCategoryDialog(BuildContext context) async {
    final catCtrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r24)),
        title: const Text(
          'Buat Kategori Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan nama kategori untuk mengelompokkan kartu kosa kata:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: catCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Misal: Mainan, Sekolah, Makanan',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceInput,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  borderSide: const BorderSide(color: AppColors.borderCard),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  borderSide: const BorderSide(color: AppColors.borderCard),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pureBlack,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
            ),
            onPressed: () {
              final text = catCtrl.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(dlgCtx, text);
              }
            },
            child: const Text('Buat Kategori', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPersistedData() async {
    // 0. Fetch existing categories from Supabase
    try {
      final cloudCats = await SupabaseService.getCategories();
      if (mounted && cloudCats.isNotEmpty) {
        setState(() {
          for (final c in cloudCats) {
            _categoryNameToId[c.name] = c.id;
            if (!_categories.contains(c.name)) {
              _categories.add(c.name);
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Supabase categories fetch note: $e');
    }

    // 1. Load from SQLite local storage immediately (on mobile)
    final localCards = await LocalCacheService.getCachedVocabCards();
    if (mounted && localCards.isNotEmpty) {
      setState(() {
        _vocabList = localCards;
        _isLoadingVocab = false;
        _syncCategories(localCards);
      });
    }

    // 2. Fetch directly from Supabase REST API (crucial for Web & cold start)
    try {
      final initialCards = await SupabaseService.getVocabCards();
      if (mounted) {
        setState(() {
          if (initialCards.isNotEmpty) {
            _vocabList = initialCards;
            _syncCategories(initialCards);
          }
          _isLoadingVocab = false;
        });
        if (initialCards.isNotEmpty) {
          LocalCacheService.cacheVocabCards(initialCards);
        }
      }
    } catch (e) {
      debugPrint('Supabase initial fetch note: $e');
      if (mounted) {
        setState(() => _isLoadingVocab = false);
      }
    }

    // 3. Listen to Supabase Realtime Stream for live updates
    SupabaseService.streamVocabCards().listen((cloudCards) {
      if (mounted && cloudCards.isNotEmpty) {
        setState(() {
          _vocabList = cloudCards;
          _syncCategories(cloudCards);
        });
        LocalCacheService.cacheVocabCards(cloudCards);
      }
    }, onError: (e) {
      debugPrint('Supabase stream note: $e');
    });

    SupabaseService.streamCategories().listen((cloudCats) {
      if (mounted && cloudCats.isNotEmpty) {
        setState(() {
          for (final c in cloudCats) {
            _categoryNameToId[c.name] = c.id;
            if (!_categories.contains(c.name)) {
              _categories.add(c.name);
            }
          }
        });
      }
    }, onError: (e) {
      debugPrint('Supabase categories stream note: $e');
    });
  }

  void _addCardToSentence(VocabCardModel card) {
    setState(() {
      _sentenceTokens.add(
        SentenceItem(
          id: UniqueKey().toString(),
          label: card.label,
          audioUrl: card.audioUrl,
          audioAbiUrl: card.audioAbiUrl,
          audioUmmaUrl: card.audioUmmaUrl,
        ),
      );
    });
    AudioEngineService.speakWord(
      text: card.label,
      audioAbiUrl: card.audioAbiUrl,
      audioUmmaUrl: card.audioUmmaUrl,
      audioUrl: card.audioUrl,
    );
  }

  void _playSentenceAudio() {
    setState(() => _isPlayingSentence = true);
    AudioEngineService.playSentenceSequence(
      items: _sentenceTokens,
      onComplete: () {
        if (mounted) {
          setState(() => _isPlayingSentence = false);
        }
      },
    );
  }

  ActiveVoiceSource _currentVoice = ActiveVoiceSource.abi;

  void _openEditCardModal(VocabCardModel card) {
    final nameCtrl = TextEditingController(text: card.label);
    String selectedCat = _categoryIdToName(card.categoryId);
    Uint8List? selectedImageBytes;
    bool isProcessingImage = false;
    Uint8List? recordedAbiAudioBytes;
    Uint8List? recordedUmmaAudioBytes;
    bool isRecordingAbi = false;
    bool isRecordingUmma = false;

    String? customImageUrl;

    AliModal.showDeckModal(
      context: context,
      isFullHeight: true,
      title: 'Ubah Foto & Kosa Kata',
      subtitle: 'Ganti dengan foto asli keluarga atau benda nyata',
      body: StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. Photo Picker (Kotak 1:1 Aspect Ratio)
                Center(
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCardSubtle,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      child: selectedImageBytes != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(selectedImageBytes!, fit: BoxFit.cover),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() => selectedImageBytes = null);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.65),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (customImageUrl != null && customImageUrl!.isNotEmpty
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    AliNetworkImage(imageUrl: customImageUrl!, fit: BoxFit.cover),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() => customImageUrl = null);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.65),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : (isProcessingImage
                                  ? const Center(child: CircularProgressIndicator(color: AppColors.textPrimary))
                                  : AliNetworkImage(imageUrl: card.imageUrl, fit: BoxFit.cover))),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final bytes = await AliCameraHelper.capturePhoto(context);
                          if (bytes != null) {
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customImageUrl = null;
                              isProcessingImage = false;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCardSubtle,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            border: Border.all(color: AppColors.borderCard, width: 1.2),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AliIcon(Iconsax.camera, size: 18, color: AppColors.accentLemon),
                              SizedBox(width: 6),
                              Text('Kamera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (picked != null) {
                            setModalState(() => isProcessingImage = true);
                            final bytes = await picked.readAsBytes();
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customImageUrl = null;
                              isProcessingImage = false;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCardSubtle,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            border: Border.all(color: AppColors.borderCard, width: 1.2),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AliIcon(Iconsax.gallery, size: 18, color: AppColors.accentSky),
                              SizedBox(width: 6),
                              Text('Galeri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          AliSmartImageSearchModal.show(
                            context: context,
                            initialQuery: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : card.label,
                            onImageSelected: (url) {
                              setModalState(() {
                                customImageUrl = url;
                                selectedImageBytes = null;
                              });
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.accentLemon,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentLemon.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🔍', style: TextStyle(fontSize: 14)),
                              SizedBox(width: 6),
                              Text('Cari Web', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: AppColors.pureBlack)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),

                // 2. Category Selection & Creation Section
                AliFormCard(
                  title: 'Kategori Kartu',
                  subtitle: 'Pilih kategori atau buat kategori baru',
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._categories.where((c) => c != 'Semua').map((cat) {
                          final isSelected = selectedCat.toLowerCase() == cat.toLowerCase();
                          return ChoiceChip(
                            label: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.pureBlack,
                            backgroundColor: AppColors.surfacePill,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              side: BorderSide(
                                color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
                                width: 1.0,
                              ),
                            ),
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() => selectedCat = cat);
                              }
                            },
                          );
                        }),
                        ActionChip(
                          avatar: const Icon(Icons.add_rounded, size: 16, color: AppColors.pureBlack),
                          label: const Text(
                            'Kategori Baru',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.pureBlack),
                          ),
                          backgroundColor: AppColors.accentLemon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: const BorderSide(color: Color(0xFFD4E63C), width: 1.0),
                          ),
                          onPressed: () async {
                            final newCatName = await _showCreateCategoryDialog(context);
                            if (newCatName != null && newCatName.isNotEmpty) {
                              final newId = await SupabaseService.insertCategory(newCatName);
                              if (newId != null) {
                                _categoryNameToId[newCatName] = newId;
                              }
                              setState(() {
                                if (!_categories.contains(newCatName)) {
                                  _categories.add(newCatName);
                                }
                              });
                              setModalState(() {
                                selectedCat = newCatName;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),

                // 3. Vocab Label Input
                AliFormCard(
                  title: 'Nama Kosa Kata',
                  children: [
                    AliSmartInput(
                      controller: nameCtrl,
                      hintText: 'Nama Kosa Kata',
                      prefixIcon: Iconsax.edit_2,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),
                AliFormCard(
                  title: 'Sumber Suara Asli (${UserProfileService.fatherCall} & ${UserProfileService.motherCall})',
                  children: [
                    // Suara Ayah/Abi Row (Record + Immediate Preview)
                    Row(
                      children: [
                        Expanded(
                          child: AliButton(
                            label: isRecordingAbi
                                ? 'Sedang Merekam... (Ketuk Selesai)'
                                : (recordedAbiAudioBytes != null
                                    ? 'Suara ${UserProfileService.fatherCall} Baru ✓'
                                    : (card.audioAbiUrl != null ? 'Ganti Suara ${UserProfileService.fatherCall}' : 'Rekam Suara ${UserProfileService.fatherCall}')),
                            variant: isRecordingAbi
                                ? AliButtonVariant.danger
                                : (recordedAbiAudioBytes != null ? AliButtonVariant.primaryHighContrast : AliButtonVariant.frostedGlass),
                            prefixIcon: AliIcon(
                              isRecordingAbi ? Iconsax.record : Iconsax.microphone_2,
                              color: isRecordingAbi || recordedAbiAudioBytes != null ? AppColors.pureWhite : AppColors.textPrimary,
                            ),
                            onPressed: () async {
                              if (isRecordingAbi) {
                                final bytes = await AudioRecorderService.stopRecording();
                                setModalState(() {
                                  isRecordingAbi = false;
                                  if (bytes != null && bytes.isNotEmpty) {
                                    recordedAbiAudioBytes = bytes;
                                  }
                                });
                              } else {
                                final started = await AudioRecorderService.startRecording();
                                if (started) {
                                  setModalState(() => isRecordingAbi = true);
                                  Future.delayed(const Duration(seconds: 4), () async {
                                    if (isRecordingAbi) {
                                      final bytes = await AudioRecorderService.stopRecording();
                                      setModalState(() {
                                        isRecordingAbi = false;
                                        if (bytes != null && bytes.isNotEmpty) {
                                          recordedAbiAudioBytes = bytes;
                                        }
                                      });
                                    }
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        if (recordedAbiAudioBytes != null || card.audioAbiUrl != null) ...[
                          const SizedBox(width: AppSpacing.s8),
                          GestureDetector(
                            onTap: () {
                              if (recordedAbiAudioBytes != null) {
                                final b64 = base64Encode(recordedAbiAudioBytes!);
                                AudioEngineService.speakWord(
                                  text: card.label,
                                  audioAbiUrl: 'data:audio/mp4;base64,$b64',
                                );
                              } else if (card.audioAbiUrl != null) {
                                AudioEngineService.speakWord(
                                  text: card.label,
                                  audioAbiUrl: card.audioAbiUrl,
                                );
                              }
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfacePillDark,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: const Center(
                                child: AliIcon(Iconsax.play, size: 18, color: AppColors.accentLemon),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s10),
                    // Suara Ibu/Umma Row (Record + Immediate Preview)
                    Row(
                      children: [
                        Expanded(
                          child: AliButton(
                            label: isRecordingUmma
                                ? 'Sedang Merekam... (Ketuk Selesai)'
                                : (recordedUmmaAudioBytes != null
                                    ? 'Suara ${UserProfileService.motherCall} Baru ✓'
                                    : (card.audioUmmaUrl != null ? 'Ganti Suara ${UserProfileService.motherCall}' : 'Rekam Suara ${UserProfileService.motherCall}')),
                            variant: isRecordingUmma
                                ? AliButtonVariant.danger
                                : (recordedUmmaAudioBytes != null ? AliButtonVariant.primaryHighContrast : AliButtonVariant.frostedGlass),
                            prefixIcon: AliIcon(
                              isRecordingUmma ? Iconsax.record : Iconsax.microphone_2,
                              color: isRecordingUmma || recordedUmmaAudioBytes != null ? AppColors.pureWhite : AppColors.textPrimary,
                            ),
                            onPressed: () async {
                              if (isRecordingUmma) {
                                final bytes = await AudioRecorderService.stopRecording();
                                setModalState(() {
                                  isRecordingUmma = false;
                                  if (bytes != null && bytes.isNotEmpty) {
                                    recordedUmmaAudioBytes = bytes;
                                  }
                                });
                              } else {
                                final started = await AudioRecorderService.startRecording();
                                if (started) {
                                  setModalState(() => isRecordingUmma = true);
                                  Future.delayed(const Duration(seconds: 4), () async {
                                    if (isRecordingUmma) {
                                      final bytes = await AudioRecorderService.stopRecording();
                                      setModalState(() {
                                        isRecordingUmma = false;
                                        if (bytes != null && bytes.isNotEmpty) {
                                          recordedUmmaAudioBytes = bytes;
                                        }
                                      });
                                    }
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        if (recordedUmmaAudioBytes != null || card.audioUmmaUrl != null) ...[
                          const SizedBox(width: AppSpacing.s8),
                          GestureDetector(
                            onTap: () {
                              if (recordedUmmaAudioBytes != null) {
                                final b64 = base64Encode(recordedUmmaAudioBytes!);
                                AudioEngineService.speakWord(
                                  text: card.label,
                                  audioUmmaUrl: 'data:audio/mp4;base64,$b64',
                                );
                              } else if (card.audioUmmaUrl != null) {
                                AudioEngineService.speakWord(
                                  text: card.label,
                                  audioUmmaUrl: card.audioUmmaUrl,
                                );
                              }
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfacePillDark,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: const Center(
                                child: AliIcon(Iconsax.play, size: 18, color: AppColors.accentCoral),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        if (card.originalCardId != null && card.originalCardId!.isNotEmpty) ...[
          AliButton(
            label: 'Kembalikan ke Default',
            variant: AliButtonVariant.danger,
            onPressed: () async {
              Navigator.pop(context);
              final overrideId = card.id;
              await SupabaseService.resetCardToDefault(overrideId);
              final refreshed = await SupabaseService.getVocabCards();
              if (mounted) {
                setState(() {
                  _vocabList = refreshed;
                  _syncCategories(refreshed);
                });
                LocalCacheService.cacheVocabCards(refreshed);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kartu "${card.label}" dikembalikan ke versi bawaan'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ] else if (!card.isSystem && (card.originalCardId == null || card.originalCardId!.isEmpty)) ...[
          AliButton(
            label: 'Hapus Kartu',
            variant: AliButtonVariant.danger,
            onPressed: () async {
              Navigator.pop(context);
              await SupabaseService.deleteVocabCard(card.id);
              if (mounted) {
                setState(() {
                  _vocabList.removeWhere((c) => c.id == card.id);
                });
                LocalCacheService.cacheVocabCards(_vocabList);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kartu "${card.label}" berhasil dihapus'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
        AliButton(
          label: 'Batal',
          variant: AliButtonVariant.outline,
          onPressed: () => Navigator.pop(context),
        ),
        AliButton(
          label: 'Simpan Perubahan',
          variant: AliButtonVariant.primaryHighContrast,
          onPressed: () async {
            final newLabel = nameCtrl.text.trim();
            Navigator.pop(context);

            final cardId = card.id;

            String finalImageUrl = card.imageUrl;
            if (selectedImageBytes != null) {
              final base64Image = base64Encode(selectedImageBytes!);
              finalImageUrl = 'data:image/jpeg;base64,$base64Image';

              final uploadedUrl = await SupabaseService.uploadImage(
                bytes: selectedImageBytes!,
                fileName: 'custom_${DateTime.now().millisecondsSinceEpoch}.jpg',
              );
              if (uploadedUrl != null) {
                finalImageUrl = uploadedUrl;
              }
            } else if (customImageUrl != null && customImageUrl!.isNotEmpty) {
              finalImageUrl = customImageUrl!;
              final r2Url = await R2StorageService.uploadFileFromRemoteUrl(
                remoteUrl: customImageUrl!,
                path: 'photos/card_${cardId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
              );
              if (r2Url != null) {
                finalImageUrl = r2Url;
              }
            }

            String? audioAbiUrl = card.audioAbiUrl;
            if (recordedAbiAudioBytes != null) {
              final uploadedAbi = await SupabaseService.uploadAudio(
                bytes: recordedAbiAudioBytes!,
                fileName: 'abi_say_${cardId}_${DateTime.now().millisecondsSinceEpoch}.m4a',
              );
              audioAbiUrl = uploadedAbi ?? 'data:audio/mp4;base64,${base64Encode(recordedAbiAudioBytes!)}';
            }

            String? audioUmmaUrl = card.audioUmmaUrl;
            if (recordedUmmaAudioBytes != null) {
              final uploadedUmma = await SupabaseService.uploadAudio(
                bytes: recordedUmmaAudioBytes!,
                fileName: 'umma_say_${cardId}_${DateTime.now().millisecondsSinceEpoch}.m4a',
              );
              audioUmmaUrl = uploadedUmma ?? 'data:audio/mp4;base64,${base64Encode(recordedUmmaAudioBytes!)}';
            }

            final categoryUuid = _categoryNameToId[selectedCat] ?? selectedCat;

            // Simpan perubahan dengan pola Copy-on-Write (khusus akun ini)
            final updatedCard = await SupabaseService.saveCardModification(
              card: card,
              label: newLabel.isNotEmpty ? newLabel : card.label,
              imageUrl: finalImageUrl,
              categoryId: categoryUuid,
              audioAbiUrl: audioAbiUrl,
              audioUmmaUrl: audioUmmaUrl,
            );

            if (mounted && updatedCard != null) {
              setState(() {
                final idx = _vocabList.indexWhere((c) => c.id == card.id);
                if (idx != -1) {
                  _vocabList[idx] = updatedCard;
                } else {
                  _vocabList.add(updatedCard);
                }
                LocalCacheService.cacheVocabCards(_vocabList);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Perubahan kartu "${updatedCard.label}" tersimpan untuk akun Anda'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _openAddCardModal() async {
    // Cek kuota Free Tier (Maksimal 10 Kartu jika belum berlangganan Ali Pro)
    final isPro = SubscriptionService.isPro;
    if (!isPro && _vocabList.length >= 10) {
      if (!mounted) return;
      AliPaywallDialog.show(
        context,
        featureName: 'Kartu Bicara AAC Tanpa Batas',
        featureDescription: 'Akun gratis dapat membuat hingga 10 kartu kosa kata AAC. Buka Ali Pro untuk menambah ratusan kartu foto nyata & rekaman suara keluarga tanpa batas!',
      );
      return;
    }

    final nameCtrl = TextEditingController();
    String selectedCat = _selectedCategory != 'Semua' ? _selectedCategory : 'Aktivitas';
    Uint8List? selectedImageBytes;
    bool isProcessingImage = false;
    bool isRecordingAbi = false;
    bool isRecordingUmma = false;
    Uint8List? recordedAbiAudioBytes;
    Uint8List? recordedUmmaAudioBytes;

    String? customImageUrl;

    AliModal.showDeckModal(
      context: context,
      isFullHeight: true,
      title: 'Tambah Kosakata Baru',
      subtitle: 'Ambil foto asli & rekam suara ${UserProfileService.fatherCall} & ${UserProfileService.motherCall}',
      body: StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. Photo Picker (Kotak 1:1 Aspect Ratio)
                Center(
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCardSubtle,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      child: selectedImageBytes != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(selectedImageBytes!, fit: BoxFit.cover),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() => selectedImageBytes = null);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.65),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (customImageUrl != null && customImageUrl!.isNotEmpty
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    AliNetworkImage(imageUrl: customImageUrl!, fit: BoxFit.cover),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() => customImageUrl = null);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.65),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : (isProcessingImage
                                  ? const Center(child: CircularProgressIndicator(color: AppColors.textPrimary))
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AliIcon(Iconsax.image, size: 40, color: AppColors.textMuted),
                                          SizedBox(height: 8),
                                          Text(
                                            'Belum ada foto',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                    ))),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Tombol 1: Kamera Langsung
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final bytes = await AliCameraHelper.capturePhoto(context);
                          if (bytes != null) {
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customImageUrl = null;
                              isProcessingImage = false;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCardSubtle,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            border: Border.all(color: AppColors.borderCard, width: 1.2),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AliIcon(Iconsax.camera, size: 18, color: AppColors.accentLemon),
                              SizedBox(width: 6),
                              Text('Kamera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Tombol 2: Pilih dari Galeri HP
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (picked != null) {
                            setModalState(() => isProcessingImage = true);
                            final bytes = await picked.readAsBytes();
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customImageUrl = null;
                              isProcessingImage = false;
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCardSubtle,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            border: Border.all(color: AppColors.borderCard, width: 1.2),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AliIcon(Iconsax.gallery, size: 18, color: AppColors.accentSky),
                              SizedBox(width: 6),
                              Text('Galeri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Tombol 3: Cari Web Pintar
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          AliSmartImageSearchModal.show(
                            context: context,
                            initialQuery: nameCtrl.text.trim(),
                            onImageSelected: (url) {
                              setModalState(() {
                                customImageUrl = url;
                                selectedImageBytes = null;
                              });
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.accentLemon,
                            borderRadius: BorderRadius.circular(AppRadius.r16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentLemon.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🔍', style: TextStyle(fontSize: 14)),
                              SizedBox(width: 6),
                              Text('Cari Web', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: AppColors.pureBlack)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),

                // 2. Category Selection & Creation Section
                AliFormCard(
                  title: 'Kategori Kartu',
                  subtitle: 'Pilih kategori atau buat kategori baru',
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._categories.where((c) => c != 'Semua').map((cat) {
                          final isSelected = selectedCat.toLowerCase() == cat.toLowerCase();
                          return ChoiceChip(
                            label: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.pureBlack,
                            backgroundColor: AppColors.surfacePill,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              side: BorderSide(
                                color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
                                width: 1.0,
                              ),
                            ),
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() => selectedCat = cat);
                              }
                            },
                          );
                        }),
                        ActionChip(
                          avatar: const Icon(Icons.add_rounded, size: 16, color: AppColors.pureBlack),
                          label: const Text(
                            'Kategori Baru',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.pureBlack),
                          ),
                          backgroundColor: AppColors.accentLemon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            side: const BorderSide(color: Color(0xFFD4E63C), width: 1.0),
                          ),
                          onPressed: () async {
                            final newCatName = await _showCreateCategoryDialog(context);
                            if (newCatName != null && newCatName.isNotEmpty) {
                              final newId = await SupabaseService.insertCategory(newCatName);
                              if (newId != null) {
                                _categoryNameToId[newCatName] = newId;
                              }
                              setState(() {
                                if (!_categories.contains(newCatName)) {
                                  _categories.add(newCatName);
                                }
                              });
                              setModalState(() {
                                selectedCat = newCatName;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),

                // 3. Information Card (Name input)
                AliFormCard(
                  title: 'Informasi Kartu',
                  subtitle: 'Kata yang mudah dipahami Ali',
                  children: [
                    AliSmartInput(
                      controller: nameCtrl,
                      hintText: 'Misal: Makan Roti',
                      prefixIcon: Iconsax.edit_2,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),
                AliFormCard(
                  title: 'Sumber Suara Asli (${UserProfileService.fatherCall} & ${UserProfileService.motherCall})',
                  subtitle: 'Rekam pengucapan kata untuk ${UserProfileService.childName}',
                  children: [
                    // Suara Ayah/Abi Row
                    Row(
                      children: [
                        Expanded(
                          child: AliButton(
                            label: isRecordingAbi
                                ? 'Sedang Merekam... (Ketuk Selesai)'
                                : (recordedAbiAudioBytes != null ? 'Suara ${UserProfileService.fatherCall} Tersimpan ✓' : 'Rekam Suara ${UserProfileService.fatherCall}'),
                            variant: isRecordingAbi
                                ? AliButtonVariant.danger
                                : (recordedAbiAudioBytes != null ? AliButtonVariant.primaryHighContrast : AliButtonVariant.frostedGlass),
                            prefixIcon: AliIcon(
                              isRecordingAbi ? Iconsax.record : Iconsax.microphone_2,
                              color: isRecordingAbi || recordedAbiAudioBytes != null ? AppColors.pureWhite : AppColors.textPrimary,
                            ),
                            isFullWidth: true,
                            onPressed: () async {
                              if (isRecordingAbi) {
                                final bytes = await AudioRecorderService.stopRecording();
                                setModalState(() {
                                  isRecordingAbi = false;
                                  if (bytes != null && bytes.isNotEmpty) {
                                    recordedAbiAudioBytes = bytes;
                                  }
                                });
                              } else {
                                final started = await AudioRecorderService.startRecording();
                                if (started) {
                                  setModalState(() => isRecordingAbi = true);
                                  Future.delayed(const Duration(seconds: 4), () async {
                                    if (isRecordingAbi) {
                                      final bytes = await AudioRecorderService.stopRecording();
                                      setModalState(() {
                                        isRecordingAbi = false;
                                        if (bytes != null && bytes.isNotEmpty) {
                                          recordedAbiAudioBytes = bytes;
                                        }
                                      });
                                    }
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        if (recordedAbiAudioBytes != null) ...[
                          const SizedBox(width: AppSpacing.s8),
                          GestureDetector(
                            onTap: () {
                              final b64 = base64Encode(recordedAbiAudioBytes!);
                              AudioEngineService.speakWord(
                                text: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : 'Suara ${UserProfileService.fatherCall}',
                                audioAbiUrl: 'data:audio/mp4;base64,$b64',
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfacePillDark,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: const Center(
                                child: AliIcon(Iconsax.play, size: 18, color: AppColors.accentLemon),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    // Suara Ibu/Umma Row
                    Row(
                      children: [
                        Expanded(
                          child: AliButton(
                            label: isRecordingUmma
                                ? 'Sedang Merekam... (Ketuk Selesai)'
                                : (recordedUmmaAudioBytes != null ? 'Suara ${UserProfileService.motherCall} Tersimpan ✓' : 'Rekam Suara ${UserProfileService.motherCall}'),
                            variant: isRecordingUmma
                                ? AliButtonVariant.danger
                                : (recordedUmmaAudioBytes != null ? AliButtonVariant.primaryHighContrast : AliButtonVariant.frostedGlass),
                            prefixIcon: AliIcon(
                              isRecordingUmma ? Iconsax.record : Iconsax.microphone_2,
                              color: isRecordingUmma || recordedUmmaAudioBytes != null ? AppColors.pureWhite : AppColors.textPrimary,
                            ),
                            isFullWidth: true,
                            onPressed: () async {
                              if (isRecordingUmma) {
                                final bytes = await AudioRecorderService.stopRecording();
                                setModalState(() {
                                  isRecordingUmma = false;
                                  if (bytes != null && bytes.isNotEmpty) {
                                    recordedUmmaAudioBytes = bytes;
                                  }
                                });
                              } else {
                                final started = await AudioRecorderService.startRecording();
                                if (started) {
                                  setModalState(() => isRecordingUmma = true);
                                  Future.delayed(const Duration(seconds: 4), () async {
                                    if (isRecordingUmma) {
                                      final bytes = await AudioRecorderService.stopRecording();
                                      setModalState(() {
                                        isRecordingUmma = false;
                                        if (bytes != null && bytes.isNotEmpty) {
                                          recordedUmmaAudioBytes = bytes;
                                        }
                                      });
                                    }
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        if (recordedUmmaAudioBytes != null) ...[
                          const SizedBox(width: AppSpacing.s8),
                          GestureDetector(
                            onTap: () {
                              final b64 = base64Encode(recordedUmmaAudioBytes!);
                              AudioEngineService.speakWord(
                                text: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : 'Suara ${UserProfileService.motherCall}',
                                audioUmmaUrl: 'data:audio/mp4;base64,$b64',
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfacePillDark,
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: const Center(
                                child: AliIcon(Iconsax.play, size: 18, color: AppColors.accentLemon),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        AliButton(
          label: 'Batal',
          variant: AliButtonVariant.outline,
          onPressed: () => Navigator.pop(context),
        ),
        AliButton(
          label: 'Simpan Kartu',
          variant: AliButtonVariant.primaryHighContrast,
          onPressed: () async {
            final label = nameCtrl.text.trim();
            if (label.isNotEmpty) {
              Navigator.pop(context);

              String finalImageUrl = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&auto=format&fit=crop&q=80';
              if (selectedImageBytes != null) {
                final base64Image = base64Encode(selectedImageBytes!);
                finalImageUrl = 'data:image/jpeg;base64,$base64Image';
              } else if (customImageUrl != null && customImageUrl!.isNotEmpty) {
                finalImageUrl = customImageUrl!;
              }

              String? audioAbiPreview;
              if (recordedAbiAudioBytes != null) {
                final base64Audio = base64Encode(recordedAbiAudioBytes!);
                audioAbiPreview = 'data:audio/mp4;base64,$base64Audio';
              }

              String? audioUmmaPreview;
              if (recordedUmmaAudioBytes != null) {
                final base64Audio = base64Encode(recordedUmmaAudioBytes!);
                audioUmmaPreview = 'data:audio/mp4;base64,$base64Audio';
              }

              // In-memory immediate preview data
              final newCardId = 'custom_${DateTime.now().millisecondsSinceEpoch}';

              setState(() {
                _vocabList.insert(
                  0,
                  VocabCardModel(
                    id: newCardId,
                    label: label,
                    imageUrl: finalImageUrl,
                    audioAbiUrl: audioAbiPreview,
                    audioUmmaUrl: audioUmmaPreview,
                    categoryId: selectedCat,
                    createdAt: DateTime.now(),
                    userId: SupabaseService.currentUser?.id,
                    isSystem: false,
                  ),
                );
                LocalCacheService.cacheVocabCards(_vocabList);
              });

              // Asynchronously upload to Supabase Storage / R2 and insert into Supabase
              () async {
                String remoteImageUrl = finalImageUrl;
                if (selectedImageBytes != null) {
                  final imgUrl = await SupabaseService.uploadImage(
                    bytes: selectedImageBytes!,
                    fileName: 'card_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  );
                  if (imgUrl != null) remoteImageUrl = imgUrl;
                } else if (customImageUrl != null && customImageUrl!.isNotEmpty) {
                  final imgUrl = await R2StorageService.uploadFileFromRemoteUrl(
                    remoteUrl: customImageUrl!,
                    path: 'photos/card_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  );
                  if (imgUrl != null) remoteImageUrl = imgUrl;
                }

                String? remoteAbiAudio = audioAbiPreview;
                if (recordedAbiAudioBytes != null) {
                  final aUrl = await SupabaseService.uploadAudio(
                    bytes: recordedAbiAudioBytes!,
                    fileName: 'abi_say_${DateTime.now().millisecondsSinceEpoch}.m4a',
                  );
                  if (aUrl != null) remoteAbiAudio = aUrl;
                }

                String? remoteUmmaAudio = audioUmmaPreview;
                if (recordedUmmaAudioBytes != null) {
                  final uUrl = await SupabaseService.uploadAudio(
                    bytes: recordedUmmaAudioBytes!,
                    fileName: 'umma_say_${DateTime.now().millisecondsSinceEpoch}.m4a',
                  );
                  if (uUrl != null) remoteUmmaAudio = uUrl;
                }

                final categoryUuid = _categoryNameToId[selectedCat] ?? selectedCat;

                await SupabaseService.insertVocabCard(
                  categoryId: categoryUuid,
                  label: label,
                  imageUrl: remoteImageUrl,
                  audioAbiUrl: remoteAbiAudio,
                  audioUmmaUrl: remoteUmmaAudio,
                  createdBy: 'abi',
                );

                final refreshed = await SupabaseService.getVocabCards();
                if (mounted && refreshed.isNotEmpty) {
                  setState(() {
                    _vocabList = refreshed;
                    _syncCategories(refreshed);
                  });
                  LocalCacheService.cacheVocabCards(refreshed);
                }
              }();
            }
          },
        ),
      ],
    );
  }

  void _openGuessGameCategoryPicker() async {
    // Show quick sheet to pick category before launching game
    final categories = await SupabaseService.getCatalogCategories();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                    child: const Text('🎤', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Kategori Tebak Gambar',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pilih materi yang ingin ditebak anak',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Option: Semua Kategori
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GuessImageGameScreen(initialCategoryId: 'all'),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.r20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(AppRadius.r20),
                    border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Text('🌟', style: TextStyle(fontSize: 22)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Semua Kosa Kata',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Campur semua kategori hewan, buah, benda, dll',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFD97706)),
                    ],
                  ),
                ),
              ),

              // List of Specific Categories
              ...categories.map((cat) {
                String emoji = '📦';
                if (cat.id == 'hewan') emoji = '🐱';
                if (cat.id == 'buah_makanan') emoji = '🍎';
                if (cat.id == 'benda') emoji = '🪑';
                if (cat.id == 'aksi_aac') emoji = '🗣️';
                if (cat.id == 'kendaraan') emoji = '🚗';
                if (cat.id == 'tubuh') emoji = '👁️';
                if (cat.id == 'alam') emoji = '☀️';

                return InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GuessImageGameScreen(initialCategoryId: cat.id),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    child: Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            cat.nameId,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Index 0: Home Hub (Ruang Belajar Utama Ali)
          AliHomeHubScreen(
            onOpenAac: () => setState(() => _currentIndex = 1),
            onOpenWriting: () => setState(() => _currentIndex = 2),
            onOpenCanvas: () => setState(() => _currentIndex = 3),
            onOpenSettings: () => setState(() => _currentIndex = 4),
            onAddQuickVocab: _openAddCardModal,
            onOpenCatalog: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CatalogScreen(
                    onPracticeWriting: (word) {
                      setState(() => _currentIndex = 2);
                    },
                  ),
                ),
              );
            },
            onOpenGuessGame: _openGuessGameCategoryPicker,
            onOpenVisualSchedule: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VisualScheduleScreen(
                    availableCards: _vocabList,
                  ),
                ),
              );
            },
            onOpenChoiceBoard: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChoiceBoardScreen(
                    availableCards: _vocabList,
                  ),
                ),
              );
            },
            onOpenIqro: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const IqroHubScreen(),
                ),
              );
            },
            onOpenQuran: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const QuranHubScreen(),
                ),
              );
            },
            onOpenFeedingGame: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FeedingGameScreen(),
                ),
              );
            },
            onOpenTreeGarden: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TreeGardenScreen(),
                ),
              );
            },
            onOpenReading: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReadingPracticeScreen(),
                ),
              );
            },
          ),

          // Index 1: Papan Bicara AAC (Full-screen Clean Mode)
          _AacHomeScreen(
            vocabList: _vocabList,
            isLoadingVocab: _isLoadingVocab,
            categories: _categories,
            selectedCategory: _selectedCategory,
            sentenceTokens: _sentenceTokens,
            isPlayingSentence: _isPlayingSentence,
            activeHeaderTab: _activeHeaderTab,
            currentVoice: _currentVoice,
            onVoiceChanged: (v) {
              setState(() => _currentVoice = v);
              AudioEngineService.setVoiceSource(v);
            },
            onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            onHeaderTabChanged: (tabIdx) => setState(() => _activeHeaderTab = tabIdx),
            onCardTap: _addCardToSentence,
            onEditCard: _openEditCardModal,
            onPlaySentence: _playSentenceAudio,
            onClearAll: () => setState(() => _sentenceTokens.clear()),
            onRemoveSentenceItem: (index) => setState(() => _sentenceTokens.removeAt(index)),
            onAddNewCard: _openAddCardModal,
            onBack: () => setState(() => _currentIndex = 0),
          ),

          // Index 2: Belajar Menulis (Full-screen Canvas Bebas Distraksi)
          WritingPracticeScreen(
            onBack: () => setState(() => _currentIndex = 0),
          ),

          // Index 3: Dual-Canvas (Full-screen Menggambar)
          DualCanvasScreen(
            onBack: () => setState(() => _currentIndex = 0),
            onSaveAsCard: (label, imageUrl) {
              setState(() {
                _vocabList.insert(
                  0,
                  VocabCardModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    label: label,
                    imageUrl: imageUrl,
                    categoryId: 'Ekspresi',
                    createdAt: DateTime.now(),
                  ),
                );
                _currentIndex = 1;
              });
            },
          ),

          // Index 4: Pengaturan & Portal Abi Umma
          SettingsScreen(
            onAddNewVocab: _openAddCardModal,
            onBack: () => setState(() => _currentIndex = 0),
          ),
        ],
      ),
      bottomNavigationBar: null, // Bebas Nav Bar! Layar 100% clean dan ramah anak.
    );
  }
}

class _AacHomeScreen extends StatelessWidget {
  final List<VocabCardModel> vocabList;
  final bool isLoadingVocab;
  final List<String> categories;
  final String selectedCategory;
  final List<SentenceItem> sentenceTokens;
  final bool isPlayingSentence;
  final int activeHeaderTab;
  final ActiveVoiceSource currentVoice;
  final ValueChanged<ActiveVoiceSource> onVoiceChanged;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<int> onHeaderTabChanged;
  final ValueChanged<VocabCardModel> onCardTap;
  final ValueChanged<VocabCardModel> onEditCard;
  final VoidCallback onPlaySentence;
  final VoidCallback onClearAll;
  final ValueChanged<int> onRemoveSentenceItem;
  final VoidCallback onAddNewCard;
  final VoidCallback? onBack;

  const _AacHomeScreen({
    required this.vocabList,
    required this.isLoadingVocab,
    required this.categories,
    required this.selectedCategory,
    required this.sentenceTokens,
    required this.isPlayingSentence,
    required this.activeHeaderTab,
    required this.currentVoice,
    required this.onVoiceChanged,
    required this.onCategorySelected,
    required this.onHeaderTabChanged,
    required this.onCardTap,
    required this.onEditCard,
    required this.onPlaySentence,
    required this.onClearAll,
    required this.onRemoveSentenceItem,
    required this.onAddNewCard,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final filteredCards = selectedCategory == 'Semua'
        ? vocabList
        : vocabList.where((c) {
            return c.categoryId == selectedCategory ||
                _categoryIdToName(c.categoryId).toLowerCase() == selectedCategory.toLowerCase();
          }).toList();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = isTablet ? 4 : 2;
    final aspectRatio = isTablet ? 0.95 : 0.82;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // 1. Sticky Compact Navbar Header
          SliverPersistentHeader(
            pinned: true,
            delegate: AliStickyHeaderDelegate(
              height: 68.0,
              child: ValueListenableBuilder<String>(
                valueListenable: UserProfileService.childNameNotifier,
                builder: (context, currentChildName, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: UserProfileService.fatherCallNotifier,
                    builder: (context, fatherName, _) {
                      return ValueListenableBuilder<String>(
                        valueListenable: UserProfileService.motherCallNotifier,
                        builder: (context, motherName, _) {
                          return AliHeaderSection(
                            title: 'Papan Bicara $currentChildName',
                            subtitle: 'Suara $fatherName & $motherName',
                            onBackTap: onBack,
                            onAddTap: onAddNewCard,
                            tabs: const ['Papan Kotak', 'Daftar Kosa Kata'],
                            activeTabIndex: activeHeaderTab,
                            onTabChanged: onHeaderTabChanged,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // 2. Sticky Category Filter Pills Row
          SliverPersistentHeader(
            pinned: true,
            delegate: AliStickyHeaderDelegate(
              height: 44.0,
              child: Container(
                color: AppColors.bgCanvas,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => onCategorySelected(cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.surfacePillDark : AppColors.surfacePill,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(
                              color: isSelected ? AppColors.surfacePillDark : AppColors.borderCard,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: AppTypography.pill(
                              color: isSelected ? AppColors.textOnDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          // 3. Quick Needs Bar (Kebutuhan Cepat & Darurat Anak)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('⚡', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Text(
                        'KEBUTUHAN CEPAT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB45309),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildQuickNeedChip(
                          emoji: '🚽',
                          label: 'Mau Toilet',
                          speakText: 'Ali mau ke toilet sekarang',
                          bgColor: const Color(0xFFE0F2FE),
                          borderColor: const Color(0xFFBAE6FD),
                          textColor: const Color(0xFF0369A1),
                        ),
                        _buildQuickNeedChip(
                          emoji: '🥛',
                          label: 'Mau Minum',
                          speakText: 'Ali haus, mau minum air',
                          bgColor: const Color(0xFFF0FDF4),
                          borderColor: const Color(0xFFBBF7D0),
                          textColor: const Color(0xFF15803D),
                        ),
                        _buildQuickNeedChip(
                          emoji: '🥪',
                          label: 'Mau Makan',
                          speakText: 'Ali lapar, mau makan',
                          bgColor: const Color(0xFFFEF3C7),
                          borderColor: const Color(0xFFFDE68A),
                          textColor: const Color(0xFFB45309),
                        ),
                        _buildQuickNeedChip(
                          emoji: '🩹',
                          label: 'Sakit',
                          speakText: 'Aduh sakit, tolong bantu Ali',
                          bgColor: const Color(0xFFFEE2E2),
                          borderColor: const Color(0xFFFECACA),
                          textColor: const Color(0xFFB91C1C),
                        ),
                        _buildQuickNeedChip(
                          emoji: '🤗',
                          label: 'Mau Peluk',
                          speakText: 'Ali mau peluk',
                          bgColor: const Color(0xFFFDF4FF),
                          borderColor: const Color(0xFFF5D0FE),
                          textColor: const Color(0xFF86198F),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 4)),
          if (isLoadingVocab) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentLemon,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
          ] else if (filteredCards.isEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 32),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePill,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: const AliIcon(Iconsax.card, size: 36, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Text(
                        'Belum Ada Kosa Kata',
                        style: AppTypography.titleMedium(),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        selectedCategory == 'Semua'
                            ? 'Tekan tombol di bawah untuk menambah kartu kosa kata pertama Ali'
                            : 'Belum ada kartu di kategori "$selectedCategory"',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall(),
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      AliButton(
                        label: 'Tambah Kosakata',
                        prefixIcon: const AliIcon(Iconsax.add, size: 18),
                        variant: AliButtonVariant.primaryHighContrast,
                        onPressed: onAddNewCard,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else if (activeHeaderTab == 0) ...[
            // View Mode 0: High-Precision Grid Deck
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenMargin,  // Exactly 4.0
                right: AppSpacing.screenMargin, // Exactly 4.0
                bottom: 20,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: AppSpacing.cardGap, // Exactly 4.0
                  mainAxisSpacing: AppSpacing.cardGap,  // Exactly 4.0
                  childAspectRatio: aspectRatio,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final card = filteredCards[index];
                    final masterIndex = vocabList.indexOf(card);
                    final isCardLocked = !SubscriptionService.isPro && (masterIndex >= 10 || (masterIndex == -1 && index >= 10));

                    return ValueListenableBuilder<String>(
                      valueListenable: UserProfileService.fatherCallNotifier,
                      builder: (context, fatherName, _) {
                        return ValueListenableBuilder<String>(
                          valueListenable: UserProfileService.motherCallNotifier,
                          builder: (context, motherName, _) {
                            final voiceLabel = card.getVoiceLabel(fatherCall: fatherName, motherCall: motherName);

                            return GestureDetector(
                              key: ValueKey('grid_${card.id}_${card.imageUrl.hashCode}'),
                              onLongPress: isCardLocked ? null : () => onEditCard(card),
                              child: AliGridCardSection(
                                key: ValueKey('card_${card.id}_${card.imageUrl.hashCode}'),
                                title: card.label,
                                subtitle: voiceLabel,
                                categoryTag: _categoryIdToName(card.categoryId),
                                imageUrl: card.imageUrl,
                                isLocked: isCardLocked,
                                onTap: () {
                                  if (isCardLocked) {
                                    AliPaywallDialog.show(
                                      context,
                                      featureName: 'Kartu AAC ${card.label}',
                                      featureDescription: 'Buka akses ke seluruh kartu AAC kustomisasi dan rekaman suara keluarga tanpa batas bersama Ali Pro.',
                                    );
                                    return;
                                  }
                                  onCardTap(card);
                                },
                                onPlaySound: () {
                                  if (isCardLocked) {
                                    AliPaywallDialog.show(
                                      context,
                                      featureName: 'Audio AAC ${card.label}',
                                      featureDescription: 'Buka audio pelafalan kartu ini bersama Ali Pro.',
                                    );
                                    return;
                                  }
                                  AudioEngineService.speakWord(
                                    text: card.label,
                                    audioAbiUrl: card.audioAbiUrl,
                                    audioUmmaUrl: card.audioUmmaUrl,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  childCount: filteredCards.length,
                ),
              ),
            ),
          ] else ...[
            // View Mode 1: Detailed List Card Decks (Exact layout from image copy.png)
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenMargin,  // Exactly 4.0
                right: AppSpacing.screenMargin, // Exactly 4.0
                bottom: 20,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final card = filteredCards[index];
                    final masterIndex = vocabList.indexOf(card);
                    final isCardLocked = !SubscriptionService.isPro && (masterIndex >= 10 || (masterIndex == -1 && index >= 10));

                    return ValueListenableBuilder<String>(
                      valueListenable: UserProfileService.fatherCallNotifier,
                      builder: (context, fatherName, _) {
                        return ValueListenableBuilder<String>(
                          valueListenable: UserProfileService.motherCallNotifier,
                          builder: (context, motherName, _) {
                            final voiceLabel = card.getVoiceLabel(fatherCall: fatherName, motherCall: motherName);

                            return GestureDetector(
                              key: ValueKey('list_${card.id}_${card.imageUrl.hashCode}'),
                              onLongPress: isCardLocked ? null : () => onEditCard(card),
                              child: AliListCardSection(
                                title: card.label,
                                roleSubtitle: 'Pengucapan dipandu $voiceLabel',
                                audioVoiceTag: voiceLabel,
                                imageUrl: card.imageUrl,
                                categoryTag: _categoryIdToName(card.categoryId),
                                dateText: 'Hari ini',
                                isLocked: isCardLocked,
                                onTap: () {
                                  if (isCardLocked) {
                                    AliPaywallDialog.show(
                                      context,
                                      featureName: 'Kartu AAC ${card.label}',
                                      featureDescription: 'Buka akses ke seluruh kartu AAC kustomisasi dan rekaman suara keluarga tanpa batas bersama Ali Pro.',
                                    );
                                    return;
                                  }
                                  onCardTap(card);
                                },
                                onPlayAudio: () {
                                  if (isCardLocked) {
                                    AliPaywallDialog.show(
                                      context,
                                      featureName: 'Audio AAC ${card.label}',
                                      featureDescription: 'Buka audio pelafalan kartu ini bersama Ali Pro.',
                                    );
                                    return;
                                  }
                                  AudioEngineService.speakWord(
                                    text: card.label,
                                    audioAbiUrl: card.audioAbiUrl,
                                    audioUmmaUrl: card.audioUmmaUrl,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  childCount: filteredCards.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickExpressChip({
    required String emoji,
    required String label,
    required String speechText,
    required Color bgColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        AudioEngineService.speakWord(text: speechText);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: textColor.withValues(alpha: 0.25), width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickNeedChip({
    required String emoji,
    required String label,
    required String speakText,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        AudioEngineService.speakWord(text: speakText);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickySentenceDeckDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickySentenceDeckDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickySentenceDeckDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
