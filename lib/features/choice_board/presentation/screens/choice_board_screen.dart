import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_modal.dart';
import '../../../../core/components/ali_network_image.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../aac_board/domain/models/vocab_card_model.dart';

class ChoiceOptionItem {
  final String id;
  String label;
  String imageUrl;
  String? audioUrl;
  Color accentBg;

  ChoiceOptionItem({
    required this.id,
    required this.label,
    required this.imageUrl,
    this.audioUrl,
    required this.accentBg,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'accentBg': accentBg.value,
      };

  factory ChoiceOptionItem.fromJson(Map<String, dynamic> json) =>
      ChoiceOptionItem(
        id: json['id'] as String? ?? UniqueKey().toString(),
        label: json['label'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        audioUrl: json['audioUrl'] as String?,
        accentBg: json['accentBg'] != null
            ? Color(json['accentBg'] as int)
            : const Color(0xFFE0F2FE),
      );

  ChoiceOptionItem copyWith({
    String? id,
    String? label,
    String? imageUrl,
    String? audioUrl,
    Color? accentBg,
  }) {
    return ChoiceOptionItem(
      id: id ?? this.id,
      label: label ?? this.label,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      accentBg: accentBg ?? this.accentBg,
    );
  }
}

class ChoiceBoardScreen extends StatefulWidget {
  final List<VocabCardModel> availableCards;
  final VoidCallback? onBack;

  const ChoiceBoardScreen({
    super.key,
    required this.availableCards,
    this.onBack,
  });

  @override
  State<ChoiceBoardScreen> createState() => _ChoiceBoardScreenState();
}

class _ChoiceBoardScreenState extends State<ChoiceBoardScreen>
    with SingleTickerProviderStateMixin {
  int _modeIndex = 0; // 0: 2 Pilihan (A vs B), 1: 4 Pilihan
  String _selectedId = '';
  bool _isLoading = true;

  late AnimationController _celebrationController;
  late Animation<double> _popAnimation;
  ChoiceOptionItem? _recentlyChosenOption;

  static const String _prefTwoChoicesKey = 'ali_choice_board_two_v2';
  static const String _prefFourChoicesKey = 'ali_choice_board_four_v2';

  late List<ChoiceOptionItem> _twoChoices;
  late List<ChoiceOptionItem> _fourChoices;

  List<VocabCardModel> get _cards => widget.availableCards;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _popAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 0.98).chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 30),
    ]).animate(_celebrationController);

    _initDefaultPresets();
    _loadChoices();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChoiceBoardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableCards.isEmpty && _cards.isNotEmpty) {
      _applyCardFallbacks();
    }
  }

  void _applyCardFallbacks() {
    if (_cards.isEmpty) return;
    bool changed = false;
    for (int i = 0; i < _twoChoices.length; i++) {
      if (_twoChoices[i].imageUrl.isEmpty && i < _cards.length) {
        _twoChoices[i].imageUrl = _cards[i].imageUrl;
        _twoChoices[i].label = _cards[i].label;
        changed = true;
      }
    }
    for (int i = 0; i < _fourChoices.length; i++) {
      if (_fourChoices[i].imageUrl.isEmpty && i < _cards.length) {
        _fourChoices[i].imageUrl = _cards[i].imageUrl;
        _fourChoices[i].label = _cards[i].label;
        changed = true;
      }
    }
    if (changed) {
      _saveChoices();
      if (mounted) setState(() {});
    }
  }

  void _initDefaultPresets() {
    final c1 = _cards.isNotEmpty ? _cards[0] : null;
    final c2 = _cards.length > 1 ? _cards[1] : null;
    final c3 = _cards.length > 2 ? _cards[2] : null;
    final c4 = _cards.length > 3 ? _cards[3] : null;

    _twoChoices = [
      ChoiceOptionItem(
        id: 'opt_1',
        label: c1?.label ?? 'Minum',
        imageUrl: c1?.imageUrl ?? '',
        accentBg: const Color(0xFFE0F2FE),
      ),
      ChoiceOptionItem(
        id: 'opt_2',
        label: c2?.label ?? 'Makan',
        imageUrl: c2?.imageUrl ?? '',
        accentBg: const Color(0xFFFEF9C3),
      ),
    ];

    _fourChoices = [
      ChoiceOptionItem(
        id: 'opt_1',
        label: c1?.label ?? 'Makan',
        imageUrl: c1?.imageUrl ?? '',
        accentBg: const Color(0xFFFEF3C7),
      ),
      ChoiceOptionItem(
        id: 'opt_2',
        label: c2?.label ?? 'Minum',
        imageUrl: c2?.imageUrl ?? '',
        accentBg: const Color(0xFFE0F2FE),
      ),
      ChoiceOptionItem(
        id: 'opt_3',
        label: c3?.label ?? 'Mainan',
        imageUrl: c3?.imageUrl ?? '',
        accentBg: const Color(0xFFFCE7F3),
      ),
      ChoiceOptionItem(
        id: 'opt_4',
        label: c4?.label ?? 'Tidur',
        imageUrl: c4?.imageUrl ?? '',
        accentBg: const Color(0xFFEDE9FE),
      ),
    ];
  }

  Future<void> _loadChoices() async {
    // 1. Coba load dari Supabase per user_id
    try {
      final cloudData = await SupabaseService.getUserChoiceBoard();
      if (cloudData != null) {
        if (cloudData['two_choices'] is List && (cloudData['two_choices'] as List).isNotEmpty) {
          _twoChoices = (cloudData['two_choices'] as List).map((e) => ChoiceOptionItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        }
        if (cloudData['four_choices'] is List && (cloudData['four_choices'] as List).isNotEmpty) {
          _fourChoices = (cloudData['four_choices'] as List).map((e) => ChoiceOptionItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
        }
        if (cloudData['last_selected_id'] != null) {
          _selectedId = cloudData['last_selected_id'].toString();
        }
      }
    } catch (e) {
      debugPrint('Supabase choice board fetch note: $e');
    }

    // 2. Fallback / Local Cache SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final twoRaw = prefs.getString(_prefTwoChoicesKey);
      if (twoRaw != null && _twoChoices.isEmpty) {
        final decoded = jsonDecode(twoRaw) as List;
        _twoChoices = decoded.map((e) => ChoiceOptionItem.fromJson(e)).toList();
      }
      final fourRaw = prefs.getString(_prefFourChoicesKey);
      if (fourRaw != null && _fourChoices.isEmpty) {
        final decoded = jsonDecode(fourRaw) as List;
        _fourChoices = decoded.map((e) => ChoiceOptionItem.fromJson(e)).toList();
      }
      _applyCardFallbacks();
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChoices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_modeIndex == 0) {
        await prefs.setString(_prefTwoChoicesKey, jsonEncode(_twoChoices.map((e) => e.toJson()).toList()));
      } else {
        await prefs.setString(_prefFourChoicesKey, jsonEncode(_fourChoices.map((e) => e.toJson()).toList()));
      }
    } catch (_) {}

    // Cloud sync ke Supabase per akun user
    try {
      await SupabaseService.saveUserChoiceBoard(
        twoChoices: _twoChoices.map((e) => e.toJson()).toList(),
        fourChoices: _fourChoices.map((e) => e.toJson()).toList(),
        lastSelectedId: _selectedId,
      );
    } catch (e) {
      debugPrint('Cloud save choice board error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 600;
    final childName = UserProfileService.childName;

    final currentOptions = _modeIndex == 0 ? _twoChoices : _fourChoices;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
              child: AliHeaderSection(
                title: 'Pilih Keinginan $childName',
                subtitle: 'Fokus Visual Bebas Kewalahan',
                onBackTap: widget.onBack ?? () => Navigator.pop(context),
                tabs: const ['2 Pilihan (A vs B)', '4 Pilihan'],
                activeTabIndex: _modeIndex,
                onTabChanged: (idx) {
                  setState(() {
                    _modeIndex = idx;
                    _selectedId = '';
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.cardGap),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                      child: _modeIndex == 0
                          ? _buildTwoChoicesLayout(isTablet)
                          : _buildFourChoicesLayout(isTablet),
                    ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: 12),
              decoration: BoxDecoration(
                color: _selectedId.isEmpty
                    ? AppColors.surfaceCard
                    : const Color(0xFFF0FDF4), // Warm celebration green
                borderRadius: BorderRadius.circular(AppRadius.r24),
                border: Border.all(
                  color: _selectedId.isEmpty
                      ? AppColors.borderCard
                      : const Color(0xFF86EFAC),
                  width: _selectedId.isEmpty ? 1.0 : 2.0,
                ),
                boxShadow: _selectedId.isEmpty
                    ? AppShadows.cardShadow
                    : [
                        BoxShadow(
                          color: const Color(0xFF16A34A).withValues(alpha: 0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedId.isEmpty ? AppColors.accentLemon : const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _selectedId.isEmpty ? Icons.touch_app_rounded : Icons.star_rounded,
                      size: 22,
                      color: _selectedId.isEmpty ? AppColors.textPrimary : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedId.isEmpty
                              ? 'Ayo Sentuh Kartu Pilihanmu!'
                              : '$childName Memilih:',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _selectedId.isEmpty ? AppColors.textSecondary : const Color(0xFF15803D),
                            letterSpacing: 0.2,
                          ),
                        ),
                        Text(
                          _selectedId.isEmpty
                              ? 'Pilih salah satu gambar di atas ya'
                              : currentOptions.firstWhere((o) => o.id == _selectedId, orElse: () => currentOptions.first).label.toUpperCase(),
                          style: TextStyle(
                            fontSize: _selectedId.isEmpty ? 13 : 16,
                            fontWeight: FontWeight.w900,
                            fontFamily: AppTypography.fontFamily,
                            color: _selectedId.isEmpty ? AppColors.textPrimary : const Color(0xFF14532D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedId.isNotEmpty) ...[
                    IconButton(
                      icon: const Icon(Iconsax.volume_high, color: Color(0xFF15803D), size: 22),
                      tooltip: 'Bunyikan pilihan',
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        final opt = currentOptions.firstWhere((o) => o.id == _selectedId, orElse: () => currentOptions.first);
                        AudioEngineService.speakWord(
                          text: '$childName mau ${opt.label}!',
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                  AliButton(
                    label: 'Tanya',
                    prefixIcon: const AliIcon(Iconsax.messages_3, size: 16, color: AppColors.pureWhite),
                    size: AliButtonSize.small,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      AudioEngineService.speakWord(
                        text: '$childName mau yang mana? Pilih salah satu ya.',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoChoicesLayout(bool isTablet) {
    if (isTablet) {
      return Row(
        children: [
          Expanded(child: _buildChoiceCard(_twoChoices[0])),
          const SizedBox(width: 12),
          Expanded(child: _buildChoiceCard(_twoChoices[1])),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(child: _buildChoiceCard(_twoChoices[0])),
          const SizedBox(height: 10),
          Expanded(child: _buildChoiceCard(_twoChoices[1])),
        ],
      );
    }
  }

  Widget _buildFourChoicesLayout(bool isTablet) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: isTablet ? 1.2 : 0.95,
      children: _fourChoices.map((opt) => _buildChoiceCard(opt)).toList(),
    );
  }

  void _onOptionChosen(ChoiceOptionItem option) {
    HapticFeedback.heavyImpact();
    setState(() {
      _selectedId = option.id;
      _recentlyChosenOption = option;
    });

    _celebrationController.reset();
    _celebrationController.forward();

    try {
      final childName = UserProfileService.childName;
      AudioEngineService.speakWord(
        text: '$childName mau ${option.label}! Pilihan bagus!',
      );
      // Log child activity untuk progress tracking orang tua
      SupabaseService.logChildActivity(
        activityType: 'choice_made',
        targetLabel: option.label,
        category: 'Papan Pilihan',
        success: true,
      );
    } catch (e) {
      debugPrint('Audio playback error on choice: $e');
    }
  }

  Widget _buildChoiceCard(ChoiceOptionItem option) {
    final isSelected = _selectedId == option.id;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onOptionChosen(option),
      child: AnimatedBuilder(
        animation: _popAnimation,
        builder: (context, child) {
          final scale = isSelected ? _popAnimation.value : 1.0;
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isSelected ? option.accentBg : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r28),
            border: Border.all(
              color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
              width: isSelected ? 3.5 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.pureBlack.withValues(alpha: 0.16),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ]
                : AppShadows.cardShadow,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final availableWidth = constraints.maxWidth;
              // Maximize square image size while keeping margins for title
              final squareSize = (availableHeight - 56).clamp(110.0, availableWidth - 28.0);

              return Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 6.0, left: 10.0, right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Large Square Image with clean squircle corners
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.r20),
                            child: Container(
                              height: squareSize,
                              width: squareSize,
                              color: AppColors.surfaceCardSubtle,
                              child: AliNetworkImage(
                                imageUrl: option.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: const Center(
                                  child: Icon(Iconsax.image, size: 48, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: _modeIndex == 0
                                  ? (isSelected ? 23 : 21)
                                  : (isSelected ? 17 : 15.5),
                              fontWeight: FontWeight.w900,
                              fontFamily: AppTypography.fontFamily,
                              color: isSelected ? AppColors.pureBlack : AppColors.textPrimary,
                            ),
                            child: Text(
                              option.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Edit button top-right
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _openCardPickerForChoice(option),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePill,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderCard, width: 0.8),
                        ),
                        child: const Icon(Iconsax.edit_2, size: 15, color: AppColors.textPrimary),
                      ),
                    ),
                  ),

                  // Selected badge indicator top-left
                  if (isSelected)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.pureBlack,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentLemon),
                            SizedBox(width: 4),
                            Text(
                              'DIPILIH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
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
      ),
    );
  }

  void _openCardPickerForChoice(ChoiceOptionItem option) {
    String search = '';

    AliModal.showDeckModal(
      context: context,
      isFullHeight: true,
      title: 'Pilih Kartu dari AAC Ali',
      subtitle: 'Ganti pilihan dengan foto nyata dari kartu AAC',
      body: StatefulBuilder(
        builder: (ctx, setModalState) {
          final filtered = _cards.where((c) {
            if (search.isEmpty) return true;
            return c.label.toLowerCase().contains(search.toLowerCase());
          }).toList();

          return Column(
            children: [
              TextField(
                onChanged: (val) => setModalState(() => search = val),
                decoration: InputDecoration(
                  hintText: 'Cari kartu kosa kata AAC...',
                  prefixIcon: const Icon(Iconsax.search_normal_1, size: 18),
                  filled: true,
                  fillColor: AppColors.surfaceCardSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Tidak ada kartu yang cocok'))
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final card = filtered[i];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                option.label = card.label;
                                option.imageUrl = card.imageUrl;
                              });
                              _saveChoices();
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(AppRadius.r20),
                                border: Border.all(color: AppColors.borderCard),
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
                                      child: AliNetworkImage(
                                        imageUrl: card.imageUrl,
                                        fit: BoxFit.cover,
                                        errorWidget: const Center(
                                          child: Icon(Iconsax.image, color: AppColors.textMuted),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                    child: Text(
                                      card.label,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: AppTypography.fontFamily,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
