import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

class SentenceItem {
  final String id;
  final String label;
  final String? audioUrl;
  final String? audioAbiUrl;
  final String? audioUmmaUrl;

  const SentenceItem({
    required this.id,
    required this.label,
    this.audioUrl,
    this.audioAbiUrl,
    this.audioUmmaUrl,
  });
}

class SentenceBuilderBar extends StatelessWidget {
  final List<SentenceItem> items;
  final bool isPlaying;
  final VoidCallback onPlaySentence;
  final VoidCallback onClearAll;
  final ValueChanged<int> onRemoveItem;

  const SentenceBuilderBar({
    super.key,
    required this.items,
    required this.isPlaying,
    required this.onPlaySentence,
    required this.onClearAll,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.borderCard, width: 1.2),
        boxShadow: AppShadows.floatingDockShadow,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s14,
        vertical: AppSpacing.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    decoration: const BoxDecoration(
                      color: AppColors.surfacePill,
                      shape: BoxShape.circle,
                    ),
                    child: const AliIcon(Iconsax.voice_cricle, size: 20, color: AppColors.accentSky),
                  ),
                  const SizedBox(width: AppSpacing.s10),
                  Text('Rangkaian Suara Ali', style: AppTypography.titleLarge()),
                ],
              ),
              if (items.isNotEmpty)
                GestureDetector(
                  onTap: onClearAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s6),
                    decoration: BoxDecoration(
                      color: AppColors.surfacePill,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.borderCard, width: 1),
                    ),
                    child: Text('Hapus Semua', style: AppTypography.pill(color: AppColors.accentCoral)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.all(AppSpacing.s10),
            decoration: BoxDecoration(
              color: AppColors.surfaceCardSubtle,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderSubtle, width: 1.0),
            ),
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'Sentuh kartu kosa kata di bawah untuk merangkai kalimat...',
                      style: AppTypography.bodyMedium(),
                    ),
                  )
                : Wrap(
                    spacing: AppSpacing.s8,
                    runSpacing: AppSpacing.s8,
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.s14,
                          right: AppSpacing.s6,
                          top: AppSpacing.s4,
                          bottom: AppSpacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.borderCard, width: 1.2),
                          boxShadow: AppShadows.cardShadow,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(item.label, style: AppTypography.titleMedium()),
                            const SizedBox(width: AppSpacing.s6),
                            // Large, comfortable X touch target (36x36)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onRemoveItem(index),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfacePill,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.close_rounded, size: 18, color: AppColors.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}
