import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/iqro_models.dart';

class IqroCharTile extends StatefulWidget {
  final IqroItem item;
  final bool isHighlighted;
  final bool isTablet;
  final VoidCallback onTap;

  const IqroCharTile({
    super.key,
    required this.item,
    required this.onTap,
    this.isHighlighted = false,
    this.isTablet = false,
  });

  @override
  State<IqroCharTile> createState() => _IqroCharTileState();
}

class _IqroCharTileState extends State<IqroCharTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    final minHeight = isTab ? 96.0 : 76.0;
    final arabicFontSize = isTab ? 44.0 : 36.0;
    final latinFontSize = isTab ? 14.0 : 12.0;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(minHeight: minHeight),
          padding: EdgeInsets.symmetric(
            horizontal: isTab ? 14 : 10,
            vertical: isTab ? 12 : 8,
          ),
          decoration: BoxDecoration(
            color: widget.isHighlighted
                ? const Color(0xFFFEF3C7) // Warm golden highlight
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
              // Huruf Arab dengan Font Khusus Quran/Tajwid
              Text(
                widget.item.arabic,
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontSize: arabicFontSize,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  color: widget.isHighlighted
                      ? const Color(0xFFB45309)
                      : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              // Transliterasi Latin Kecil Ramah Anak
              Text(
                widget.item.latin,
                style: TextStyle(
                  fontSize: latinFontSize,
                  fontWeight: FontWeight.w600,
                  color: widget.isHighlighted
                      ? const Color(0xFFB45309)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
