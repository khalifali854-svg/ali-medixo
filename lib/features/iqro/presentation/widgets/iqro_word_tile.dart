import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/iqro_models.dart';

class IqroWordTile extends StatefulWidget {
  final IqroWordItem item;
  final bool isHighlighted;
  final bool isTablet;
  final VoidCallback onTap;

  const IqroWordTile({
    super.key,
    required this.item,
    required this.onTap,
    this.isHighlighted = false,
    this.isTablet = false,
  });

  @override
  State<IqroWordTile> createState() => _IqroWordTileState();
}

class _IqroWordTileState extends State<IqroWordTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isTab = widget.isTablet;
    final textLength = widget.item.arabic.length;
    final baseFontSize = isTab ? 42.0 : 34.0;
    final arabicFontSize = textLength > 6
        ? baseFontSize * 0.75
        : (textLength > 3 ? baseFontSize * 0.88 : baseFontSize);

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isTab ? 16 : 10,
            vertical: isTab ? 14 : 10,
          ),
          decoration: BoxDecoration(
            color: widget.isHighlighted
                ? const Color(0xFFFEF3C7) // Golden highlight saat bersuara
                : Colors.white,
            borderRadius: BorderRadius.circular(isTab ? 20 : 16),
            border: Border.all(
              color: widget.isHighlighted
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFFE2E8F0),
              width: widget.isHighlighted ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isHighlighted
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.25)
                    : const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: widget.isHighlighted ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tulisan Arab Tajam Digital
              Text(
                widget.item.arabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: arabicFontSize,
                  fontWeight: FontWeight.bold,
                  height: 1.35,
                  color: widget.isHighlighted
                      ? const Color(0xFFB45309)
                      : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 3),
              // Transliterasi Latin
              Text(
                widget.item.latin,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTab ? 13.5 : 11.5,
                  fontWeight: FontWeight.w600,
                  color: widget.isHighlighted
                      ? const Color(0xFFB45309)
                      : const Color(0xFF64748B),
                ),
              ),
              // Tips Tajwid jika ada
              if (widget.item.tip != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.item.tip!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF059669),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
