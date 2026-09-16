import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme_tokens.dart';

class AliPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Color? activeColor;
  final bool showDot;

  const AliPill({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.prefixIcon,
    this.activeColor,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.pureBlack;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? effectiveActiveColor : AppColors.surfacePill,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.borderSubtle,
            width: 1,
          ),
          boxShadow: isSelected ? AppShadows.buttonGlow(effectiveActiveColor) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accentLime,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
            ],
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: AppSpacing.s6),
            ],
            Text(
              label,
              style: AppTypography.pill(
                color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
