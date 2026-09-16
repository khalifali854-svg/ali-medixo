import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme_tokens.dart';

class AliModal {
  static Future<T?> showDeckModal<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget body,
    List<Widget>? actions,
    bool isDismissible = true,
    bool isFullHeight = false,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DeckModalContent(
        title: title,
        subtitle: subtitle,
        body: body,
        actions: actions,
        isFullHeight: isFullHeight,
      ),
    );
  }
}

class _DeckModalContent extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final bool isFullHeight;

  const _DeckModalContent({
    required this.title,
    this.subtitle,
    required this.body,
    this.actions,
    this.isFullHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final totalHeight = MediaQuery.of(context).size.height;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        height: isFullHeight ? (totalHeight * 0.92) : null,
        margin: const EdgeInsets.only(
          left: AppSpacing.s4,
          right: AppSpacing.s4,
          bottom: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r32),
            topRight: Radius.circular(AppRadius.r32),
            bottomLeft: Radius.circular(AppRadius.r24),
            bottomRight: Radius.circular(AppRadius.r24),
          ),
          border: Border.all(color: AppColors.borderCard, width: 1),
          boxShadow: AppShadows.floatingDockShadow,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.s16,
            right: AppSpacing.s16,
            top: AppSpacing.s12,
            bottom: AppSpacing.s16 + bottomInset,
          ),
          child: Column(
            mainAxisSize: isFullHeight ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Elastic Drag Pill
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s16),

              // Title Section
              Text(
                title,
                style: AppTypography.titleLarge(),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.s4),
                Text(
                  subtitle!,
                  style: AppTypography.bodyMedium(color: AppColors.textSecondary),
                ),
              ],

              const SizedBox(height: AppSpacing.s16),

              // Content Body
              if (isFullHeight)
                Expanded(child: body)
              else
                Flexible(child: body),

              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s20),
                Row(
                  children: actions!
                      .map((action) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                              child: action,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
