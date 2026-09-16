import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

enum AliButtonVariant {
  primaryHighContrast, // Pure Deep Slate/Black with crisp white text (from image copy.png)
  electricLemon,       // Electric Lemon Accent with deep slate text (from image copy 2)
  outline,             // White card outline
  danger,              // Coral red
  frostedGlass,        // Light pill
}

enum AliButtonSize {
  small,
  medium,
  large,
}

class AliButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AliButtonVariant variant;
  final AliButtonSize size;
  final AliIcon? prefixIcon;
  final AliIcon? suffixIcon;
  final bool isFullWidth;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const AliButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AliButtonVariant.primaryHighContrast,
    this.size = AliButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isFullWidth = false,
    this.isLoading = false,
    this.padding,
  });

  @override
  State<AliButton> createState() => _AliButtonState();
}

class _AliButtonState extends State<AliButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  Widget _buildIcon(AliIcon icon, Color defaultColor) {
    return AliIcon(
      icon.icon,
      size: icon.size,
      color: icon.color ?? defaultColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Border? border;
    List<BoxShadow>? shadow;

    switch (widget.variant) {
      case AliButtonVariant.primaryHighContrast:
        backgroundColor = AppColors.surfacePillDark;
        textColor = AppColors.textOnDark;
        shadow = AppShadows.floatingDockShadow;
        break;
      case AliButtonVariant.electricLemon:
        backgroundColor = AppColors.accentLemon;
        textColor = AppColors.textPrimary;
        shadow = AppShadows.buttonGlow(AppColors.accentLemon);
        break;
      case AliButtonVariant.outline:
        backgroundColor = AppColors.surfaceCard;
        textColor = AppColors.textPrimary;
        border = Border.all(color: AppColors.borderCard, width: 1.2);
        shadow = AppShadows.cardShadow;
        break;
      case AliButtonVariant.danger:
        backgroundColor = AppColors.accentCoral;
        textColor = AppColors.textOnDark;
        shadow = AppShadows.buttonGlow(AppColors.accentCoral);
        break;
      case AliButtonVariant.frostedGlass:
        backgroundColor = AppColors.surfacePill;
        textColor = AppColors.textPrimary;
        border = Border.all(color: AppColors.borderCard, width: 0.8);
        break;
    }

    double height;
    EdgeInsets defaultPadding;
    TextStyle textStyle;

    switch (widget.size) {
      case AliButtonSize.small:
        height = 36.0;
        defaultPadding = const EdgeInsets.symmetric(horizontal: AppSpacing.s10);
        textStyle = AppTypography.pill(color: textColor);
        break;
      case AliButtonSize.medium:
        height = 46.0;
        defaultPadding = const EdgeInsets.symmetric(horizontal: AppSpacing.s16);
        textStyle = AppTypography.button(color: textColor);
        break;
      case AliButtonSize.large:
        height = 54.0;
        defaultPadding = const EdgeInsets.symmetric(horizontal: AppSpacing.s20);
        textStyle = AppTypography.button(color: textColor);
        break;
    }

    final effectivePadding = widget.padding ?? defaultPadding;

    Widget content = IconTheme(
      data: IconThemeData(color: textColor),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.isLoading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
            ] else if (widget.prefixIcon != null) ...[
              _buildIcon(widget.prefixIcon!, textColor),
              const SizedBox(width: AppSpacing.s8),
            ],
            Text(
              widget.label,
              style: textStyle,
              maxLines: 1,
              softWrap: false,
            ),
            if (widget.suffixIcon != null && !widget.isLoading) ...[
              const SizedBox(width: AppSpacing.s8),
              _buildIcon(widget.suffixIcon!, textColor),
            ],
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          height: height,
          width: widget.isFullWidth ? double.infinity : null,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: widget.onPressed == null ? AppColors.surfaceMuted : backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: border,
            boxShadow: widget.onPressed == null ? null : shadow,
          ),
          child: content,
        ),
      ),
    );
  }
}
