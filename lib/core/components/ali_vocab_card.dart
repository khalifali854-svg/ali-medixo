import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';
import 'ali_network_image.dart';

class AliVocabCard extends StatefulWidget {
  final String label;
  final String imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onPlaySound;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isFavorite;
  final String? categoryName;

  const AliVocabCard({
    super.key,
    required this.label,
    required this.imageUrl,
    this.onTap,
    this.onPlaySound,
    this.onLongPress,
    this.isSelected = false,
    this.isFavorite = false,
    this.categoryName,
  });

  @override
  State<AliVocabCard> createState() => _AliVocabCardState();
}

class _AliVocabCardState extends State<AliVocabCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r20),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.pureBlack
                  : AppColors.borderCard,
              width: widget.isSelected ? 2.0 : 1.0,
            ),
            boxShadow: AppShadows.cardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Real Image (High Definition, Studio Cutout or Real Photo)
              AliNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
              ),

              // Bottom Inner Gradient Shadow for High Legibility Text
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.55),
                        Colors.black.withValues(alpha: 0.88),
                      ],
                      stops: const [0.0, 0.45, 0.75, 1.0],
                    ),
                  ),
                ),
              ),

              // Floating Sound Pill Trigger (Top Right)
              if (widget.onPlaySound != null)
                Positioned(
                  top: AppSpacing.s8,
                  right: AppSpacing.s8,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onPlaySound?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.s6),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: const AliIcon(
                        Iconsax.volume_high5,
                        size: 14,
                        color: AppColors.pureBlack,
                      ),
                    ),
                  ),
                ),

              // Bottom Label Pill
              Positioned(
                left: AppSpacing.s8,
                right: AppSpacing.s8,
                bottom: AppSpacing.s8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.categoryName != null)
                      Text(
                        widget.categoryName!.toUpperCase(),
                        style: AppTypography.bodySmall(color: AppColors.pureWhite)
                            .copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.accentLime,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      widget.label,
                      style: AppTypography.cardLabel(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
