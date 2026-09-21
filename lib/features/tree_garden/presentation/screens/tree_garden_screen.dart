import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import 'package:khalif_ali/core/components/ali_button.dart';
import 'package:khalif_ali/core/services/audio_engine_service.dart';
import 'package:khalif_ali/core/services/subscription_service.dart';
import 'package:khalif_ali/core/services/user_profile_service.dart';
import 'package:khalif_ali/core/components/ali_paywall_dialog.dart';
import '../../domain/models/tree_garden_models.dart';
import '../widgets/magical_tree_3d_view.dart';
import '../widgets/watering_can_3d_vector.dart';

class TreeGardenScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const TreeGardenScreen({super.key, this.onBack});

  @override
  State<TreeGardenScreen> createState() => _TreeGardenScreenState();
}

class _TreeGardenScreenState extends State<TreeGardenScreen>
    with TickerProviderStateMixin {
  int _currentTreeIndex = 0;
  TreeGrowthStage _stage = TreeGrowthStage.seed;
  double _wateringProgress = 0.0;
  double _growthProgress = 0.0;
  final Set<int> _harvestedFruits = {};
  int _totalHarvestCount = 0;
  String _guideText = '';
  bool _isFinishedRound = false;
  bool _isWateringActive = false;

  late AnimationController _popAnimController;
  late Animation<double> _popAnim;
  late AnimationController _wateringCanAnimController;

  TreeProfile get _currentTree => TreeGardenRepository.trees[_currentTreeIndex];

  @override
  void initState() {
    super.initState();
    _popAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _popAnim = CurvedAnimation(
      parent: _popAnimController,
      curve: Curves.elasticOut,
    );

    _wateringCanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _wateringCanAnimController.addListener(() {
      if (mounted) {
        setState(() {
          _wateringProgress = _wateringCanAnimController.value;
        });
      }
    });

    _wateringCanAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onWateringCompleted();
      }
    });

    _setupTreeRound();
  }

  @override
  void dispose() {
    _wateringCanAnimController.dispose();
    _popAnimController.dispose();
    super.dispose();
  }

  void _speakText(String text) {
    try {
      AudioEngineService.speakText(text);
    } catch (_) {}
  }

  void _setupTreeRound() {
    _wateringCanAnimController.reset();
    _wateringProgress = 0.0;
    _growthProgress = 0.0;
    _isWateringActive = false;
    _harvestedFruits.clear();
    _isFinishedRound = false;
    _stage = TreeGrowthStage.seed;

    final cue = _currentTree.growthCues[0];
    _guideText = cue;
    _speakText(cue);
  }

  void _onSeedPlanted() {
    HapticFeedback.mediumImpact();
    setState(() {
      _stage = TreeGrowthStage.watering;
      _guideText = _currentTree.growthCues[1];
    });
    _speakText(_guideText);
  }

  void _startWatering() {
    if (_isWateringActive) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _isWateringActive = true;
      _guideText = 'Segarnya! Kucuran air menyuburkan tanah...';
    });
    _speakText('Segarnya!');
    _wateringCanAnimController.forward(from: 0.0);
  }

  void _onWateringCompleted() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isWateringActive = false;
      _stage = TreeGrowthStage.sunlight;
      _guideText = _currentTree.growthCues[2];
    });
    _speakText(_guideText);
  }

  void _onSunlightGiven() {
    HapticFeedback.mediumImpact();
    // Animate Tree Growth to blooming and harvest
    AnimationController growthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    growthController.addListener(() {
      setState(() {
        _growthProgress = growthController.value;
      });
    });
    growthController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _stage = TreeGrowthStage.harvest;
          _guideText = _currentTree.growthCues[3];
        });
        HapticFeedback.heavyImpact();
        _speakText(_guideText);
        growthController.dispose();
      }
    });

    setState(() {
      _stage = TreeGrowthStage.blooming;
      _guideText = 'Pohon mulai tumbuh besar dan mekar!';
    });
    growthController.forward(from: 0.0);
  }

  void _onFruitHarvested(int index) {
    if (_harvestedFruits.contains(index)) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _harvestedFruits.add(index);
    });

    final count = _harvestedFruits.length;
    final harvestPhrases = [
      'Satu ${ _currentTree.fruitName}!',
      'Dua ${ _currentTree.fruitName}!',
      'Tiga ${ _currentTree.fruitName} segar!',
      'Empat ${ _currentTree.fruitName} manis!',
      'Lima ${ _currentTree.fruitName}! Keranjang penuh!',
    ];
    final praise = harvestPhrases[(count - 1).clamp(0, harvestPhrases.length - 1)];
    setState(() {
      _guideText = praise;
    });
    _speakText(praise);

    if (count >= _currentTree.fruitCount) {
      Timer(const Duration(milliseconds: 750), () {
        if (!mounted) return;
        HapticFeedback.heavyImpact();
        _popAnimController.forward(from: 0.0);

        final childName = UserProfileService.childName;
        final animalFriends = [
          {'name': 'Kupu-kupu Pelangi', 'emoji': '🦋', 'sound': 'Kupu-kupu cantik datang hinggap di pohon $childName!'},
          {'name': 'Burung Pipit', 'emoji': '🐦', 'sound': 'Burung pipit bernyanyi riang di ranting pohon $childName!'},
          {'name': 'Kelinci Putih', 'emoji': '🐰', 'sound': 'Kelinci putih melompat gembira melihat kebun $childName!'},
          {'name': 'Tupai Sahabat', 'emoji': '🐿️', 'sound': 'Tupai lucu datang bermain di pohon $childName!'},
          {'name': 'Kumbang Emas', 'emoji': '🐞', 'sound': 'Kumbang emas datang menjaga buah-buah $childName!'},
        ];
        final friend = animalFriends[math.Random().nextInt(animalFriends.length)];
        final winMsg = 'Luar biasa! ${friend['emoji']} ${friend['sound']}';

        setState(() {
          _totalHarvestCount += count;
          _stage = TreeGrowthStage.watering;
          _wateringProgress = 0.0;
          _wateringCanAnimController.reset();
          _harvestedFruits.clear();
          _guideText = winMsg;
        });
        _speakText(winMsg);
      });
    }
  }

  void _nextTree() {
    HapticFeedback.selectionClick();
    setState(() {
      _currentTreeIndex = (_currentTreeIndex + 1) % TreeGardenRepository.trees.length;
    });
    _setupTreeRound();
  }

  @override
  Widget build(BuildContext context) {
    final tree = _currentTree;

    return Scaffold(
      backgroundColor: tree.lightBgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Top Bar
                _buildTopBar(context),

                // 2. Tree Selector Pills
                _buildTreeSelectorPills(),

                const SizedBox(height: 8),

                // 3. Stage Progress Stepper
                _buildStageStepper(),

                const Spacer(),

                // 4. Speech Guide Bubble & 3D Magical Tree Canvas
                _buildTreeArena(tree),

                const Spacer(),

                // 5. Tool Action Tray
                _buildToolTray(),

                const SizedBox(height: 14),
              ],
            ),

            // Victory Dialog Overlay
            if (_isFinishedRound) _buildVictoryOverlay(tree),
          ],
        ),
      ),
    );
  }

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
                  Text(
                    'Kebun Ajaib ${UserProfileService.childName}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _currentTree.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(_currentTree.fruitEmoji, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              if (_totalHarvestCount > 0)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: _currentTree.primaryColor.withValues(alpha: 0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(_currentTree.fruitEmoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '$_totalHarvestCount',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: _currentTree.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              IconButton(
                onPressed: () => _speakText(_guideText),
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
        ],
      ),
    );
  }

  Widget _buildTreeSelectorPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(TreeGardenRepository.trees.length, (idx) {
          final item = TreeGardenRepository.trees[idx];
          final isSelected = idx == _currentTreeIndex;
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
                    featureName: 'Kebun ${item.name}',
                    featureDescription:
                        'Buka semua 22 varietas pohon ajaib: Apel, Jeruk, Pisang, Stroberi, Mangga, Semangka, Anggur, dan kebun buah lengkap lainnya!',
                  );
                  return;
                }

                if (idx != _currentTreeIndex) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _currentTreeIndex = idx;
                  });
                  _setupTreeRound();
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
                    Text(item.fruitEmoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      item.fruitName,
                      style: TextStyle(
                        fontSize: 13,
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

  Widget _buildStageStepper() {
    final stages = [
      {'label': '1. Tanam', 'icon': '🌰'},
      {'label': '2. Siram', 'icon': '🌧️'},
      {'label': '3. Matahari', 'icon': '☀️'},
      {'label': '4. Petik', 'icon': '🧺'},
    ];

    int currentStageIdx = 0;
    if (_stage == TreeGrowthStage.watering) currentStageIdx = 1;
    if (_stage == TreeGrowthStage.sunlight || _stage == TreeGrowthStage.blooming) currentStageIdx = 2;
    if (_stage == TreeGrowthStage.harvest || _stage == TreeGrowthStage.completed) currentStageIdx = 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.borderCard, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(stages.length, (idx) {
          final s = stages[idx];
          final isActive = idx == currentStageIdx;
          final isPast = idx < currentStageIdx;

          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isActive
                      ? _currentTree.primaryColor
                      : isPast
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  children: [
                    Text(s['icon']!, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      s['label']!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isActive
                            ? Colors.white
                            : isPast
                                ? const Color(0xFF15803D)
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (idx < stages.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTreeArena(TreeProfile tree) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Guide Bubble
        Positioned(
          top: -42,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: tree.primaryColor.withValues(alpha: 0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              _guideText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        // Drop Target for Seed & Watering Can
        DragTarget<String>(
          onWillAcceptWithDetails: (details) {
            if (_stage == TreeGrowthStage.seed && details.data == 'seed') return true;
            if (_stage == TreeGrowthStage.watering && details.data == 'watering_can') return true;
            return false;
          },
          onAcceptWithDetails: (details) {
            if (details.data == 'seed') {
              _onSeedPlanted();
            } else if (details.data == 'watering_can') {
              _startWatering();
            }
          },
          builder: (context, candidateData, rejectedData) {
            final isWateringCanHovered = candidateData.contains('watering_can');
            final isSeedHovered = candidateData.contains('seed');

            return Stack(
              alignment: Alignment.center,
              children: [
                if (isWateringCanHovered || isSeedHovered)
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isWateringCanHovered ? const Color(0xFF38BDF8) : AppColors.accentLemon,
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isWateringCanHovered ? const Color(0xFF0284C7) : AppColors.accentLemon)
                              .withValues(alpha: 0.28),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                MagicalTree3DView(
                  tree: tree,
                  stage: _stage,
                  wateringProgress: _wateringProgress,
                  growthProgress: _growthProgress,
                  harvestedFruits: _harvestedFruits,
                  onFruitTapped: (index) => _onFruitHarvested(index),
                ),

                // 3D Watering Can pouring right above the pot!
                if (_isWateringActive)
                  Positioned(
                    top: 40,
                    right: 28,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      builder: (context, val, child) {
                        return Transform.scale(
                          scale: val,
                          child: WateringCan3DVector(
                            size: 110,
                            tiltAngle: -0.42, // Realistic pouring tilt towards the soil
                            isPouring: true,
                            pourProgress: _wateringProgress,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildToolTray() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              Text(
                _getToolTrayTitle(),
                style: const TextStyle(
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
                child: Text(
                  _stage == TreeGrowthStage.seed
                      ? '👆 DRAG BIJI'
                      : (_stage == TreeGrowthStage.watering ? '👆 DRAG TEKO' : '👆 KETUK ALAT'),
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pureBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: _buildActiveTool(),
          ),
        ],
      ),
    );
  }

  String _getToolTrayTitle() {
    switch (_stage) {
      case TreeGrowthStage.seed:
        return 'Tarik Biji ke dalam Pot:';
      case TreeGrowthStage.watering:
        return 'Tarik Teko Air ke atas Pot:';
      case TreeGrowthStage.sunlight:
      case TreeGrowthStage.blooming:
        return 'Ketuk Matahari untuk Menghangatkan:';
      case TreeGrowthStage.harvest:
        return 'Petik buah di pohon! (${_harvestedFruits.length}/${_currentTree.fruitCount})';
      case TreeGrowthStage.completed:
        return 'Semua buah berhasil dipetik!';
    }
  }

  Widget _buildActiveTool() {
    if (_stage == TreeGrowthStage.seed) {
      // Draggable 3D Seed Item
      return Draggable<String>(
        data: 'seed',
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
                    color: const Color(0xFF713F12).withValues(alpha: 0.28),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _build3DSeedGraphic(size: 48),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: _toolCard(
            customWidget: _build3DSeedGraphic(size: 36),
            title: 'Biji ${_currentTree.fruitName}',
            subtitle: 'Tarik ke pot tanah',
            badgeText: 'TARIK',
          ),
        ),
        child: _toolCard(
          customWidget: _build3DSeedGraphic(size: 36),
          title: 'Biji ${_currentTree.fruitName}',
          subtitle: 'Tarik ke pot tanah',
          badgeText: 'TARIK',
        ),
      );
    }

    if (_stage == TreeGrowthStage.watering) {
      if (_isWateringActive) {
        // Active watering in progress
        return _toolCard(
          customWidget: const WateringCan3DVector(
            size: 38,
            tiltAngle: -0.32,
            isPouring: true,
            pourProgress: 0.8,
          ),
          title: 'Sedang Menyiram...',
          subtitle: 'Air mengucur menyuburkan tanah',
          badgeText: '${(_wateringProgress * 100).toInt()}%',
        );
      }

      // Draggable Watering Can (Tarik teko ke atas pohon!)
      return Draggable<String>(
        data: 'watering_can',
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
                    color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const WateringCan3DVector(
                size: 64,
                tiltAngle: -0.28,
                isPouring: false,
              ),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.35,
          child: _toolCard(
            customWidget: const WateringCan3DVector(
              size: 38,
              tiltAngle: 0.0,
            ),
            title: 'Teko Air Segar',
            subtitle: 'Sedang diarahkan ke pot...',
            badgeText: 'DRAG',
          ),
        ),
        child: _toolCard(
          customWidget: const WateringCan3DVector(
            size: 38,
            tiltAngle: 0.0,
          ),
          title: 'Teko Air Segar',
          subtitle: 'Tarik ke atas pot pohon!',
          badgeText: 'TARIK',
        ),
      );
    }

    if (_stage == TreeGrowthStage.sunlight || _stage == TreeGrowthStage.blooming) {
      // 3D Warm Glowing Sun
      return InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        onTap: _stage == TreeGrowthStage.sunlight ? _onSunlightGiven : null,
        child: _toolCard(
          customWidget: _build3DSunGraphic(size: 36),
          title: 'Sinar Matahari',
          subtitle: 'Hangatkan pohon agar mekar',
          badgeText: 'KETUK',
        ),
      );
    }

    // 3D Harvest Basket
    return _toolCard(
      customWidget: _build3DBasketGraphic(size: 36),
      title: 'Keranjang Buah',
      subtitle: '${_harvestedFruits.length} dari ${_currentTree.fruitCount} dipetik',
      badgeText: '${_harvestedFruits.length}/${_currentTree.fruitCount}',
    );
  }

  Widget _build3DSeedGraphic({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Seed3DPainter(),
      ),
    );
  }

  Widget _build3DSunGraphic({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Sun3DPainter(),
      ),
    );
  }

  Widget _build3DBasketGraphic({required double size}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Basket3DPainter(),
      ),
    );
  }

  Widget _toolCard({
    String? emoji,
    Widget? customWidget,
    required String title,
    required String subtitle,
    String? badgeText,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: _currentTree.primaryColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Center(
              child: customWidget ?? Text(emoji ?? '✨', style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _currentTree.primaryColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVictoryOverlay(TreeProfile tree) {
    return Positioned.fill(
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
              border: Border.all(color: const Color(0xFF10B981), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 36,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                  blurRadius: 40,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(tree.fruitEmoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      const Text(
                        'PANEN RAYA BERHASIL!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF15803D),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('🧺', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('🌳 🧺 🌟', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  '${tree.name} Berbuah Lebat!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    'Hebat sekali! ${UserProfileService.childName} berhasil menanam, menyiram, dan memetik ${tree.fruitCount} ${tree.fruitName} segar ke keranjang!',
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
                        label: 'Tanam Lagi 🔄',
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          _setupTreeRound();
                        },
                        variant: AliButtonVariant.outline,
                        size: AliButtonSize.large,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: AliButton(
                        label: 'Pohon Berikutnya ➜',
                        onPressed: _nextTree,
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
    );
  }
}

class _Seed3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(center: center, width: size.width * 0.72, height: size.height * 0.88);

    // Claymorphic Nut/Seed shell
    final seedPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.85,
        colors: const [Color(0xFFD97706), Color(0xFF92400E), Color(0xFF451A03)],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);
    canvas.drawOval(rect, seedPaint);

    // Specular highlight
    final hlRect = Rect.fromCenter(
      center: center - Offset(size.width * 0.12, size.height * 0.16),
      width: size.width * 0.26,
      height: size.height * 0.35,
    );
    canvas.drawOval(
      hlRect,
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );

    // Tiny cute sprout tip
    final tipPath = Path()
      ..moveTo(center.dx, center.dy - size.height * 0.44)
      ..cubicTo(center.dx + 4, center.dy - size.height * 0.52, center.dx + 6, center.dy - size.height * 0.48, center.dx, center.dy - size.height * 0.40);
    canvas.drawPath(
      tipPath,
      Paint()
        ..color = const Color(0xFF84CC16)
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Sun3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.32;

    // Glowing Rays
    final rayPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFACC15).withValues(alpha: 0.8),
          const Color(0xFFF59E0B).withValues(alpha: 0.4),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    canvas.drawCircle(center, size.width / 2, rayPaint);

    // Sun Core (Warm glossy gradient)
    final sunRect = Rect.fromCircle(center: center, radius: radius);
    final corePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: const [Color(0xFFFEF08A), Color(0xFFFBBF24), Color(0xFFEA580C)],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(sunRect);
    canvas.drawCircle(center, radius, corePaint);

    // Gloss Glint
    canvas.drawOval(
      Rect.fromCenter(center: center - Offset(radius * 0.3, radius * 0.3), width: radius * 0.6, height: radius * 0.35),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );

    // Cute Friendly Face
    final facePaint = Paint()..color = const Color(0xFF78350F);
    canvas.drawCircle(center + Offset(-radius * 0.35, -radius * 0.08), 2.0, facePaint);
    canvas.drawCircle(center + Offset(radius * 0.35, -radius * 0.08), 2.0, facePaint);

    final smilePath = Path()
      ..moveTo(center.dx - radius * 0.28, center.dy + radius * 0.15)
      ..quadraticBezierTo(center.dx, center.dy + radius * 0.42, center.dx + radius * 0.28, center.dy + radius * 0.15);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF78350F)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Basket3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Handle
    final handleRect = Rect.fromCenter(center: center - Offset(0, size.height * 0.12), width: size.width * 0.62, height: size.height * 0.62);
    canvas.drawArc(
      handleRect,
      3.14,
      3.14,
      false,
      Paint()
        ..color = const Color(0xFFB45309)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Basket Body Wicker
    final bodyPath = Path()
      ..moveTo(center.dx - size.width * 0.38, center.dy - size.height * 0.08)
      ..lineTo(center.dx + size.width * 0.38, center.dy - size.height * 0.08)
      ..lineTo(center.dx + size.width * 0.26, center.dy + size.height * 0.36)
      ..cubicTo(
        center.dx + size.width * 0.12, center.dy + size.height * 0.42,
        center.dx - size.width * 0.12, center.dy + size.height * 0.42,
        center.dx - size.width * 0.26, center.dy + size.height * 0.36,
      )
      ..close();

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Color(0xFFFDE68A), Color(0xFFD97706), Color(0xFF92400E)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(bodyPath, bodyPaint);

    // Rim
    final rimRect = Rect.fromCenter(center: center - Offset(0, size.height * 0.08), width: size.width * 0.78, height: size.height * 0.16);
    canvas.drawOval(
      rimRect,
      Paint()
        ..color = const Color(0xFFF59E0B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

