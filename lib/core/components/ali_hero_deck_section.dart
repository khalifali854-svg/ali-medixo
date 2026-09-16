import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';
import 'ali_button.dart';
import 'ali_network_image.dart';

class AliHeroDeckSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String categoryTag;
  final VoidCallback? onSpeak;
  final VoidCallback? onAddToSentence;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const AliHeroDeckSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.categoryTag,
    this.onSpeak,
    this.onAddToSentence,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.r32),
        border: Border.all(color: AppColors.borderCard, width: 1),
        boxShadow: AppShadows.floatingDockShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Layered Edge Indicator (Simulating Stacked Deck on Top)
          Positioned(
            top: 0,
            left: 24,
            right: 24,
            height: 8,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r16)),
              ),
            ),
          ),

          // Main Hero Image Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.05,
                    child: AliNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Bottom Gradient Shadow over Image for Text & Action Contrast
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.65),
                            Colors.black.withValues(alpha: 0.92),
                          ],
                          stops: const [0.0, 0.45, 0.72, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Floating Category Pill (Top Left)
                  Positioned(
                    top: AppSpacing.s12,
                    left: AppSpacing.s12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s12,
                        vertical: AppSpacing.s6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pureBlack.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.2), width: 1),
                      ),
                      child: Text(
                        categoryTag.toUpperCase(),
                        style: AppTypography.pill(color: AppColors.pureWhite).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),

                  // Floating Favorite Button (Top Right)
                  Positioned(
                    top: AppSpacing.s12,
                    right: AppSpacing.s12,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onFavorite?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.s8),
                        decoration: BoxDecoration(
                          color: AppColors.pureBlack.withValues(alpha: 0.65),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.pureWhite.withValues(alpha: 0.2), width: 1),
                        ),
                        child: AliIcon(
                          isFavorite ? Iconsax.heart5 : Iconsax.heart,
                          size: 18,
                          color: isFavorite ? AppColors.accentCoral : AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),

                  // Hero Text & Speak CTA Overlay
                  Positioned(
                    left: AppSpacing.s16,
                    right: AppSpacing.s16,
                    bottom: AppSpacing.s16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppTypography.displayLarge(color: AppColors.pureWhite),
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        Text(
                          subtitle,
                          style: AppTypography.bodyMedium(color: AppColors.pureWhite.withValues(alpha: 0.8)),
                        ),
                        const SizedBox(height: AppSpacing.s16),

                        // High-Contrast Main Action Button (ala "Booking Now" pill)
                        Row(
                          children: [
                            Expanded(
                              child: AliButton(
                                label: 'Bicara Bersama Abi',
                                variant: AliButtonVariant.primaryHighContrast,
                                size: AliButtonSize.medium,
                                prefixIcon: const AliIcon(
                                  Iconsax.volume_high5,
                                  size: 18,
                                  color: AppColors.pureBlack,
                                ),
                                onPressed: onSpeak,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s8),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                onAddToSentence?.call();
                              },
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.pureWhite.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.pureWhite.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: AliIcon(
                                    Iconsax.add,
                                    size: 22,
                                    color: AppColors.pureWhite,
                                  ),
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
            ],
          ),
        ],
      ),
    );
  }
}
