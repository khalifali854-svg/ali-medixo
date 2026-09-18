import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';
import 'ali_network_image.dart';

class AliListCardSection extends StatefulWidget {
  final String title;
  final String roleSubtitle;
  final String imageUrl;
  final String categoryTag;
  final String? audioVoiceTag;
  final String dateText;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAudio;
  final ValueChanged<bool>? onCheckboxChanged;

  const AliListCardSection({
    super.key,
    required this.title,
    required this.roleSubtitle,
    required this.imageUrl,
    required this.categoryTag,
    this.audioVoiceTag = 'Suara Abi',
    required this.dateText,
    this.isSelected = false,
    this.isLocked = false,
    this.onTap,
    this.onPlayAudio,
    this.onCheckboxChanged,
  });

  @override
  State<AliListCardSection> createState() => _AliListCardSectionState();
}

class _AliListCardSectionState extends State<AliListCardSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          // Exact Card Style from image copy.png
          margin: const EdgeInsets.only(bottom: AppSpacing.cardGap), // Exact 4px gap
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(
              color: widget.isSelected ? AppColors.accentSky : AppColors.borderCard,
              width: widget.isSelected ? 1.5 : 1.0,
            ),
            boxShadow: widget.isSelected
                ? AppShadows.buttonGlow(AppColors.accentSky)
                : AppShadows.cardShadow,
          ),
          padding: const EdgeInsets.all(AppSpacing.s14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Profile & Status Badge Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Real Avatar / Cutout Photo (Rounded)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                          child: AliNetworkImage(
                            imageUrl: widget.imageUrl,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorWidget: Container(
                              width: 46,
                              height: 46,
                              color: AppColors.surfaceCardSubtle,
                              child: const Center(
                                child: AliIcon(Iconsax.image, size: 20, color: AppColors.textMuted),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: AppSpacing.s12),

                        // Name & Role/Category
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: AppTypography.cardTitle(),
                              ),
                              const SizedBox(height: AppSpacing.s2),
                              Text(
                                widget.roleSubtitle,
                                style: AppTypography.cardSub(),
                              ),
                            ],
                          ),
                        ),

                        // Status Pill (e.g. Electric Lemon • Invited / Aktif from image copy.png)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s10,
                            vertical: AppSpacing.s4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfacePill,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
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
                                'Aktif',
                                style: AppTypography.bodySmall(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.s12),

                    // Divider thin
                    Container(height: 1, color: AppColors.borderCard),

                    const SizedBox(height: AppSpacing.s12),

                    // 3-Metric Data Bar (Exact layout from image copy.png)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s12,
                        vertical: AppSpacing.s10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfacePill,
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MetricColumn(
                            title: 'Kategori',
                            value: widget.categoryTag,
                          ),
                          _MetricColumn(
                            title: 'Audio',
                            value: widget.audioVoiceTag ?? 'Suara Abi',
                            icon: Iconsax.volume_high,
                            onTap: widget.isLocked ? null : widget.onPlayAudio,
                          ),
                          _MetricColumn(
                            title: 'Ditambahkan',
                            value: widget.dateText,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.s10),

                    // Bottom Date & Selection Checkbox Row (Exact layout from image copy.png)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Aktif digunakan Ali',
                          style: AppTypography.bodySmall(),
                        ),
                        // Rounded Checkbox Box (from image copy.png)
                        GestureDetector(
                          onTap: widget.isLocked
                              ? null
                              : () {
                                  HapticFeedback.selectionClick();
                                  widget.onCheckboxChanged?.call(!widget.isSelected);
                                },
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: widget.isSelected ? AppColors.textPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(AppRadius.r8),
                              border: Border.all(
                                color: widget.isSelected ? AppColors.textPrimary : AppColors.borderCard,
                                width: 1.5,
                              ),
                            ),
                            child: widget.isSelected
                                ? const Center(
                                    child: Icon(Icons.check, size: 14, color: AppColors.textOnDark),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Lock Overlay
                if (widget.isLocked)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.75),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.pureBlack.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentLemon, width: 1.5),
                          ),
                          child: const Icon(Icons.lock_rounded, size: 22, color: AppColors.accentLemon),
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
  }
}

class _MetricColumn extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;

  const _MetricColumn({
    required this.title,
    required this.value,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodySmall()),
          const SizedBox(height: AppSpacing.s2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                AliIcon(icon!, size: 14, color: AppColors.accentSky),
                const SizedBox(width: AppSpacing.s4),
              ],
              Text(value, style: AppTypography.titleSmall()),
            ],
          ),
        ],
      ),
    );
  }
}
