import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

class AliBottomTabsDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback? onCenterActionTap;

  const AliBottomTabsDock({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.onCenterActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        left: AppSpacing.screenMargin, // Exact 4px margin
        right: AppSpacing.screenMargin, // Exact 4px margin
        bottom: AppSpacing.s12,
        top: AppSpacing.s4,
      ),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
        decoration: BoxDecoration(
          color: AppColors.surfacePillDark, // Slate Dark Bar from image copy.png
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: AppShadows.floatingDockShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Tab 0: Home / AAC Board
            _TabIconItem(
              icon: Iconsax.grid_1,
              label: 'Papan AAC',
              isActive: currentIndex == 0,
              onTap: () => onIndexChanged(0),
            ),

            // Tab 1: Belajar Menulis (Huruf & Angka)
            _TabIconItem(
              icon: Iconsax.edit_2,
              label: 'Menulis',
              isActive: currentIndex == 1,
              onTap: () => onIndexChanged(1),
            ),

            // Center Quick Action (Plus Button)
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onCenterActionTap?.call();
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: AppColors.accentLemon, // Electric Citron Accent
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: AliIcon(Iconsax.add, size: 24, color: AppColors.textPrimary),
                ),
              ),
            ),

            // Tab 2: Dual Canvas Ali
            _TabIconItem(
              icon: Iconsax.brush_2,
              label: 'Kanvas Ali',
              isActive: currentIndex == 2,
              onTap: () => onIndexChanged(2),
            ),

            // Tab 3: Settings & Logs
            _TabIconItem(
              icon: Iconsax.setting_2,
              label: 'Pengaturan',
              isActive: currentIndex == 3,
              onTap: () => onIndexChanged(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabIconItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceCard : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AliIcon(
              icon,
              size: 20,
              color: isActive ? AppColors.textPrimary : AppColors.textMuted,
            ),
            if (isActive) ...[
              const SizedBox(width: AppSpacing.s6),
              Text(
                label,
                style: AppTypography.pill(color: AppColors.textPrimary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
