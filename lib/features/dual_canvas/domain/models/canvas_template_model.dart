import 'dart:ui';
import 'package:flutter/material.dart';

/// Segment instruksi pembentuk outline gambar
class TemplateSegment {
  /// Titik-titik dalam koordinat normalisasi (0.0 sampai 1.0)
  final List<Offset> points;

  /// Apakah garis ini loop tertutup
  final bool isClosed;

  /// Label bagian (misal: "Bodi", "Roda", "Jendela", "Daun")
  final String? partName;

  /// Path bawaan jika segment merupakan lingkaran, kurva, atau bentuk tertentu
  final Path Function(Size size)? customPathBuilder;

  const TemplateSegment({
    required this.points,
    this.isClosed = false,
    this.partName,
    this.customPathBuilder,
  });

  /// Mengonversi segment ke Path terukur sesuai ukuran kanvas
  Path toPath(Size size, {double padding = 24.0}) {
    if (customPathBuilder != null) {
      return customPathBuilder!(size);
    }

    final path = Path();
    if (points.isEmpty) return path;

    final availableW = size.width - (padding * 2);
    final availableH = size.height - (padding * 2);
    // Pertahankan rasio 1:1 di tengah kanvas
    final boxSize = availableW < availableH ? availableW : availableH;
    final startX = padding + (availableW - boxSize) / 2;
    final startY = padding + (availableH - boxSize) / 2;

    Offset scalePoint(Offset p) {
      return Offset(
        startX + (p.dx * boxSize),
        startY + (p.dy * boxSize),
      );
    }

    final first = scalePoint(points.first);
    path.moveTo(first.dx, first.dy);

    for (int i = 1; i < points.length; i++) {
      final p = scalePoint(points[i]);
      path.lineTo(p.dx, p.dy);
    }

    if (isClosed) {
      path.close();
    }

    return path;
  }
}

/// Model untuk Template Kerangka Mewarnai & Tracing
class CanvasTemplateModel {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'kendaraan', 'buah', 'benda', 'hewan'
  final String emoji;
  final List<TemplateSegment> segments;

  /// Custom painter function to draw smooth, beautiful kid coloring book outlines
  final void Function(Canvas canvas, Size size, {Paint? strokePaint, Paint? fillPaint})? painter;

  const CanvasTemplateModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.emoji,
    this.segments = const [],
    this.painter,
  });

  /// Paint template outline to canvas
  void paintOutline(Canvas canvas, Size size, {required Paint strokePaint, Paint? fillPaint}) {
    if (painter != null) {
      painter!(canvas, size, strokePaint: strokePaint, fillPaint: fillPaint);
      return;
    }

    for (final seg in segments) {
      final p = seg.toPath(size);
      if (fillPaint != null && seg.isClosed) {
        canvas.drawPath(p, fillPaint);
      }
      canvas.drawPath(p, strokePaint);
    }
  }
}
