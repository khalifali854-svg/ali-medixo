import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

class AliHeaderSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBackTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onExportTap;
  final Widget? actionWidget;
  final Widget? bottomWidget;
  final List<String> tabs;
  final int activeTabIndex;
  final ValueChanged<int>? onTabChanged;

  const AliHeaderSection({
    super.key,
    required this.title,
    this.subtitle,
    this.onBackTap,
    this.onAddTap,
    this.onFilterTap,
    this.onExportTap,
    this.actionWidget,
    this.bottomWidget,
    this.tabs = const [],
    this.activeTabIndex = 0,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCanvas,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderCard.withValues(alpha: 0.8),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Back Button Circle / Squircle Pill
              if (onBackTap != null) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onBackTap?.call();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.borderCard, width: 1.2),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Title & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        fontFamily: AppTypography.fontFamily,
                        letterSpacing: -0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: -0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Segmented View Toggle (Grid / List icon pills if exactly 2 tabs with grid/list)
              if (tabs.length == 2 && onTabChanged != null) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePill,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.borderCard, width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CompactViewTab(
                        icon: Iconsax.grid_1,
                        isSelected: activeTabIndex == 0,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTabChanged!(0);
                        },
                      ),
                      const SizedBox(width: 4),
                      _CompactViewTab(
                        icon: Iconsax.row_vertical,
                        isSelected: activeTabIndex == 1,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTabChanged!(1);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],

              if (actionWidget != null) ...[
                actionWidget!,
                const SizedBox(width: 8),
              ],

              // Quick Action Add Circle Button
              if (onAddTap != null)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onAddTap!();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.pureBlack,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.add_rounded, size: 24, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          if (tabs.length > 2 && onTabChanged != null) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabs.length, (idx) {
                  final isSelected = activeTabIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTabChanged!(idx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.pureBlack : AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
                            width: 1.0,
                          ),
                          boxShadow: isSelected ? AppShadows.cardShadow : null,
                        ),
                        child: Text(
                          tabs[idx],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppTypography.fontFamily,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
          if (bottomWidget != null) ...[
            const SizedBox(height: 8),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}

class _CompactViewTab extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompactViewTab({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pureBlack : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Icon(
          icon,
          size: 15,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Sticky Header Delegate untuk SliverPersistentHeader
class AliStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const AliStickyHeaderDelegate({
    required this.child,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant AliStickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
