import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_tokens.dart';

class StrokePoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  const StrokePoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });
}

class DrawingStroke {
  final int pointerId;
  final List<StrokePoint> points;
  final Color color;
  final double strokeWidth;
  Path? cachedPath;

  DrawingStroke({
    required this.pointerId,
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.cachedPath,
  });
}

/// Normalized reference strokes (0.0 to 1.0 coordinate space)
class NormalizedStroke {
  final List<Offset> points;
  const NormalizedStroke(this.points);
}

class WritingPathData {
  /// Predefined reference paths for single characters (0.0 to 1.0 bounding box)
  static final Map<String, List<NormalizedStroke>> characterStrokes = {
    // Numbers (standardized uniform cap-height and baseline)
    '0': [
      const NormalizedStroke([
        Offset(0.50, 0.08), Offset(0.32, 0.12), Offset(0.20, 0.32),
        Offset(0.18, 0.50), Offset(0.20, 0.68), Offset(0.32, 0.88),
        Offset(0.50, 0.92), Offset(0.68, 0.88), Offset(0.80, 0.68),
        Offset(0.82, 0.50), Offset(0.80, 0.32), Offset(0.68, 0.12),
        Offset(0.50, 0.08),
      ])
    ],
    '1': [
      const NormalizedStroke([
        Offset(0.36, 0.24), Offset(0.50, 0.08), Offset(0.50, 0.92),
      ]),
      const NormalizedStroke([
        Offset(0.38, 0.92), Offset(0.62, 0.92),
      ]),
    ],
    '2': [
      const NormalizedStroke([
        Offset(0.24, 0.28), Offset(0.34, 0.12), Offset(0.50, 0.08),
        Offset(0.66, 0.12), Offset(0.76, 0.26), Offset(0.74, 0.40),
        Offset(0.58, 0.56), Offset(0.24, 0.92), Offset(0.76, 0.92),
      ]),
    ],
    '3': [
      const NormalizedStroke([
        Offset(0.24, 0.10), Offset(0.76, 0.10), Offset(0.48, 0.46),
        Offset(0.64, 0.48), Offset(0.76, 0.60), Offset(0.78, 0.74),
        Offset(0.68, 0.86), Offset(0.50, 0.92), Offset(0.28, 0.88),
        Offset(0.20, 0.80),
      ]),
    ],
    '4': [
      const NormalizedStroke([
        Offset(0.68, 0.08), Offset(0.20, 0.66), Offset(0.80, 0.66),
      ]),
      const NormalizedStroke([
        Offset(0.68, 0.38), Offset(0.68, 0.92),
      ]),
    ],
    '5': [
      const NormalizedStroke([
        Offset(0.74, 0.10), Offset(0.30, 0.10), Offset(0.28, 0.46),
        Offset(0.54, 0.44), Offset(0.74, 0.54), Offset(0.76, 0.68),
        Offset(0.68, 0.84), Offset(0.50, 0.92), Offset(0.28, 0.88),
        Offset(0.22, 0.80),
      ]),
    ],
    '6': [
      const NormalizedStroke([
        Offset(0.70, 0.12), Offset(0.48, 0.08), Offset(0.28, 0.28),
        Offset(0.20, 0.54), Offset(0.20, 0.74), Offset(0.32, 0.88),
        Offset(0.52, 0.92), Offset(0.74, 0.86), Offset(0.78, 0.72),
        Offset(0.74, 0.56), Offset(0.56, 0.50), Offset(0.34, 0.54),
        Offset(0.22, 0.66),
      ]),
    ],
    '7': [
      const NormalizedStroke([
        Offset(0.24, 0.10), Offset(0.78, 0.10), Offset(0.40, 0.92),
      ]),
    ],
    '8': [
      const NormalizedStroke([
        Offset(0.50, 0.50), Offset(0.34, 0.38), Offset(0.32, 0.24),
        Offset(0.38, 0.12), Offset(0.50, 0.08), Offset(0.62, 0.12),
        Offset(0.68, 0.24), Offset(0.66, 0.38), Offset(0.50, 0.50),
        Offset(0.34, 0.62), Offset(0.26, 0.76), Offset(0.34, 0.88),
        Offset(0.50, 0.92), Offset(0.66, 0.88), Offset(0.74, 0.76),
        Offset(0.66, 0.62), Offset(0.50, 0.50),
      ]),
    ],
    '9': [
      const NormalizedStroke([
        Offset(0.76, 0.36), Offset(0.64, 0.48), Offset(0.46, 0.50),
        Offset(0.28, 0.44), Offset(0.24, 0.28), Offset(0.30, 0.14),
        Offset(0.48, 0.08), Offset(0.68, 0.12), Offset(0.78, 0.26),
        Offset(0.78, 0.56), Offset(0.70, 0.76), Offset(0.54, 0.92),
        Offset(0.34, 0.92),
      ]),
    ],

    // Uppercase A-Z (calibrated precisely to font midline spine)
    'A': [
      const NormalizedStroke([Offset(0.50, 0.04), Offset(0.12, 0.96)]),
      const NormalizedStroke([Offset(0.50, 0.04), Offset(0.88, 0.96)]),
      const NormalizedStroke([Offset(0.26, 0.62), Offset(0.74, 0.62)]),
    ],
    'B': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([
        Offset(0.24, 0.06), Offset(0.58, 0.06), Offset(0.74, 0.16),
        Offset(0.76, 0.32), Offset(0.68, 0.46), Offset(0.24, 0.48),
      ]),
      const NormalizedStroke([
        Offset(0.24, 0.48), Offset(0.62, 0.48), Offset(0.78, 0.60),
        Offset(0.80, 0.78), Offset(0.68, 0.94), Offset(0.24, 0.94),
      ]),
    ],
    'C': [
      const NormalizedStroke([
        Offset(0.80, 0.22), Offset(0.68, 0.08), Offset(0.50, 0.04),
        Offset(0.32, 0.08), Offset(0.20, 0.28), Offset(0.18, 0.50),
        Offset(0.20, 0.72), Offset(0.32, 0.92), Offset(0.50, 0.96),
        Offset(0.68, 0.92), Offset(0.80, 0.78),
      ])
    ],
    'D': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([
        Offset(0.24, 0.06), Offset(0.54, 0.06), Offset(0.74, 0.22),
        Offset(0.80, 0.50), Offset(0.74, 0.78), Offset(0.54, 0.94),
        Offset(0.24, 0.94),
      ]),
    ],
    'E': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([Offset(0.24, 0.06), Offset(0.78, 0.06)]),
      const NormalizedStroke([Offset(0.24, 0.50), Offset(0.68, 0.50)]),
      const NormalizedStroke([Offset(0.24, 0.94), Offset(0.78, 0.94)]),
    ],
    'F': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([Offset(0.24, 0.06), Offset(0.78, 0.06)]),
      const NormalizedStroke([Offset(0.24, 0.50), Offset(0.68, 0.50)]),
    ],
    'G': [
      const NormalizedStroke([
        Offset(0.80, 0.22), Offset(0.68, 0.08), Offset(0.50, 0.04),
        Offset(0.32, 0.08), Offset(0.20, 0.28), Offset(0.18, 0.50),
        Offset(0.20, 0.72), Offset(0.32, 0.92), Offset(0.50, 0.96),
        Offset(0.72, 0.90), Offset(0.80, 0.74), Offset(0.80, 0.52),
        Offset(0.54, 0.52),
      ])
    ],
    'H': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([Offset(0.76, 0.04), Offset(0.76, 0.96)]),
      const NormalizedStroke([Offset(0.24, 0.50), Offset(0.76, 0.50)]),
    ],
    'I': [
      const NormalizedStroke([Offset(0.50, 0.04), Offset(0.50, 0.96)]),
      const NormalizedStroke([Offset(0.26, 0.06), Offset(0.74, 0.06)]),
      const NormalizedStroke([Offset(0.26, 0.94), Offset(0.74, 0.94)]),
    ],
    'J': [
      const NormalizedStroke([Offset(0.30, 0.06), Offset(0.74, 0.06)]),
      const NormalizedStroke([
        Offset(0.62, 0.06), Offset(0.62, 0.74), Offset(0.56, 0.88),
        Offset(0.42, 0.96), Offset(0.28, 0.90), Offset(0.22, 0.76),
      ]),
    ],
    'K': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([Offset(0.76, 0.06), Offset(0.24, 0.54)]),
      const NormalizedStroke([Offset(0.36, 0.44), Offset(0.80, 0.96)]),
    ],
    'L': [
      const NormalizedStroke([
        Offset(0.24, 0.04), Offset(0.24, 0.94), Offset(0.76, 0.94)
      ]),
    ],
    'M': [
      const NormalizedStroke([
        Offset(0.18, 0.96), Offset(0.18, 0.04), Offset(0.50, 0.62),
        Offset(0.82, 0.04), Offset(0.82, 0.96),
      ]),
    ],
    'N': [
      const NormalizedStroke([
        Offset(0.22, 0.96), Offset(0.22, 0.04), Offset(0.78, 0.96), Offset(0.78, 0.04),
      ]),
    ],
    'O': [
      const NormalizedStroke([
        Offset(0.50, 0.04), Offset(0.32, 0.08), Offset(0.20, 0.28),
        Offset(0.18, 0.50), Offset(0.20, 0.72), Offset(0.32, 0.92),
        Offset(0.50, 0.96), Offset(0.68, 0.92), Offset(0.80, 0.72),
        Offset(0.82, 0.50), Offset(0.80, 0.28), Offset(0.68, 0.08),
        Offset(0.50, 0.04),
      ])
    ],
    'P': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([
        Offset(0.24, 0.06), Offset(0.58, 0.06), Offset(0.76, 0.18),
        Offset(0.78, 0.36), Offset(0.68, 0.52), Offset(0.24, 0.52),
      ]),
    ],
    'Q': [
      const NormalizedStroke([
        Offset(0.50, 0.04), Offset(0.32, 0.08), Offset(0.20, 0.28),
        Offset(0.18, 0.50), Offset(0.20, 0.72), Offset(0.32, 0.92),
        Offset(0.50, 0.96), Offset(0.68, 0.92), Offset(0.80, 0.72),
        Offset(0.82, 0.50), Offset(0.80, 0.28), Offset(0.68, 0.08),
        Offset(0.50, 0.04),
      ]),
      const NormalizedStroke([Offset(0.54, 0.66), Offset(0.84, 0.96)]),
    ],
    'R': [
      const NormalizedStroke([Offset(0.24, 0.04), Offset(0.24, 0.96)]),
      const NormalizedStroke([
        Offset(0.24, 0.06), Offset(0.58, 0.06), Offset(0.76, 0.18),
        Offset(0.78, 0.36), Offset(0.68, 0.52), Offset(0.24, 0.52),
      ]),
      const NormalizedStroke([Offset(0.52, 0.52), Offset(0.80, 0.96)]),
    ],
    'S': [
      const NormalizedStroke([
        Offset(0.76, 0.20), Offset(0.66, 0.08), Offset(0.48, 0.04),
        Offset(0.32, 0.10), Offset(0.24, 0.24), Offset(0.30, 0.38),
        Offset(0.50, 0.48), Offset(0.70, 0.58), Offset(0.78, 0.72),
        Offset(0.74, 0.86), Offset(0.52, 0.96), Offset(0.30, 0.92),
        Offset(0.22, 0.80),
      ])
    ],
    'T': [
      const NormalizedStroke([Offset(0.18, 0.06), Offset(0.82, 0.06)]),
      const NormalizedStroke([Offset(0.50, 0.06), Offset(0.50, 0.96)]),
    ],
    'U': [
      const NormalizedStroke([
        Offset(0.24, 0.04), Offset(0.24, 0.70), Offset(0.30, 0.88),
        Offset(0.50, 0.96), Offset(0.70, 0.88), Offset(0.76, 0.70),
        Offset(0.76, 0.04),
      ])
    ],
    'V': [
      const NormalizedStroke([Offset(0.18, 0.04), Offset(0.50, 0.96), Offset(0.82, 0.04)])
    ],
    'W': [
      const NormalizedStroke([
        Offset(0.14, 0.04), Offset(0.32, 0.96), Offset(0.50, 0.42),
        Offset(0.68, 0.96), Offset(0.86, 0.04),
      ])
    ],
    'X': [
      const NormalizedStroke([Offset(0.22, 0.06), Offset(0.78, 0.94)]),
      const NormalizedStroke([Offset(0.78, 0.06), Offset(0.22, 0.94)]),
    ],
    'Y': [
      const NormalizedStroke([Offset(0.18, 0.06), Offset(0.50, 0.52)]),
      const NormalizedStroke([Offset(0.82, 0.06), Offset(0.50, 0.52), Offset(0.50, 0.96)]),
    ],
    'Z': [
      const NormalizedStroke([
        Offset(0.22, 0.06), Offset(0.78, 0.06), Offset(0.22, 0.94), Offset(0.78, 0.94),
      ])
    ],

    // Lowercase a-z (Proper lower-case proportions: mid-line 0.45 to baseline 0.85, ascenders to 0.15, descenders to 1.0)
    'a': [
      const NormalizedStroke([
        Offset(0.68, 0.5), Offset(0.4, 0.45), Offset(0.3, 0.65),
        Offset(0.4, 0.85), Offset(0.68, 0.85)
      ]),
      const NormalizedStroke([
        Offset(0.68, 0.45), Offset(0.68, 0.85)
      ]),
    ],
    'b': [
      const NormalizedStroke([Offset(0.32, 0.15), Offset(0.32, 0.85)]),
      const NormalizedStroke([
        Offset(0.32, 0.5), Offset(0.65, 0.5), Offset(0.72, 0.68),
        Offset(0.65, 0.85), Offset(0.32, 0.85)
      ]),
    ],
    'c': [
      const NormalizedStroke([
        Offset(0.7, 0.52), Offset(0.45, 0.45), Offset(0.32, 0.65),
        Offset(0.45, 0.85), Offset(0.7, 0.78)
      ])
    ],
    'd': [
      const NormalizedStroke([
        Offset(0.68, 0.5), Offset(0.35, 0.5), Offset(0.28, 0.68),
        Offset(0.35, 0.85), Offset(0.68, 0.85)
      ]),
      const NormalizedStroke([Offset(0.68, 0.15), Offset(0.68, 0.85)]),
    ],
    'e': [
      const NormalizedStroke([
        Offset(0.32, 0.65), Offset(0.68, 0.65), Offset(0.65, 0.48),
        Offset(0.45, 0.45), Offset(0.32, 0.65), Offset(0.45, 0.85), Offset(0.68, 0.8)
      ])
    ],
    'f': [
      const NormalizedStroke([
        Offset(0.65, 0.2), Offset(0.5, 0.15), Offset(0.42, 0.28), Offset(0.42, 0.85)
      ]),
      const NormalizedStroke([Offset(0.28, 0.45), Offset(0.6, 0.45)]),
    ],
    'g': [
      const NormalizedStroke([
        Offset(0.68, 0.5), Offset(0.38, 0.48), Offset(0.3, 0.65),
        Offset(0.38, 0.82), Offset(0.68, 0.82)
      ]),
      const NormalizedStroke([
        Offset(0.68, 0.48), Offset(0.68, 0.95), Offset(0.5, 1.05), Offset(0.32, 0.98)
      ]),
    ],
    'h': [
      const NormalizedStroke([Offset(0.32, 0.15), Offset(0.32, 0.85)]),
      const NormalizedStroke([
        Offset(0.32, 0.55), Offset(0.55, 0.48), Offset(0.68, 0.6), Offset(0.68, 0.85)
      ]),
    ],
    'i': [
      const NormalizedStroke([Offset(0.5, 0.48), Offset(0.5, 0.85)]),
      const NormalizedStroke([Offset(0.5, 0.28), Offset(0.5, 0.32)]),
    ],
    'j': [
      const NormalizedStroke([
        Offset(0.58, 0.48), Offset(0.58, 0.95), Offset(0.42, 1.05), Offset(0.28, 0.98)
      ]),
      const NormalizedStroke([Offset(0.58, 0.28), Offset(0.58, 0.32)]),
    ],
    'k': [
      const NormalizedStroke([Offset(0.35, 0.15), Offset(0.35, 0.85)]),
      const NormalizedStroke([Offset(0.65, 0.48), Offset(0.38, 0.65)]),
      const NormalizedStroke([Offset(0.42, 0.63), Offset(0.68, 0.85)]),
    ],
    'l': [
      const NormalizedStroke([Offset(0.5, 0.15), Offset(0.5, 0.85)])
    ],
    'm': [
      const NormalizedStroke([Offset(0.2, 0.48), Offset(0.2, 0.85)]),
      const NormalizedStroke([
        Offset(0.2, 0.55), Offset(0.38, 0.48), Offset(0.5, 0.58), Offset(0.5, 0.85)
      ]),
      const NormalizedStroke([
        Offset(0.5, 0.55), Offset(0.68, 0.48), Offset(0.8, 0.58), Offset(0.8, 0.85)
      ]),
    ],
    'n': [
      const NormalizedStroke([Offset(0.32, 0.48), Offset(0.32, 0.85)]),
      const NormalizedStroke([
        Offset(0.32, 0.58), Offset(0.55, 0.48), Offset(0.68, 0.6), Offset(0.68, 0.85)
      ]),
    ],
    'o': [
      const NormalizedStroke([
        Offset(0.5, 0.45), Offset(0.32, 0.55), Offset(0.3, 0.7),
        Offset(0.45, 0.85), Offset(0.68, 0.8), Offset(0.7, 0.6), Offset(0.5, 0.45)
      ])
    ],
    'p': [
      const NormalizedStroke([Offset(0.32, 0.48), Offset(0.32, 1.05)]),
      const NormalizedStroke([
        Offset(0.32, 0.52), Offset(0.65, 0.48), Offset(0.72, 0.65),
        Offset(0.65, 0.82), Offset(0.32, 0.82)
      ]),
    ],
    'q': [
      const NormalizedStroke([
        Offset(0.68, 0.52), Offset(0.35, 0.48), Offset(0.28, 0.65),
        Offset(0.35, 0.82), Offset(0.68, 0.82)
      ]),
      const NormalizedStroke([
        Offset(0.68, 0.48), Offset(0.68, 1.05), Offset(0.78, 0.98)
      ]),
    ],
    'r': [
      const NormalizedStroke([Offset(0.35, 0.48), Offset(0.35, 0.85)]),
      const NormalizedStroke([
        Offset(0.35, 0.6), Offset(0.52, 0.48), Offset(0.68, 0.52)
      ]),
    ],
    's': [
      const NormalizedStroke([
        Offset(0.65, 0.52), Offset(0.5, 0.45), Offset(0.35, 0.55),
        Offset(0.5, 0.65), Offset(0.68, 0.75), Offset(0.5, 0.85), Offset(0.32, 0.8)
      ])
    ],
    't': [
      const NormalizedStroke([
        Offset(0.48, 0.22), Offset(0.48, 0.8), Offset(0.6, 0.85)
      ]),
      const NormalizedStroke([Offset(0.32, 0.45), Offset(0.65, 0.45)]),
    ],
    'u': [
      const NormalizedStroke([
        Offset(0.32, 0.48), Offset(0.32, 0.78), Offset(0.48, 0.85),
        Offset(0.68, 0.78), Offset(0.68, 0.48)
      ]),
      const NormalizedStroke([Offset(0.68, 0.65), Offset(0.68, 0.85)]),
    ],
    'v': [
      const NormalizedStroke([
        Offset(0.28, 0.48), Offset(0.5, 0.85), Offset(0.72, 0.48)
      ])
    ],
    'w': [
      const NormalizedStroke([
        Offset(0.2, 0.48), Offset(0.35, 0.85), Offset(0.5, 0.6),
        Offset(0.65, 0.85), Offset(0.8, 0.48)
      ])
    ],
    'x': [
      const NormalizedStroke([Offset(0.32, 0.48), Offset(0.68, 0.85)]),
      const NormalizedStroke([Offset(0.68, 0.48), Offset(0.32, 0.85)]),
    ],
    'y': [
      const NormalizedStroke([Offset(0.3, 0.48), Offset(0.5, 0.75)]),
      const NormalizedStroke([Offset(0.7, 0.48), Offset(0.35, 1.05)]),
    ],
    'z': [
      const NormalizedStroke([
        Offset(0.32, 0.48), Offset(0.68, 0.48), Offset(0.32, 0.85), Offset(0.68, 0.85)
      ])
    ],

    // =========================================================================
    // Huruf Hijaiyah (Alif - Ya) Standar Kaidah Khath Naskhi Murni (Arah & Urutan RTL Resmi)
    // =========================================================================
    // Alif: 1 goresan tegak lurus dari atas ke bawah
    'ا': [
      const NormalizedStroke([
        Offset(0.50, 0.08), Offset(0.50, 0.92),
      ]),
    ],
    // Ba: Perahu Naskhi lebar (kanan ke kiri mendatar) + titik di bawah
    'ب': [
      const NormalizedStroke([
        Offset(0.93, 0.20), Offset(0.86, 0.40), Offset(0.54, 0.56),
        Offset(0.20, 0.44), Offset(0.15, 0.20),
      ]),
      const NormalizedStroke([
        Offset(0.468, 0.831), Offset(0.468, 0.831),
      ]),
    ],
    // Ta: Perahu Naskhi lebar + 2 titik di atas
    'ت': [
      const NormalizedStroke([
        Offset(0.93, 0.33), Offset(0.86, 0.53), Offset(0.54, 0.69),
        Offset(0.20, 0.57), Offset(0.15, 0.33),
      ]),
      const NormalizedStroke([
        Offset(0.406, 0.304), Offset(0.406, 0.304),
      ]),
      const NormalizedStroke([
        Offset(0.615, 0.285), Offset(0.615, 0.285),
      ]),
    ],
    // Tsa: Perahu Naskhi lebar + 3 titik segitiga di atas
    'ث': [
      const NormalizedStroke([
        Offset(0.93, 0.41), Offset(0.86, 0.61), Offset(0.54, 0.77),
        Offset(0.20, 0.65), Offset(0.15, 0.41),
      ]),
      const NormalizedStroke([
        Offset(0.410, 0.356), Offset(0.410, 0.356),
      ]),
      const NormalizedStroke([
        Offset(0.619, 0.337), Offset(0.619, 0.337),
      ]),
      const NormalizedStroke([
        Offset(0.511, 0.210), Offset(0.511, 0.210),
      ]),
    ],
    // Jim: Kaidah Khath (tepat di sumbu tengah kaligrafi SVG)
    'ج': [
      const NormalizedStroke([
        Offset(0.25, 0.28), Offset(0.48, 0.21), Offset(0.72, 0.18),
      ]),
      const NormalizedStroke([
        Offset(0.72, 0.18), Offset(0.52, 0.27), Offset(0.36, 0.41),
        Offset(0.29, 0.56), Offset(0.34, 0.70), Offset(0.47, 0.79),
        Offset(0.62, 0.77), Offset(0.72, 0.68),
      ]),
      const NormalizedStroke([
        Offset(0.52, 0.52), Offset(0.52, 0.52),
      ]),
    ],
    // Ha: Sama seperti Jim tanpa titik
    'ح': [
      const NormalizedStroke([
        Offset(0.22, 0.18), Offset(0.50, 0.10), Offset(0.78, 0.10),
      ]),
      const NormalizedStroke([
        Offset(0.78, 0.10), Offset(0.52, 0.25), Offset(0.36, 0.41),
        Offset(0.28, 0.58), Offset(0.34, 0.78), Offset(0.52, 0.88),
        Offset(0.74, 0.78),
      ]),
    ],
    // Kha: Alis + perut + titik di atas alis (tepat di sumbu tengah kaligrafi SVG)
    'خ': [
      const NormalizedStroke([
        Offset(0.25, 0.40), Offset(0.48, 0.33), Offset(0.72, 0.30),
      ]),
      const NormalizedStroke([
        Offset(0.72, 0.30), Offset(0.52, 0.39), Offset(0.36, 0.53),
        Offset(0.29, 0.68), Offset(0.34, 0.82), Offset(0.47, 0.91),
        Offset(0.62, 0.89), Offset(0.72, 0.80),
      ]),
      const NormalizedStroke([
        Offset(0.516, 0.076), Offset(0.516, 0.076),
      ]),
    ],
    // Dal: 1 goresan dari kanan atas melengkung ke kiri bawah mendatar (tepat di sumbu SVG)
    'د': [
      const NormalizedStroke([
        Offset(0.56, 0.10), Offset(0.76, 0.30), Offset(0.80, 0.65),
        Offset(0.68, 0.86), Offset(0.40, 0.88), Offset(0.18, 0.86),
      ]),
    ],
    // Dzal: Dal + 1 titik di atas (tepat di sumbu SVG)
    'ذ': [
      const NormalizedStroke([
        Offset(0.55, 0.28), Offset(0.70, 0.48), Offset(0.72, 0.76),
        Offset(0.60, 0.89), Offset(0.38, 0.89), Offset(0.24, 0.87),
      ]),
      const NormalizedStroke([
        Offset(0.40, 0.14), Offset(0.40, 0.14),
      ]),
    ],
    // Ra: 1 goresan sabit luwes (tepat di sumbu SVG)
    'ر': [
      const NormalizedStroke([
        Offset(0.75, 0.08), Offset(0.80, 0.40), Offset(0.70, 0.70),
        Offset(0.46, 0.88), Offset(0.14, 0.95),
      ]),
    ],
    // Zai: Ra + 1 titik di atas (tepat di sumbu SVG)
    'ز': [
      const NormalizedStroke([
        Offset(0.71, 0.25), Offset(0.75, 0.52), Offset(0.66, 0.78),
        Offset(0.44, 0.91), Offset(0.20, 0.95),
      ]),
      const NormalizedStroke([
        Offset(0.58, 0.08), Offset(0.58, 0.08),
      ]),
    ],
    // Sin: 
    // Goresan 1: Tiga gigi dari kanan ke kiri
    // Goresan 2: Mangkok kurva besar dari kanan turun ke bawah lalu naik ke kiri
    'س': [
      const NormalizedStroke([
        Offset(0.94, 0.26), Offset(0.88, 0.42), Offset(0.78, 0.34),
        Offset(0.72, 0.43), Offset(0.58, 0.33), Offset(0.52, 0.43),
      ]),
      const NormalizedStroke([
        Offset(0.52, 0.43), Offset(0.50, 0.65), Offset(0.38, 0.76),
        Offset(0.20, 0.68), Offset(0.22, 0.28),
      ]),
    ],
    // Syin: Sin + 3 titik piramida di atas gigi
    'ش': [
      const NormalizedStroke([
        Offset(0.94, 0.40), Offset(0.88, 0.54), Offset(0.78, 0.45),
        Offset(0.72, 0.56), Offset(0.58, 0.45), Offset(0.52, 0.56),
      ]),
      const NormalizedStroke([
        Offset(0.52, 0.56), Offset(0.50, 0.76), Offset(0.38, 0.88),
        Offset(0.20, 0.80), Offset(0.22, 0.38),
      ]),
      const NormalizedStroke([
        Offset(0.63, 0.30), Offset(0.63, 0.30),
      ]),
      const NormalizedStroke([
        Offset(0.81, 0.25), Offset(0.81, 0.25),
      ]),
      const NormalizedStroke([
        Offset(0.69, 0.14), Offset(0.69, 0.14),
      ]),
    ],
    // Shad: 
    // Goresan 1: Loop lonjong kepala
    // Goresan 2: Mangkok besar dari kanan turun ke bawah lalu naik ke kiri
    'ص': [
      const NormalizedStroke([
        Offset(0.56, 0.36), Offset(0.82, 0.18), Offset(0.94, 0.26),
        Offset(0.80, 0.48), Offset(0.48, 0.46),
      ]),
      const NormalizedStroke([
        Offset(0.48, 0.46), Offset(0.48, 0.68), Offset(0.32, 0.86),
        Offset(0.08, 0.72), Offset(0.14, 0.48),
      ]),
    ],
    // Dhad: Shad + titik di atas kepala
    'ض': [
      const NormalizedStroke([
        Offset(0.56, 0.42), Offset(0.82, 0.25), Offset(0.94, 0.32),
        Offset(0.80, 0.54), Offset(0.48, 0.53),
      ]),
      const NormalizedStroke([
        Offset(0.48, 0.53), Offset(0.48, 0.74), Offset(0.32, 0.92),
        Offset(0.08, 0.78), Offset(0.14, 0.54),
      ]),
      const NormalizedStroke([
        Offset(0.678, 0.108), Offset(0.678, 0.108),
      ]),
    ],
    // Tha:
    // Goresan 1: Loop lonjong dasar
    // Goresan 2: Tiang tegak dari atas ke bawah
    'ط': [
      const NormalizedStroke([
        Offset(0.36, 0.80), Offset(0.68, 0.58), Offset(0.84, 0.68),
        Offset(0.55, 0.86), Offset(0.15, 0.90),
      ]),
      const NormalizedStroke([
        Offset(0.38, 0.05), Offset(0.35, 0.50), Offset(0.34, 0.84),
      ]),
    ],
    // Zha: Tha + titik di atas kanan loop
    'ظ': [
      const NormalizedStroke([
        Offset(0.36, 0.80), Offset(0.68, 0.58), Offset(0.84, 0.68),
        Offset(0.55, 0.86), Offset(0.15, 0.90),
      ]),
      const NormalizedStroke([
        Offset(0.38, 0.05), Offset(0.35, 0.50), Offset(0.34, 0.84),
      ]),
      const NormalizedStroke([
        Offset(0.55, 0.34), Offset(0.55, 0.34),
      ]),
    ],
    // 'Ain:
    // Goresan 1: Alis sabit kepala kecil di kanan atas
    // Goresan 2: Perut melingkar setengah lingkaran besar
    'ع': [
      const NormalizedStroke([
        Offset(0.58, 0.06), Offset(0.38, 0.04), Offset(0.26, 0.18), Offset(0.54, 0.28),
      ]),
      const NormalizedStroke([
        Offset(0.54, 0.28), Offset(0.32, 0.52), Offset(0.36, 0.85),
        Offset(0.60, 0.92), Offset(0.76, 0.76),
      ]),
    ],
    // Ghain: 'Ain + titik di atas kepala
    'غ': [
      const NormalizedStroke([
        Offset(0.56, 0.22), Offset(0.38, 0.20), Offset(0.28, 0.34), Offset(0.52, 0.42),
      ]),
      const NormalizedStroke([
        Offset(0.52, 0.42), Offset(0.34, 0.62), Offset(0.38, 0.88),
        Offset(0.58, 0.93), Offset(0.72, 0.80),
      ]),
      const NormalizedStroke([
        Offset(0.477, 0.070), Offset(0.477, 0.070),
      ]),
    ],
    // Fa:
    // Goresan 1: Kepala melingkar utuh bersambung langsung turun ke leher dan badan perahu mendatar
    // Goresan 2: Titik di atas kepala
    'ف': [
      const NormalizedStroke([
        Offset(0.70, 0.46), Offset(0.76, 0.35), Offset(0.85, 0.40),
        Offset(0.82, 0.50), Offset(0.74, 0.52),
        Offset(0.70, 0.68), Offset(0.50, 0.74), Offset(0.26, 0.73), Offset(0.14, 0.54),
      ]),
      const NormalizedStroke([
        Offset(0.75, 0.14), Offset(0.75, 0.14),
      ]),
    ],
    // Qaf:
    // Goresan 1: Kepala melingkar utuh bersambung langsung turun ke mangkok bulat dalam
    // Goresan 2 & 3: 2 titik di atas kepala
    'ق': [
      const NormalizedStroke([
        Offset(0.68, 0.40), Offset(0.74, 0.30), Offset(0.83, 0.36),
        Offset(0.80, 0.46), Offset(0.72, 0.48),
        Offset(0.68, 0.68), Offset(0.48, 0.86), Offset(0.22, 0.76), Offset(0.16, 0.52),
      ]),
      const NormalizedStroke([
        Offset(0.66, 0.13), Offset(0.66, 0.13),
      ]),
      const NormalizedStroke([
        Offset(0.80, 0.15), Offset(0.80, 0.15),
      ]),
    ],
    // Kaf:
    // Goresan 1: Tiang tegak tinggi di kanan turun lalu mendatar ke kiri
    // Goresan 2: Tanda hamzah mini di tengah
    'ك': [
      const NormalizedStroke([
        Offset(0.78, 0.05), Offset(0.76, 0.55), Offset(0.74, 0.82),
        Offset(0.48, 0.88), Offset(0.18, 0.86),
      ]),
      const NormalizedStroke([
        Offset(0.55, 0.38), Offset(0.44, 0.46), Offset(0.54, 0.56), Offset(0.42, 0.66),
      ]),
    ],
    // Lam: 1 goresan tiang tinggi di kanan turun ke bawah garis lalu melengkung mangkok naik ke kiri
    'ل': [
      const NormalizedStroke([
        Offset(0.70, 0.05), Offset(0.72, 0.62), Offset(0.52, 0.90),
        Offset(0.32, 0.82), Offset(0.32, 0.60),
      ]),
    ],
    // Mim:
    // Goresan 1: Segitiga/lingkaran kepala di kanan atas
    // Goresan 2: Kaki lurus turun ke bawah
    'م': [
      const NormalizedStroke([
        Offset(0.46, 0.32), Offset(0.56, 0.20), Offset(0.68, 0.26),
        Offset(0.64, 0.38), Offset(0.44, 0.32),
      ]),
      const NormalizedStroke([
        Offset(0.44, 0.32), Offset(0.40, 0.55), Offset(0.38, 0.76), Offset(0.36, 0.94),
      ]),
    ],
    // Nun:
    // Goresan 1: Mangkok melingkar bulat
    // Goresan 2: 1 titik di tengah atas mangkok
    'ن': [
      const NormalizedStroke([
        Offset(0.88, 0.24), Offset(0.80, 0.65), Offset(0.48, 0.88),
        Offset(0.12, 0.60), Offset(0.18, 0.30),
      ]),
      const NormalizedStroke([
        Offset(0.527, 0.142), Offset(0.527, 0.142),
      ]),
    ],
    // Ha (simpul mata):
    // 1 goresan melingkar dari kanan atas turun membentuk simpul mata di dalam lalu keluar mendatar ke kiri
    'ه': [
      const NormalizedStroke([
        Offset(0.60, 0.16), Offset(0.78, 0.32), Offset(0.82, 0.54),
        Offset(0.74, 0.74), Offset(0.56, 0.68),
        Offset(0.48, 0.50), Offset(0.56, 0.38), Offset(0.66, 0.48), Offset(0.58, 0.68),
        Offset(0.42, 0.76), Offset(0.14, 0.76),
      ]),
    ],
    'هـ': [
      const NormalizedStroke([
        Offset(0.60, 0.16), Offset(0.78, 0.32), Offset(0.82, 0.54),
        Offset(0.74, 0.74), Offset(0.56, 0.68),
        Offset(0.48, 0.50), Offset(0.56, 0.38), Offset(0.66, 0.48), Offset(0.58, 0.68),
        Offset(0.42, 0.76), Offset(0.14, 0.76),
      ]),
    ],
    // Wawu:
    // Goresan 1: Kepala melingkar di kanan atas
    // Goresan 2: Ekor kurva sabit meluncur ke kiri bawah
    'و': [
      const NormalizedStroke([
        Offset(0.72, 0.08), Offset(0.88, 0.20), Offset(0.82, 0.42),
        Offset(0.60, 0.30), Offset(0.72, 0.08),
      ]),
      const NormalizedStroke([
        Offset(0.82, 0.42), Offset(0.65, 0.70), Offset(0.38, 0.88), Offset(0.10, 0.76),
      ]),
    ],
    // Ya:
    // Goresan 1: Kepala kurva bebek di kanan atas (leher S -> mangkok lebar melengkung ke atas di kiri)
    // Goresan 2 & 3: 2 titik di bawah
    'ي': [
      const NormalizedStroke([
        Offset(0.88, 0.06), Offset(0.65, 0.18), Offset(0.58, 0.32),
        Offset(0.74, 0.42), Offset(0.68, 0.58), Offset(0.40, 0.68),
        Offset(0.18, 0.50), Offset(0.24, 0.22),
      ]),
      const NormalizedStroke([
        Offset(0.63, 0.90), Offset(0.63, 0.90),
      ]),
      const NormalizedStroke([
        Offset(0.45, 0.92), Offset(0.45, 0.92),
      ]),
    ],
    // Lam Alif:
    // Goresan 1: Tiang kanan (Lam) melengkung silang ke bawah kiri lalu membentuk pangkuan dasar
    // Goresan 2: Tiang kiri (Alif) melengkung silang ke bawah kanan
    'لا': [
      const NormalizedStroke([
        Offset(0.70, 0.12), Offset(0.62, 0.32), Offset(0.52, 0.46),
        Offset(0.38, 0.64), Offset(0.28, 0.80), Offset(0.46, 0.84), Offset(0.66, 0.80),
      ]),
      const NormalizedStroke([
        Offset(0.30, 0.12), Offset(0.38, 0.32), Offset(0.48, 0.46),
        Offset(0.58, 0.64), Offset(0.66, 0.78),
      ]),
    ],
    // Hamzah:
    // Goresan 1: Kepala melengkung (alis kanan melengkung ke puncak lalu masuk ke leher)
    // Goresan 2: Sayap dan alas bawah (dari sayap kanan menyapu ke kiri bawah hingga ujung kaki)
    'ء': [
      const NormalizedStroke([
        Offset(0.68, 0.28), Offset(0.53, 0.27), Offset(0.37, 0.35), Offset(0.34, 0.45), Offset(0.43, 0.48),
      ]),
      const NormalizedStroke([
        Offset(0.75, 0.49), Offset(0.58, 0.53), Offset(0.45, 0.56), Offset(0.34, 0.72),
      ]),
    ],
  };

  /// Get reference strokes for a single character or multi-character string (e.g. 10 to 999)
  static List<NormalizedStroke> getStrokesForChar(String text) {
    if (text.isEmpty) return [];

    // Strip Arabic diacritics
    final cleanText = text.replaceAll(RegExp(r'[\u064B-\u065F]'), '');

    // Cek langsung kecocokan persis (termasuk ligatur multi-karakter seperti 'لا')
    if (characterStrokes.containsKey(cleanText)) {
      return characterStrokes[cleanText]!;
    }
    final upper = cleanText.toUpperCase();
    if (characterStrokes.containsKey(upper)) {
      return characterStrokes[upper]!;
    }

    // Jika berupa satu karakter yang tidak terdaftar
    if (cleanText.length == 1) {
      return [
        const NormalizedStroke([
          Offset(0.25, 0.15), Offset(0.75, 0.15),
          Offset(0.75, 0.85), Offset(0.25, 0.85), Offset(0.25, 0.15)
        ])
      ];
    }

    // Jika multi-karakter (misal angka '25', '100', '999')
    // Susun karakter berdampingan secara proporsional horizontal (0.0 s/d 1.0)
    final count = cleanText.length;
    final List<NormalizedStroke> combined = [];
    final double slotWidth = 1.0 / count;
    const double paddingX = 0.04;

    for (int i = 0; i < count; i++) {
      final ch = cleanText[i];
      final charStrokes = characterStrokes[ch] ?? characterStrokes[ch.toUpperCase()] ?? [];
      final double startX = i * slotWidth + paddingX;
      final double availableWidth = slotWidth - (2 * paddingX);

      for (final stroke in charStrokes) {
        final List<Offset> scaledPoints = stroke.points.map((pt) {
          final mappedX = startX + (pt.dx * availableWidth);
          final mappedY = pt.dy;
          return Offset(mappedX, mappedY);
        }).toList();
        combined.add(NormalizedStroke(scaledPoints));
      }
    }

    return combined.isNotEmpty ? combined : [
      const NormalizedStroke([
        Offset(0.25, 0.15), Offset(0.75, 0.15),
        Offset(0.75, 0.85), Offset(0.25, 0.85), Offset(0.25, 0.15)
      ])
    ];
  }

  /// Check coverage of user drawn strokes against reference checkpoints.
  /// Enforces that EVERY individual stroke/line in [refStrokes] has been drawn by the child.
  /// If any line of the pattern is missing (coverage < minStrokeCoverage), accuracy is capped low (<=0.35)
  /// so unfinished patterns will NEVER be marked as completed prematurely.
  static double calculateAccuracy({
    required List<DrawingStroke> userStrokes,
    required List<NormalizedStroke> refStrokes,
    required Size canvasSize,
    int charCount = 1,
    String? charLabel,
    double thresholdDistance = 90.0,
    double minStrokeCoverage = 0.20,
  }) {
    if (userStrokes.isEmpty || refStrokes.isEmpty) return 0.0;

    // Untuk huruf Hijaiyah / Arab: berikan toleransi tracing yang lebih bersahabat bagi anak
    final isArabic = charLabel != null && RegExp(r'[\u0600-\u06FF]').hasMatch(charLabel);
    final effectiveThreshold = isArabic ? 110.0 : thresholdDistance;
    final effectiveCoverage = isArabic ? 0.15 : minStrokeCoverage;

    // Collect all drawn points
    final drawnPoints = <Offset>[];
    for (final s in userStrokes) {
      for (final p in s.points) {
        drawnPoints.add(p.offset);
      }
    }
    if (drawnPoints.isEmpty) return 0.0;

    final fittedRect = getFittedRect(canvasSize: canvasSize, charCount: charCount, charLabel: charLabel);

    int totalCheckpoints = 0;
    int totalPassedCheckpoints = 0;
    bool allIndividualLinesDrawn = true;

    for (final stroke in refStrokes) {
      if (stroke.points.isEmpty) continue;

      final strokeCheckpoints = <Offset>[];
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = mapPointToCanvas(stroke.points[i], fittedRect);
        final p2 = mapPointToCanvas(stroke.points[i + 1], fittedRect);
        final segDist = (p2 - p1).distance;
        final steps = (segDist / 16.0).ceil().clamp(1, 25);
        for (int s = 0; s < steps; s++) {
          final t = s / steps;
          strokeCheckpoints.add(Offset.lerp(p1, p2, t)!);
        }
      }
      final lastPt = stroke.points.last;
      strokeCheckpoints.add(mapPointToCanvas(lastPt, fittedRect));

      if (strokeCheckpoints.isEmpty) continue;

      int passedInStroke = 0;
      for (final cp in strokeCheckpoints) {
        for (final dp in drawnPoints) {
          if ((dp - cp).distance <= effectiveThreshold) {
            passedInStroke++;
            break;
          }
        }
      }

      totalCheckpoints += strokeCheckpoints.length;
      totalPassedCheckpoints += passedInStroke;

      final strokeRatio = passedInStroke / strokeCheckpoints.length;
      if (strokeRatio < effectiveCoverage) {
        allIndividualLinesDrawn = false;
      }
    }

    if (totalCheckpoints == 0) return 1.0;

    // If any stroke/line of the pattern is still missing, cap accuracy below pass mark
    if (!allIndividualLinesDrawn) {
      final rawScore = totalPassedCheckpoints / totalCheckpoints;
      return rawScore.clamp(0.0, 0.35);
    }

    return (totalPassedCheckpoints / totalCheckpoints).clamp(0.0, 1.0);
  }

  /// Helper to verify if every single line in the pattern has been touched/drawn
  static bool areAllLinesDrawn({
    required List<DrawingStroke> userStrokes,
    required List<NormalizedStroke> refStrokes,
    required Size canvasSize,
    int charCount = 1,
    String? charLabel,
    double thresholdDistance = 90.0,
    double minStrokeCoverage = 0.20,
  }) {
    if (userStrokes.isEmpty || refStrokes.isEmpty) return false;
    final drawnPoints = <Offset>[];
    for (final s in userStrokes) {
      for (final p in s.points) {
        drawnPoints.add(p.offset);
      }
    }
    if (drawnPoints.isEmpty) return false;

    final isArabic = charLabel != null && RegExp(r'[\u0600-\u06FF]').hasMatch(charLabel);
    final effectiveThreshold = isArabic ? 110.0 : thresholdDistance;
    final effectiveCoverage = isArabic ? 0.15 : minStrokeCoverage;

    final fittedRect = getFittedRect(canvasSize: canvasSize, charCount: charCount, charLabel: charLabel);

    for (final stroke in refStrokes) {
      if (stroke.points.isEmpty) continue;

      final strokeCheckpoints = <Offset>[];
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = mapPointToCanvas(stroke.points[i], fittedRect);
        final p2 = mapPointToCanvas(stroke.points[i + 1], fittedRect);
        final segDist = (p2 - p1).distance;
        final steps = (segDist / 16.0).ceil().clamp(1, 25);
        for (int s = 0; s < steps; s++) {
          final t = s / steps;
          strokeCheckpoints.add(Offset.lerp(p1, p2, t)!);
        }
      }
      final lastPt = stroke.points.last;
      strokeCheckpoints.add(mapPointToCanvas(lastPt, fittedRect));

      if (strokeCheckpoints.isEmpty) continue;

      int passedInStroke = 0;
      for (final cp in strokeCheckpoints) {
        for (final dp in drawnPoints) {
          if ((dp - cp).distance <= effectiveThreshold) {
            passedInStroke++;
            break;
          }
        }
      }

      if ((passedInStroke / strokeCheckpoints.length) < effectiveCoverage) {
        return false;
      }
    }
    return true;
  }

  /// Hitung Rect proporsional agar ukuran setiap huruf/angka seragam & konsisten
  static Rect getFittedRect({
    required Size canvasSize,
    int charCount = 1,
    String? charLabel,
  }) {
    final count = (charLabel != null && charLabel.isNotEmpty) ? charLabel.length : charCount.clamp(1, 10);
    
    // Periksa apakah karakter merupakan huruf Hijaiyah/Arab
    final isArabic = charLabel != null && charLabel.isNotEmpty && RegExp(r'[\u0600-\u06FF]').hasMatch(charLabel);

    // Untuk Hijaiyah: huruf Arab memiliki proporsi harmonis (lebar ~1.15 x tinggi)
    final double targetH = isArabic 
        ? (canvasSize.height * 0.65).clamp(180.0, 420.0)
        : (canvasSize.height * 0.72).clamp(180.0, 500.0);
    final double charSlotW = isArabic ? targetH * 1.15 : targetH * 0.65;
    double drawW = charSlotW * count;
    double drawH = targetH;

    // Jika melebihi batas lebar canvas, skala secara proporsional
    final maxAllowedW = canvasSize.width * 0.88;
    if (drawW > maxAllowedW) {
      final scale = maxAllowedW / drawW;
      drawW *= scale;
      drawH *= scale;
    }

    final left = (canvasSize.width - drawW) / 2;
    final top = (canvasSize.height - drawH) / 2;
    return Rect.fromLTWH(left, top, drawW, drawH);
  }

  /// Map normalized point (0.0 to 1.0) to fitted proportional rect
  static Offset mapPointToCanvas(Offset normPt, Rect fittedRect) {
    return Offset(
      fittedRect.left + (normPt.dx * fittedRect.width),
      fittedRect.top + (normPt.dy * fittedRect.height),
    );
  }

  /// Bangun Path kurva halus (elastis, luwes, dan natural seperti tulisan tangan)
  /// Menggunakan Catmull-Rom spline centripetal sehingga transisi antar titik sangat mulus tanpa sudut kaku/patah.
  static Path buildSmoothPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    if (points.length == 1) {
      path.moveTo(points.first.dx, points.first.dy);
      return path;
    }
    if (points.length == 2) {
      path.moveTo(points[0].dx, points[0].dy);
      path.lineTo(points[1].dx, points[1].dy);
      return path;
    }

    path.moveTo(points.first.dx, points.first.dy);

    // Catmull-Rom to Cubic Bezier conversion untuk kurva yang lentur & elastis
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

      // Tegangan kurva 0.5 (natural & elastis)
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6.0,
        p1.dy + (p2.dy - p0.dy) / 6.0,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6.0,
        p2.dy - (p3.dy - p1.dy) / 6.0,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    return path;
  }
}
