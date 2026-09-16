import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

class AliFloatingDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback? onCenterActionTap;

  const AliFloatingDock({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.onCenterActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s8,
        ),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.pureBlack,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: AppShadows.floatingDockShadow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DockItem(
                icon: Iconsax.grid_15,
                label: 'Kosakata',
                isSelected: currentIndex == 0,
                onTap: () => onIndexChanged(0),
              ),
              _DockItem(
                icon: Iconsax.brush_2,
                label: 'Dual Canvas',
                isSelected: currentIndex == 1,
                onTap: () => onIndexChanged(1),
              ),
              if (onCenterActionTap != null)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onCenterActionTap!();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.pureWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: AliIcon(
                        Iconsax.add,
                        size: 22,
                        color: AppColors.pureBlack,
                      ),
                    ),
                  ),
                ),
              _DockItem(
                icon: Iconsax.chart_2,
                label: 'Aktivitas',
                isSelected: currentIndex == 2,
                onTap: () => onIndexChanged(2),
              ),
              _DockItem(
                icon: Iconsax.setting_2,
                label: 'Mode Abi',
                isSelected: currentIndex == 3,
                onTap: () => onIndexChanged(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.label,
    required this.isSelected,
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pureWhite.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: AliIcon(
          icon,
          size: 22,
          color: isSelected ? AppColors.pureWhite : AppColors.textMuted,
        ),
      ),
    );
  }
}
