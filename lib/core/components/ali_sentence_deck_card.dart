import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';
import 'sentence_builder_bar.dart';

class AliSentenceDeckCard extends StatelessWidget {
  final List<SentenceItem> items;
  final bool isPlaying;
  final VoidCallback onPlaySentence;
  final VoidCallback onClearAll;
  final ValueChanged<int> onRemoveItem;

  const AliSentenceDeckCard({
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.borderCard, width: 1.2),
        boxShadow: AppShadows.floatingDockShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Title Row + Clear Action
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
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onClearAll();
                  },
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

          // Items Chips Flow or Empty Placeholder (Spacious Box)
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
                      'Sentuh kartu di bawah untuk merangkai kalimat Ali...',
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
                          right: AppSpacing.s4,
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
                            const SizedBox(width: AppSpacing.s8),
                            // Large, comfortable X touch target (36x36)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onRemoveItem(index);
                              },
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

          if (items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s12),
            // High-Contrast Dark Pill Action Button (Larger & Prominent)
            GestureDetector(
              onTap: isPlaying ? null : onPlaySentence,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
                decoration: BoxDecoration(
                  color: isPlaying ? AppColors.textMuted : AppColors.surfacePillDark,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: isPlaying ? null : AppShadows.floatingDockShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AliIcon(
                      isPlaying ? Iconsax.pause : Iconsax.play,
                      size: 22,
                      color: AppColors.accentLemon,
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      isPlaying ? 'Membacakan Rangkaian Suara...' : 'Bicara Bersama Abi & Umma',
                      style: AppTypography.button(color: AppColors.textOnDark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
