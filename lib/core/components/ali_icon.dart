import 'package:flutter/material.dart';
import '../theme/app_theme_tokens.dart';

/// Standardized Icon Component using Iconsax
class AliIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const AliIcon(
    this.icon, {
    super.key,
    this.size = 22.0,
    this.color,
  });

  factory AliIcon.small(IconData icon, {Key? key, Color? color}) =>
      AliIcon(icon, key: key, size: 16.0, color: color);

  factory AliIcon.medium(IconData icon, {Key? key, Color? color}) =>
      AliIcon(icon, key: key, size: 22.0, color: color);

  factory AliIcon.large(IconData icon, {Key? key, Color? color}) =>
      AliIcon(icon, key: key, size: 28.0, color: color);

  factory AliIcon.display(IconData icon, {Key? key, Color? color}) =>
      AliIcon(icon, key: key, size: 36.0, color: color);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color ?? IconTheme.of(context).color ?? AppColors.textPrimary,
    );
  }
}
