import 'package:flutter/material.dart';

/// App Ali Unified Color Tokens (Zero Hardcode)
/// Combining:
/// - Layout & Shapes: `image copy.png` (High-Precision Card Deck, 4px Margin, Elegant Pills)
/// - Palette & Accents: `image copy 2.png` (Warm Ochre Ambient, Crisp Pure White Cards, Slate Soft Darks, Electric Lemon & Azure Focus)
class AppColors {
  // Background & Core Canvas
  static const Color bgCanvas = Color(0xFFF2ECE4);       // Warm sand-cream ambient from image copy 2
  static const Color bgCanvasDeep = Color(0xFFE8DFD3);   // Slightly deeper tone for headers
  static const Color bgLight = Color(0xFFF2ECE4);        // Alias for components
  static const Color surfaceCard = Color(0xFFFFFFFF);     // Pure Crisp White for Cards
  static const Color surfaceLight = Color(0xFFFFFFFF);    // Alias
  static const Color surfaceCardSubtle = Color(0xFFF8F9FA); // Inner card rows
  static const Color surfaceMuted = Color(0xFFEFE9E0);    // Inner subtle background
  static const Color surfacePill = Color(0xFFE4DDD2);     // Inactive Category / Filter Pill
  static const Color surfacePillDark = Color(0xFF1E242B); // Slate Pill (from image copy.png)
  static const Color surfaceInput = Color(0xFFF6F2EC);    // Text input surface background

  // Pure Constants
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF171B20);

  // Typography Hierarchy
  static const Color textPrimary = Color(0xFF171B20);     // Deep Charcoal Black (High legibility)
  static const Color textSecondary = Color(0xFF5F6975);   // Muted Body Slate
  static const Color textMuted = Color(0xFF8E99A8);       // Sub-labels & placeholders
  static const Color textOnDark = Color(0xFFFFFFFF);      // Crisp text on black pills/CTA

  // High-Energy Smart Accents (from image copy 2.png)
  static const Color accentLemon = Color(0xFFE2F952);     // Bright Electric Citron (from image copy.png & 2)
  static const Color accentLime = Color(0xFFE2F952);      // Alias
  static const Color accentBrand = Color(0xFF1E242B);     // Deep Slate
  static const Color accentYellow = Color(0xFFFFCC00);    // Warm Sunshine Yellow
  static const Color accentSky = Color(0xFF48A6F8);       // Vivid Azure Focus
  static const Color accentCoral = Color(0xFFFF5252);     // Delete / Caution
  static const Color accentGreen = Color(0xFF4ADE80);     // Success / Active Dot

  // High-Precision Card Borders & Subtle Outlines
  static const Color borderCard = Color(0xFFE5DECE);      // Crisp card contour
  static const Color borderSubtle = Color(0xFFECE5D8);    // Soft row divider
  static const Color borderDivider = Color(0xFFECE5D8);   // Divider
}

/// Spacing System with Strict 4.0 Margin to Screen & 4.0 Card Gap
class AppSpacing {
  static const double zero = 0.0;
  static const double s2 = 2.0;
  static const double s4 = 4.0;   // STRICT: 4px margin to screen edges & 4px card gap
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;

  // Semantic Presets
  static const double screenMargin = s4; // Exact 4px to right and left
  static const double cardGap = s4;      // Exact 4px between cards
  static const double mobileScreenMargin = s4;
  static const double mobileCardGap = s4;
}

/// Corner Radius Hierarchy (Continuous Squircle Feel ala image copy.png)
class AppRadius {
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;  // Standard Card Deck
  static const double r28 = 28.0;
  static const double r32 = 32.0;  // Large Section Card Deck
  static const double pill = 999.0; // Capsule Buttons, Tabs & Pills
}

/// Typography using Airbnb Cereal App
class AppTypography {
  static const String fontFamily = 'Airbnb Cereal App';

  static TextStyle _font({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Display Titles & Hero Headings
  static TextStyle displayLarge({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 32, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.7, height: 1.15);

  static TextStyle displayMedium({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 25, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5, height: 1.2);

  /// Onboarding & Section Hero Headline (Airbnb 28px ultra-bold)
  static TextStyle heroHeadline({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 28, fontWeight: FontWeight.w900, color: color, letterSpacing: -0.7, height: 1.25);

  /// Onboarding & Section Editorial Lead (Airbnb 15px balanced weight)
  static TextStyle heroSubtitle({Color color = AppColors.textSecondary}) =>
      _font(fontSize: 15, fontWeight: FontWeight.w500, color: color, height: 1.45);

  // Headings
  static TextStyle titleLarge({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 20, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.3, height: 1.25);

  static TextStyle titleMedium({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 17, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.2, height: 1.3);

  static TextStyle titleSmall({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 15, fontWeight: FontWeight.w600, color: color, letterSpacing: -0.1, height: 1.35);

  // Body Texts
  static TextStyle bodyLarge({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 16, fontWeight: FontWeight.w500, color: color, height: 1.4);

  static TextStyle bodyMedium({Color color = AppColors.textSecondary}) =>
      _font(fontSize: 14, fontWeight: FontWeight.w400, color: color, height: 1.4);

  static TextStyle bodySmall({Color color = AppColors.textMuted}) =>
      _font(fontSize: 12, fontWeight: FontWeight.w500, color: color, height: 1.3);

  // Micro Labels & Pills
  static TextStyle pill({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 14, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.0);

  static TextStyle button({Color color = AppColors.textOnDark}) =>
      _font(fontSize: 16, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.2);

  static TextStyle cardTitle({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 16, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.2);

  static TextStyle cardDescription({Color color = AppColors.textSecondary}) =>
      _font(fontSize: 13.5, fontWeight: FontWeight.w400, color: color, height: 1.4);

  static TextStyle cardLabel({Color color = AppColors.textPrimary}) =>
      _font(fontSize: 14, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.2);

  static TextStyle cardSub({Color color = AppColors.textSecondary}) =>
      _font(fontSize: 13, fontWeight: FontWeight.w500, color: color);
}

/// Elevation & Shadow Presets
class AppShadows {
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF1E242B).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> floatingDockShadow = [
    BoxShadow(
      color: const Color(0xFF1E242B).withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> buttonGlow(Color glowColor) => [
    BoxShadow(
      color: glowColor.withValues(alpha: 0.25),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}
