import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

class AliHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onActionTap;
  final IconData? actionIcon;
  final bool showNotificationDot;
  final List<Widget>? filterPills;

  const AliHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    this.onAvatarTap,
    this.onSearchTap,
    this.onActionTap,
    this.actionIcon,
    this.showNotificationDot = false,
    this.filterPills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceLight,
      padding: const EdgeInsets.only(
        top: AppSpacing.s12,
        bottom: AppSpacing.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Navigation & Action Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar / Profile Pill
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onAvatarTap?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderSubtle, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.surfaceMuted,
                      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                          ? const AliIcon(Iconsax.user, size: 18, color: AppColors.textPrimary)
                          : null,
                    ),
                  ),
                ),

                // Right Quick Action Icons
                Row(
                  children: [
                    if (onSearchTap != null)
                      _HeaderIconButton(
                        icon: Iconsax.search_normal_1,
                        onTap: onSearchTap!,
                      ),
                    if (actionIcon != null && onActionTap != null) ...[
                      const SizedBox(width: AppSpacing.s8),
                      _HeaderIconButton(
                        icon: actionIcon!,
                        hasDot: showNotificationDot,
                        onTap: onActionTap!,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          // Title & Greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.displayLarge(),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMedium(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),

          // Optional Filter Pill Carousel
          if (filterPills != null && filterPills!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
              child: Row(
                children: filterPills!
                    .map((pill) => Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.s6),
                          child: pill,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasDot;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.hasDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Center(
              child: AliIcon(icon, size: 19, color: AppColors.textPrimary),
            ),
          ),
          if (hasDot)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.accentYellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
