import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/components/ali_paywall_dialog.dart';
import '../../domain/models/feeding_models.dart';
import '../widgets/animated_animal_view.dart';

class FeedingGameScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const FeedingGameScreen({
    super.key,
    this.onBack,
  });

  @override
  State<FeedingGameScreen> createState() => _FeedingGameScreenState();
}

class _FeedingGameScreenState extends State<FeedingGameScreen>
    with SingleTickerProviderStateMixin {
  int _currentAnimalIndex = 0;
  int _hungerCurrent = 0;
  static const int _hungerMax = 3;

  AnimalAnimationState _animState = AnimalAnimationState.idle;
  Offset? _dragPosition;
  String _speechBubbleText = '';
  Timer? _bubbleTimer;

  late AnimationController _celebrationController;
  late Animation<double> _popAnim;
  bool _isFinishedLevel = false;

  AnimalProfile get _currentAnimal =>
      FeedingGameRepository.animals[_currentAnimalIndex];

  // List of foods for current round (mix of favorites + funny wrong choices)
  late List<FoodItem> _roundFoods;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _popAnim = CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    );

    _setupAnimalRound();
  }

  @override
  void dispose() {
    _bubbleTimer?.cancel();
    _celebrationController.dispose();
    super.dispose();
  }

  void _setupAnimalRound() {
    _hungerCurrent = 0;
    _isFinishedLevel = false;
    _animState = AnimalAnimationState.idle;
    _dragPosition = null;

    final animal = _currentAnimal;

    // Pick 2 favorite foods + 2-3 wrong foods
    final favs = animal.favoriteFoodIds
        .map((id) => FeedingGameRepository.getFoodById(id))
        .toList();

    final wrong = FeedingGameRepository.allFoods
        .where((f) => !animal.favoriteFoodIds.contains(f.id))
        .toList()
      ..shuffle();

    _roundFoods = [...favs, ...wrong.take(3)]..shuffle();

    // Quest Suara & Kosa Kata: Hewan meminta makanan favorit secara eksplisit
    final targetFood = favs.isNotEmpty ? favs.first : null;
    final questText = targetFood != null
        ? '${animal.soundCall} Halo Ali, ${animal.name} lapar! Mau makan ${targetFood.name}!'
        : animal.soundCall;

    _showBubble(questText, durationSeconds: 4);
    _speakText(questText);
  }

  void _showBubble(String text, {int durationSeconds = 3}) {
    _bubbleTimer?.cancel();
    setState(() {
      _speechBubbleText = text;
    });
    _bubbleTimer = Timer(Duration(seconds: durationSeconds), () {
      if (mounted) {
        setState(() {
          _speechBubbleText = '';
        });
      }
    });
  }

  void _speakText(String text) {
    try {
      AudioEngineService.speakText(text);
    } catch (_) {}
  }

  void _onFoodDropped(FoodItem food) {
    HapticFeedback.mediumImpact();
    final animal = _currentAnimal;

    if (animal.isFavorite(food.id)) {
      // SUCCESS: Right Food!
      setState(() {
        _animState = AnimalAnimationState.chewing;
        _hungerCurrent = math.min(_hungerMax, _hungerCurrent + 1);
      });

      final successPhrases = [
        'Nyam nyam nyam! Enak sekali!',
        'Wah lezat! ${animal.name} suka banget!',
        'Kriuk-kriuk nyam! Terima kasih Ali!',
      ];
      final praise = successPhrases[math.Random().nextInt(successPhrases.length)];
      _showBubble(praise, durationSeconds: 2);
      _speakText(praise);

      // Check if full
      if (_hungerCurrent >= _hungerMax) {
        Timer(const Duration(milliseconds: 1200), () {
          if (mounted) {
            setState(() {
              _isFinishedLevel = true;
            });
            _celebrationController.forward(from: 0.0);
            HapticFeedback.heavyImpact();
            final winText = 'Horeee! ${_currentAnimal.name} sudah kenyang dan senang!';
            _showBubble(winText, durationSeconds: 4);
            _speakText(winText);
          }
        });
      } else {
        Timer(const Duration(milliseconds: 1800), () {
          if (mounted && !_isFinishedLevel) {
            setState(() {
              _animState = AnimalAnimationState.idle;
            });
          }
        });
      }
    } else {
      // CHALLENGE: Wrong Food! Funny Reaction!
      final isChili = food.id == 'chili';

      setState(() {
        _animState = isChili ? AnimalAnimationState.spicy : AnimalAnimationState.rejected;
      });

      if (isChili) {
        HapticFeedback.heavyImpact();
      }

      String reaction = animal.specialReactions[food.id] ??
          'Hee? ${animal.name} tidak makan ${food.name}! Cari yang lain ya!';

      final reactionDuration = isChili ? 4 : 3;
      _showBubble(reaction, durationSeconds: reactionDuration);
      _speakText(reaction);

      Timer(Duration(milliseconds: isChili ? 3600 : 2000), () {
        if (mounted && !_isFinishedLevel) {
          setState(() {
            _animState = AnimalAnimationState.idle;
          });
        }
      });
    }
  }

  void _nextAnimal() {
    setState(() {
      _currentAnimalIndex =
          (_currentAnimalIndex + 1) % FeedingGameRepository.animals.length;
    });
    _setupAnimalRound();
  }

  @override
  Widget build(BuildContext context) {
    final animal = _currentAnimal;

    return Scaffold(
      backgroundColor: animal.lightBgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Base Game Screen Column
            Column(
              children: [
                // 1. Top Bar: Navigation & Animal Selector
                _buildTopBar(context),

                // 2. Animal Tabs / Selector Pills
                _buildAnimalSelectorPills(),

                const SizedBox(height: 8),

                // 3. Hunger Meter (Bintang / Hati)
                _buildHungerMeter(),

                const Spacer(),

                // 4. Main Arena: Speech Bubble & Interactive Animated Animal
                _buildAnimalArena(animal),

                const Spacer(),

                // 5. Food Tray (Draggable Items)
                _buildFoodTray(),

                const SizedBox(height: 14),
              ],
            ),

            // Full-screen Victory Dialog Overlay
            if (_isFinishedLevel)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ScaleTransition(
                    scale: _popAnim,
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 560),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 34),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.r32),
                        border: Border.all(color: const Color(0xFFF59E0B), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 36,
                            offset: const Offset(0, 16),
                          ),
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                            blurRadius: 40,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Trophy Badge with Glow
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              border: Border.all(color: const Color(0xFFFCD34D), width: 1.5),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('⭐', style: TextStyle(fontSize: 20)),
                                SizedBox(width: 8),
                                Text(
                                  'MISI MAKAN SELESAI!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFB45309),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('⭐', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('🎉 🏆 🌟', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            '${animal.name} Sudah Kenyang!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Hebat sekali! Ali berhasil memilih makanan favorit dan memberi makan ${animal.name} sampai kenyang!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: AliButton(
                                  label: 'Beri Makan Lagi 🔄',
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      _isFinishedLevel = false;
                                      _hungerCurrent = 0;
                                      _animState = AnimalAnimationState.idle;
                                    });
                                    _setupAnimalRound();
                                  },
                                  variant: AliButtonVariant.outline,
                                  size: AliButtonSize.large,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 2,
                                child: AliButton(
                                  label: 'Sahabat Selanjutnya ➜',
                                  onPressed: _nextAnimal,
                                  variant: AliButtonVariant.primaryHighContrast,
                                  size: AliButtonSize.large,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    side: const BorderSide(color: AppColors.borderCard, width: 1.5),
                  ),
                ),
                icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sahabat Ali',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Jam Makan 3D',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _currentAnimal.avatarEmoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Audio Re-play button
          IconButton(
            onPressed: () {
              final text = _speechBubbleText.isNotEmpty
                  ? _speechBubbleText
                  : _currentAnimal.soundCall;
              _speakText(text);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r16),
                side: const BorderSide(color: AppColors.borderCard, width: 1.5),
              ),
            ),
            icon: const Icon(Iconsax.volume_high, color: AppColors.textPrimary, size: 20),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ANIMAL SELECTOR PILLS
  // ===========================================================================
  Widget _buildAnimalSelectorPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(FeedingGameRepository.animals.length, (idx) {
          final item = FeedingGameRepository.animals[idx];
          final isSelected = idx == _currentAnimalIndex;
          final isLocked = idx > 0 && !SubscriptionService.isPro;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              onTap: () {
                if (isLocked) {
                  HapticFeedback.heavyImpact();
                  AliPaywallDialog.show(
                    context,
                    featureName: 'Beri Makan ${item.name} (${item.title})',
                    featureDescription:
                        'Buka semua koleksi hewan 3D interaktif: Si Jago Ayam, Si Gembul Panda, Si Fluffy Kelinci, dan Si Mas Koki!',
                  );
                  return;
                }

                if (idx != _currentAnimalIndex) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _currentAnimalIndex = idx;
                  });
                  _setupAnimalRound();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? item.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isSelected ? item.primaryColor : AppColors.borderCard,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: item.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.avatarEmoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    if (isLocked) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.lock_rounded, size: 13, color: Color(0xFF94A3B8)),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================================
  // HUNGER METER
  // ===========================================================================
  Widget _buildHungerMeter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.borderCard, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Perut Kenyang:',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: List.generate(_hungerMax, (index) {
              final isEaten = index < _hungerCurrent;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedScale(
                  scale: isEaten ? 1.2 : 0.9,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isEaten ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 26,
                    color: isEaten ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MAIN ANIMAL ARENA (DROP TARGET & SPEECH BUBBLE)
  // ===========================================================================
  Widget _buildAnimalArena(AnimalProfile animal) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Speech Bubble
        if (_speechBubbleText.isNotEmpty)
          Positioned(
            top: -45,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _speechBubbleText.isNotEmpty ? 1.0 : 0.0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 290),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                  border: Border.all(color: animal.primaryColor.withValues(alpha: 0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  _speechBubbleText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),

        // Drop Target Area
        DragTarget<FoodItem>(
          onWillAcceptWithDetails: (details) {
            setState(() {
              _animState = AnimalAnimationState.anticipating;
            });
            return true;
          },
          onLeave: (data) {
            if (_animState == AnimalAnimationState.anticipating) {
              setState(() {
                _animState = AnimalAnimationState.idle;
              });
            }
          },
          onAcceptWithDetails: (details) {
            _onFoodDropped(details.data);
          },
          builder: (context, candidateData, rejectedData) {
            return AnimatedAnimalView(
              animal: animal,
              state: _animState,
              dragPosition: _dragPosition,
              hungerProgress: _hungerCurrent / _hungerMax,
            );
          },
        ),

      ],
    );
  }

  // ===========================================================================
  // FOOD TRAY (DRAGGABLE ITEMS)
  // ===========================================================================
  Widget _buildFoodTray() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r28),
        border: Border.all(color: AppColors.borderCard, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Piring Makanan (Tarik ke mulut hewan):',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentLemon,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Text(
                  '👆 GESER',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pureBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _roundFoods.map((food) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildDraggableFoodItem(food),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableFoodItem(FoodItem food) {
    final foodCard = Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: food.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.borderCard, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(food.emoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(height: 4),
          Text(
            food.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );

    return Draggable<FoodItem>(
      data: food,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.25,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(food.emoji, style: const TextStyle(fontSize: 44)),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: foodCard,
      ),
      onDragStarted: () {
        HapticFeedback.selectionClick();
        setState(() {
          _animState = AnimalAnimationState.anticipating;
        });
      },
      onDragUpdate: (details) {
        // Calculate relative offset for eye and head tracking
        final screenSize = MediaQuery.of(context).size;
        final animalCenter = Offset(screenSize.width / 2, screenSize.height * 0.45);
        final relOffset = details.globalPosition - animalCenter;
        setState(() {
          _dragPosition = relOffset;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _dragPosition = null;
          if (_animState == AnimalAnimationState.anticipating) {
            _animState = AnimalAnimationState.idle;
          }
        });
      },
      child: foodCard,
    );
  }
}
