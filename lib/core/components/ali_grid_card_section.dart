import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';
import 'ali_network_image.dart';

class AliGridCardSection extends StatefulWidget {
  final String title;
  final String categoryTag;
  final String imageUrl;
  final String? emoji;
  final String? subtitle;
  final IconData? subtitleIcon;
  final VoidCallback? onTap;
  final VoidCallback? onPlaySound;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;

  const AliGridCardSection({
    super.key,
    required this.title,
    required this.categoryTag,
    required this.imageUrl,
    this.emoji,
    this.subtitle,
    this.subtitleIcon,
    this.onTap,
    this.onPlaySound,
    this.onLongPress,
    this.onEdit,
  });

  @override
  State<AliGridCardSection> createState() => _AliGridCardSectionState();
}

class _AliGridCardSectionState extends State<AliGridCardSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r24),
            border: Border.all(color: AppColors.borderCard, width: 1.0),
            boxShadow: AppShadows.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. FULL CARD IMAGE or TYPOGRAPHIC ART CARD (when imageUrl is empty)
                if (widget.imageUrl.trim().isNotEmpty) ...[
                  AliNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      color: AppColors.surfacePillDark,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AliIcon(Iconsax.image, size: 36, color: AppColors.accentLemon),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              widget.title,
                              style: AppTypography.cardTitle(color: AppColors.pureWhite),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Dark Gradient Overlay for photo cards
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.40),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          stops: const [0.0, 0.35, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Premium Typographic Card for Hijaiyah, Numbers & Letters
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E293B),
                          const Color(0xFF0F172A),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Soft ambient circle background
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentLemon.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                        // Centered Large Glyph
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.emoji == 'ء' ? 14.0 : 28.0,
                              top: widget.emoji == 'ء' ? 14.0 : 0.0,
                            ),
                            child: Text(
                              widget.emoji != null && widget.emoji!.isNotEmpty
                                  ? widget.emoji!
                                  : (widget.title.isNotEmpty ? widget.title[0] : '✨'),
                              style: TextStyle(
                                fontSize: widget.emoji == 'ء' ? 70 : 62,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentLemon,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                        // Dark bottom gradient to protect title text
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.80),
                                ],
                                stops: const [0.45, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 3. Top Floating Badges (Category Pill & Audio Button)
                Positioned(
                  top: AppSpacing.s8,
                  left: AppSpacing.s8,
                  right: AppSpacing.s8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Translucent Glass Category Pill (Flexible to prevent horizontal overflow on narrow cards)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentLemon,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s4),
                              Flexible(
                                child: Text(
                                  widget.categoryTag,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodySmall(color: AppColors.pureWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s4),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.onEdit != null) ...[
                            GestureDetector(
                              onTap: widget.onEdit,
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.s6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.55),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 0.8),
                                ),
                                child: const AliIcon(Iconsax.camera, size: 14, color: AppColors.accentLemon),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s4),
                          ],
                          // Audio Trigger Circle Pill
                          GestureDetector(
                            onTap: widget.onPlaySound,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.s6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 0.8),
                              ),
                              child: const AliIcon(Iconsax.volume_high, size: 14, color: AppColors.pureWhite),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 4. Bottom Title Overlay (Crisp Pure White Airbnb Cereal Typography)
                Positioned(
                  bottom: AppSpacing.s10,
                  left: AppSpacing.s10,
                  right: AppSpacing.s10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.titleLarge(color: AppColors.pureWhite),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Row(
                        children: [
                          AliIcon(widget.subtitleIcon ?? Iconsax.voice_square, size: 12, color: AppColors.accentLemon),
                          const SizedBox(width: AppSpacing.s4),
                          Expanded(
                            child: Text(
                              widget.subtitle ?? 'Suara Abi',
                              style: AppTypography.bodySmall(color: Colors.white.withValues(alpha: 0.85)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
