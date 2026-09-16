import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';

class AliFormCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? headerTrailing;
  final EdgeInsets? padding;

  const AliFormCard({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.headerTrailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.borderCard, width: 1),
        boxShadow: AppShadows.cardShadow,
      ),
      padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: AppTypography.titleMedium(),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
                if (headerTrailing != null) headerTrailing!,
              ],
            ),
            const SizedBox(height: AppSpacing.s14),
            const Divider(color: AppColors.borderDivider, height: 1),
            const SizedBox(height: AppSpacing.s14),
          ],
          ..._buildChildrenWithDividers(),
        ],
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    List<Widget> items = [];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(const SizedBox(height: AppSpacing.s12));
      }
    }
    return items;
  }
}
