import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/models/canvas_template_model.dart';

/// Koleksi Template Kerangka Pola Mewarnai & Tracing Anak Berkualitas Tinggi
/// Dirancang khusus dengan estetika buku gambar anak (bulat, proporsional, ramah sensori).
class CanvasTemplatesData {
  static const List<String> categories = ['hewan', 'kendaraan', 'buah', 'benda'];

  static String getCategoryLabel(String cat) {
    switch (cat) {
      case 'hewan':
        return '🐱 Hewan Lucu';
      case 'kendaraan':
        return '🚗 Kendaraan';
      case 'buah':
        return '🍎 Buah Manis';
      case 'benda':
        return '🧸 Benda Seru';
      default:
        return 'Koleksi';
    }
  }

  static List<CanvasTemplateModel> getByCategory(String cat) {
    return allTemplates.where((t) => t.category == cat).toList();
  }

  static final List<CanvasTemplateModel> allTemplates = [
    // =========================================================================
    // 🐱 1. KATEGORI HEWAN LUCU (8 Template Favorit Anak)
    // =========================================================================

    // 1. Kucing Lucu
    CanvasTemplateModel(
      id: 'hewan_kucing',
      title: 'Kucing Lucu',
      subtitle: 'Meong si anak kucing',
      category: 'hewan',
      emoji: '🐱',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Telinga Kiri
        final leftEar = Path()
          ..moveTo(cx - 70 * s, cy - 35 * s)
          ..quadraticBezierTo(cx - 95 * s, cy - 105 * s, cx - 65 * s, cy - 110 * s)
          ..quadraticBezierTo(cx - 40 * s, cy - 90 * s, cx - 25 * s, cy - 65 * s)
          ..close();
        canvas.drawPath(leftEar, f);
        canvas.drawPath(leftEar, p);

        // Telinga Kanan
        final rightEar = Path()
          ..moveTo(cx + 70 * s, cy - 35 * s)
          ..quadraticBezierTo(cx + 95 * s, cy - 105 * s, cx + 65 * s, cy - 110 * s)
          ..quadraticBezierTo(cx + 40 * s, cy - 90 * s, cx + 25 * s, cy - 65 * s)
          ..close();
        canvas.drawPath(rightEar, f);
        canvas.drawPath(rightEar, p);

        // Bodi & Kaki Depan
        final body = Path()
          ..moveTo(cx - 60 * s, cy + 45 * s)
          ..quadraticBezierTo(cx - 85 * s, cy + 115 * s, cx - 40 * s, cy + 120 * s)
          ..quadraticBezierTo(cx - 20 * s, cy + 120 * s, cx - 15 * s, cy + 65 * s)
          ..quadraticBezierTo(cx, cy + 68 * s, cx + 15 * s, cy + 65 * s)
          ..quadraticBezierTo(cx + 20 * s, cy + 120 * s, cx + 40 * s, cy + 120 * s)
          ..quadraticBezierTo(cx + 85 * s, cy + 115 * s, cx + 60 * s, cy + 45 * s)
          ..close();
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Kepala Bulat
        final headRect = Rect.fromCenter(center: Offset(cx, cy - 20 * s), width: 160 * s, height: 135 * s);
        canvas.drawOval(headRect, f);
        canvas.drawOval(headRect, p);

        // Mata Besar Berbinar
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 36 * s, cy - 30 * s), width: 24 * s, height: 28 * s), p);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 36 * s, cy - 30 * s), width: 24 * s, height: 28 * s), p);
        // Kilau mata
        canvas.drawCircle(Offset(cx - 40 * s, cy - 35 * s), 4 * s, Paint()..color = const Color(0xFF334155));
        canvas.drawCircle(Offset(cx + 32 * s, cy - 35 * s), 4 * s, Paint()..color = const Color(0xFF334155));

        // Hidung Segitiga Mungil
        final nose = Path()
          ..moveTo(cx - 8 * s, cy - 8 * s)
          ..lineTo(cx + 8 * s, cy - 8 * s)
          ..lineTo(cx, cy)
          ..close();
        canvas.drawPath(nose, Paint()..color = const Color(0xFF334155));

        // Mulut Senyum
        final mouth = Path()
          ..moveTo(cx - 18 * s, cy + 8 * s)
          ..quadraticBezierTo(cx - 9 * s, cy + 18 * s, cx, cy + 4 * s)
          ..quadraticBezierTo(cx + 9 * s, cy + 18 * s, cx + 18 * s, cy + 8 * s);
        canvas.drawPath(mouth, p);

        // Kumis Kucing (Kiri & Kanan)
        canvas.drawLine(Offset(cx - 45 * s, cy - 2 * s), Offset(cx - 85 * s, cy - 10 * s), p);
        canvas.drawLine(Offset(cx - 45 * s, cy + 8 * s), Offset(cx - 85 * s, cy + 14 * s), p);
        canvas.drawLine(Offset(cx + 45 * s, cy - 2 * s), Offset(cx + 85 * s, cy - 10 * s), p);
        canvas.drawLine(Offset(cx + 45 * s, cy + 8 * s), Offset(cx + 85 * s, cy + 14 * s), p);
      },
    ),

    // 2. Kelinci Telinga Panjang
    CanvasTemplateModel(
      id: 'hewan_kelinci',
      title: 'Kelinci',
      subtitle: 'Si lompat berbulu lembut',
      category: 'hewan',
      emoji: '🐰',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Telinga Kiri Panjang
        final earL = Path()
          ..moveTo(cx - 45 * s, cy - 40 * s)
          ..quadraticBezierTo(cx - 65 * s, cy - 130 * s, cx - 35 * s, cy - 135 * s)
          ..quadraticBezierTo(cx - 15 * s, cy - 120 * s, cx - 18 * s, cy - 45 * s)
          ..close();
        canvas.drawPath(earL, f);
        canvas.drawPath(earL, p);

        // Telinga Kanan Panjang
        final earR = Path()
          ..moveTo(cx + 45 * s, cy - 40 * s)
          ..quadraticBezierTo(cx + 65 * s, cy - 130 * s, cx + 35 * s, cy - 135 * s)
          ..quadraticBezierTo(cx + 15 * s, cy - 120 * s, cx + 18 * s, cy - 45 * s)
          ..close();
        canvas.drawPath(earR, f);
        canvas.drawPath(earR, p);

        // Bodi Kelinci
        final body = Path()
          ..moveTo(cx - 50 * s, cy + 30 * s)
          ..quadraticBezierTo(cx - 75 * s, cy + 110 * s, cx, cy + 120 * s)
          ..quadraticBezierTo(cx + 75 * s, cy + 110 * s, cx + 50 * s, cy + 30 * s)
          ..close();
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Kepala Kelinci Chubby
        final head = Rect.fromCenter(center: Offset(cx, cy - 10 * s), width: 145 * s, height: 125 * s);
        canvas.drawOval(head, f);
        canvas.drawOval(head, p);

        // Mata Kelinci
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 32 * s, cy - 20 * s), width: 18 * s, height: 24 * s), p);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 32 * s, cy - 20 * s), width: 18 * s, height: 24 * s), p);

        // Hidung & Mulut Y
        final nose = Rect.fromCenter(center: Offset(cx, cy + 5 * s), width: 14 * s, height: 10 * s);
        canvas.drawOval(nose, Paint()..color = const Color(0xFF334155));

        final mouth = Path()
          ..moveTo(cx, cy + 10 * s)
          ..lineTo(cx, cy + 20 * s)
          ..moveTo(cx - 15 * s, cy + 26 * s)
          ..quadraticBezierTo(cx - 8 * s, cy + 32 * s, cx, cy + 20 * s)
          ..quadraticBezierTo(cx + 8 * s, cy + 32 * s, cx + 15 * s, cy + 26 * s);
        canvas.drawPath(mouth, p);

        // Pipi Merona
        canvas.drawCircle(Offset(cx - 48 * s, cy), 10 * s, Paint()..color = const Color(0xFFFECDD3));
        canvas.drawCircle(Offset(cx + 48 * s, cy), 10 * s, Paint()..color = const Color(0xFFFECDD3));
      },
    ),

    // 3. Panda Menggemaskan
    CanvasTemplateModel(
      id: 'hewan_panda',
      title: 'Panda',
      subtitle: 'Si pemakan bambu',
      category: 'hewan',
      emoji: '🐼',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Telinga Hitam Kiri & Kanan
        canvas.drawCircle(Offset(cx - 65 * s, cy - 70 * s), 28 * s, Paint()..color = const Color(0xFF1E293B));
        canvas.drawCircle(Offset(cx + 65 * s, cy - 70 * s), 28 * s, Paint()..color = const Color(0xFF1E293B));

        // Bodi
        final body = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx, cy + 60 * s), width: 160 * s, height: 130 * s));
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Kepala Bulat
        final head = Rect.fromCenter(center: Offset(cx, cy - 10 * s), width: 170 * s, height: 140 * s);
        canvas.drawOval(head, f);
        canvas.drawOval(head, p);

        // Bercak Mata Panda Khas Hitam
        final leftPatch = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx - 38 * s, cy - 15 * s), width: 44 * s, height: 38 * s));
        canvas.drawPath(leftPatch, Paint()..color = const Color(0xFF1E293B));

        final rightPatch = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx + 38 * s, cy - 15 * s), width: 44 * s, height: 38 * s));
        canvas.drawPath(rightPatch, Paint()..color = const Color(0xFF1E293B));

        // Titik Mata Putih di Dalam Bercak
        canvas.drawCircle(Offset(cx - 35 * s, cy - 16 * s), 6 * s, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(cx + 35 * s, cy - 16 * s), 6 * s, Paint()..color = Colors.white);

        // Hidung Oval
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 16 * s), width: 22 * s, height: 14 * s), Paint()..color = const Color(0xFF1E293B));

        // Mulut Senyum
        final mouth = Path()
          ..moveTo(cx - 14 * s, cy + 30 * s)
          ..quadraticBezierTo(cx, cy + 38 * s, cx + 14 * s, cy + 30 * s);
        canvas.drawPath(mouth, p);
      },
    ),

    // 4. Singa Sahabat
    CanvasTemplateModel(
      id: 'hewan_singa',
      title: 'Singa',
      subtitle: 'Si raja rimba berhati baik',
      category: 'hewan',
      emoji: '🦁',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Surai Lebat Bunga Matahari Singa
        final manePath = Path();
        const petals = 12;
        for (int i = 0; i < petals; i++) {
          final angle = (i / petals) * 2 * math.pi;
          final px = cx + math.cos(angle) * 95 * s;
          final py = cy - 10 * s + math.sin(angle) * 95 * s;
          final r = Rect.fromCenter(center: Offset(px, py), width: 48 * s, height: 48 * s);
          manePath.addOval(r);
        }
        canvas.drawPath(manePath, f);
        canvas.drawPath(manePath, p);

        // Kepala Utama Singa
        final head = Rect.fromCenter(center: Offset(cx, cy - 10 * s), width: 140 * s, height: 140 * s);
        canvas.drawOval(head, f);
        canvas.drawOval(head, p);

        // Telinga Bulat
        canvas.drawCircle(Offset(cx - 55 * s, cy - 60 * s), 18 * s, f);
        canvas.drawCircle(Offset(cx - 55 * s, cy - 60 * s), 18 * s, p);
        canvas.drawCircle(Offset(cx + 55 * s, cy - 60 * s), 18 * s, f);
        canvas.drawCircle(Offset(cx + 55 * s, cy - 60 * s), 18 * s, p);

        // Mata & Alis Singa
        canvas.drawCircle(Offset(cx - 30 * s, cy - 25 * s), 10 * s, p);
        canvas.drawCircle(Offset(cx + 30 * s, cy - 25 * s), 10 * s, p);

        // Hidung Besar
        final nose = Path()
          ..moveTo(cx - 16 * s, cy - 2 * s)
          ..lineTo(cx + 16 * s, cy - 2 * s)
          ..quadraticBezierTo(cx, cy + 16 * s, cx - 16 * s, cy - 2 * s)
          ..close();
        canvas.drawPath(nose, Paint()..color = const Color(0xFF334155));

        // Moncong & Mulut
        final muzzle = Path()
          ..moveTo(cx - 24 * s, cy + 24 * s)
          ..quadraticBezierTo(cx - 12 * s, cy + 34 * s, cx, cy + 14 * s)
          ..quadraticBezierTo(cx + 12 * s, cy + 34 * s, cx + 24 * s, cy + 24 * s);
        canvas.drawPath(muzzle, p);
      },
    ),

    // 5. Gajah Cilik
    CanvasTemplateModel(
      id: 'hewan_gajah',
      title: 'Gajah Cilik',
      subtitle: 'Belalai panjang yang pintar',
      category: 'hewan',
      emoji: '🐘',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Telinga Kiri Lebar
        final earL = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx - 80 * s, cy - 15 * s), width: 75 * s, height: 105 * s));
        canvas.drawPath(earL, f);
        canvas.drawPath(earL, p);

        // Telinga Kanan Lebar
        final earR = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx + 80 * s, cy - 15 * s), width: 75 * s, height: 105 * s));
        canvas.drawPath(earR, f);
        canvas.drawPath(earR, p);

        // Bodi Gajah
        final body = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx, cy + 55 * s), width: 170 * s, height: 125 * s));
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Kepala
        final head = Path()
          ..addOval(Rect.fromCenter(center: Offset(cx, cy - 20 * s), width: 130 * s, height: 120 * s));
        canvas.drawPath(head, f);
        canvas.drawPath(head, p);

        // Mata Ceria
        canvas.drawCircle(Offset(cx - 30 * s, cy - 35 * s), 8 * s, p);
        canvas.drawCircle(Offset(cx + 30 * s, cy - 35 * s), 8 * s, p);

        // Belalai Melengkung Lucu
        final trunk = Path()
          ..moveTo(cx - 15 * s, cy - 2 * s)
          ..quadraticBezierTo(cx - 20 * s, cy + 45 * s, cx, cy + 60 * s)
          ..quadraticBezierTo(cx + 25 * s, cy + 70 * s, cx + 35 * s, cy + 50 * s)
          ..quadraticBezierTo(cx + 32 * s, cy + 42 * s, cx + 22 * s, cy + 48 * s)
          ..quadraticBezierTo(cx + 8 * s, cy + 55 * s, cx - 2 * s, cy + 40 * s)
          ..quadraticBezierTo(cx - 5 * s, cy + 20 * s, cx + 15 * s, cy - 2 * s)
          ..close();
        canvas.drawPath(trunk, f);
        canvas.drawPath(trunk, p);
      },
    ),

    // 6. Bebek Berenang
    CanvasTemplateModel(
      id: 'hewan_bebek',
      title: 'Bebek',
      subtitle: 'Kwek kwek si bebek lucu',
      category: 'hewan',
      emoji: '🦆',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Bebek
        final body = Path()
          ..moveTo(cx - 75 * s, cy + 25 * s)
          ..quadraticBezierTo(cx - 95 * s, cy + 85 * s, cx - 20 * s, cy + 85 * s)
          ..quadraticBezierTo(cx + 65 * s, cy + 85 * s, cx + 85 * s, cy + 40 * s)
          ..quadraticBezierTo(cx + 90 * s, cy + 15 * s, cx + 65 * s, cy + 10 * s)
          ..quadraticBezierTo(cx + 15 * s, cy + 15 * s, cx - 15 * s, cy - 5 * s)
          ..close();
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Kepala Bebek Bulat
        final head = Rect.fromCenter(center: Offset(cx - 40 * s, cy - 35 * s), width: 90 * s, height: 90 * s);
        canvas.drawOval(head, f);
        canvas.drawOval(head, p);

        // Paruh Bebek
        final beak = Path()
          ..moveTo(cx - 75 * s, cy - 40 * s)
          ..quadraticBezierTo(cx - 120 * s, cy - 35 * s, cx - 110 * s, cy - 25 * s)
          ..quadraticBezierTo(cx - 85 * s, cy - 15 * s, cx - 72 * s, cy - 25 * s)
          ..close();
        canvas.drawPath(beak, f);
        canvas.drawPath(beak, p);

        // Mata
        canvas.drawCircle(Offset(cx - 48 * s, cy - 45 * s), 7 * s, p);

        // Sayap
        final wing = Path()
          ..moveTo(cx + 5 * s, cy + 30 * s)
          ..quadraticBezierTo(cx + 40 * s, cy + 15 * s, cx + 60 * s, cy + 30 * s)
          ..quadraticBezierTo(cx + 35 * s, cy + 65 * s, cx + 5 * s, cy + 30 * s)
          ..close();
        canvas.drawPath(wing, f);
        canvas.drawPath(wing, p);

        // Ombak Air
        final water = Path()
          ..moveTo(cx - 110 * s, cy + 95 * s)
          ..quadraticBezierTo(cx - 60 * s, cy + 85 * s, cx - 10 * s, cy + 95 * s)
          ..quadraticBezierTo(cx + 40 * s, cy + 105 * s, cx + 90 * s, cy + 95 * s);
        canvas.drawPath(water, p);
      },
    ),

    // 7. Penguin Kutub
    CanvasTemplateModel(
      id: 'hewan_penguin',
      title: 'Penguin',
      subtitle: 'Si burung kutub ramah',
      category: 'hewan',
      emoji: '🐧',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Sirip Tangan Kiri & Kanan
        final finL = Path()
          ..moveTo(cx - 65 * s, cy - 20 * s)
          ..quadraticBezierTo(cx - 105 * s, cy + 20 * s, cx - 75 * s, cy + 45 * s)
          ..quadraticBezierTo(cx - 60 * s, cy + 25 * s, cx - 55 * s, cy)
          ..close();
        canvas.drawPath(finL, f);
        canvas.drawPath(finL, p);

        final finR = Path()
          ..moveTo(cx + 65 * s, cy - 20 * s)
          ..quadraticBezierTo(cx + 105 * s, cy + 20 * s, cx + 75 * s, cy + 45 * s)
          ..quadraticBezierTo(cx + 60 * s, cy + 25 * s, cx + 55 * s, cy)
          ..close();
        canvas.drawPath(finR, f);
        canvas.drawPath(finR, p);

        // Bodi Luar Penguin
        final body = Path()
          ..moveTo(cx - 65 * s, cy + 60 * s)
          ..quadraticBezierTo(cx - 70 * s, cy - 50 * s, cx - 40 * s, cy - 85 * s)
          ..quadraticBezierTo(cx, cy - 105 * s, cx + 40 * s, cy - 85 * s)
          ..quadraticBezierTo(cx + 70 * s, cy - 50 * s, cx + 65 * s, cy + 60 * s)
          ..quadraticBezierTo(cx + 60 * s, cy + 105 * s, cx, cy + 105 * s)
          ..quadraticBezierTo(cx - 60 * s, cy + 105 * s, cx - 65 * s, cy + 60 * s)
          ..close();
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Perut Putih Oval
        final belly = Rect.fromCenter(center: Offset(cx, cy + 25 * s), width: 85 * s, height: 110 * s);
        canvas.drawOval(belly, p);

        // Mata Bulat Lucu
        canvas.drawCircle(Offset(cx - 24 * s, cy - 45 * s), 7 * s, p);
        canvas.drawCircle(Offset(cx + 24 * s, cy - 45 * s), 7 * s, p);

        // Paruh Segitiga
        final beak = Path()
          ..moveTo(cx - 14 * s, cy - 35 * s)
          ..lineTo(cx + 14 * s, cy - 35 * s)
          ..lineTo(cx, cy - 18 * s)
          ..close();
        canvas.drawPath(beak, f);
        canvas.drawPath(beak, p);

        // Kaki Bebek Orange
        canvas.drawOval(Rect.fromCenter(center: Offset(cx - 25 * s, cy + 108 * s), width: 30 * s, height: 14 * s), p);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 25 * s, cy + 108 * s), width: 30 * s, height: 14 * s), p);
      },
    ),

    // 8. Ikan Lumba-Lumba
    CanvasTemplateModel(
      id: 'hewan_dolphin',
      title: 'Lumba-Lumba',
      subtitle: 'Si pintar pelompat air',
      category: 'hewan',
      emoji: '🐬',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Lumba-lumba Melompat Melengkung
        final body = Path()
          ..moveTo(cx - 95 * s, cy + 30 * s)
          ..quadraticBezierTo(cx - 60 * s, cy - 75 * s, cx + 25 * s, cy - 75 * s)
          ..quadraticBezierTo(cx + 95 * s, cy - 65 * s, cx + 115 * s, cy + 45 * s)
          ..quadraticBezierTo(cx + 70 * s, cy + 25 * s, cx + 45 * s, cy - 10 * s)
          ..quadraticBezierTo(cx - 20 * s, cy - 10 * s, cx - 75 * s, cy + 40 * s)
          ..close();
        canvas.drawPath(body, f);
        canvas.drawPath(body, p);

        // Sirip Punggung
        final dorsal = Path()
          ..moveTo(cx - 5 * s, cy - 75 * s)
          ..quadraticBezierTo(cx + 5 * s, cy - 115 * s, cx + 35 * s, cy - 100 * s)
          ..quadraticBezierTo(cx + 25 * s, cy - 80 * s, cx + 20 * s, cy - 74 * s);
        canvas.drawPath(dorsal, f);
        canvas.drawPath(dorsal, p);

        // Ekor Cabang Dua
        final tail = Path()
          ..moveTo(cx + 115 * s, cy + 45 * s)
          ..quadraticBezierTo(cx + 135 * s, cy + 35 * s, cx + 140 * s, cy + 65 * s)
          ..quadraticBezierTo(cx + 115 * s, cy + 50 * s, cx + 105 * s, cy + 70 * s)
          ..close();
        canvas.drawPath(tail, f);
        canvas.drawPath(tail, p);

        // Sirip Dada Depan
        final flipper = Path()
          ..moveTo(cx - 15 * s, cy)
          ..quadraticBezierTo(cx - 10 * s, cy + 35 * s, cx + 15 * s, cy + 30 * s)
          ..quadraticBezierTo(cx + 5 * s, cy + 10 * s, cx, cy);
        canvas.drawPath(flipper, f);
        canvas.drawPath(flipper, p);

        // Mata & Senyum Moncong
        canvas.drawCircle(Offset(cx - 65 * s, cy - 25 * s), 6 * s, p);
        final smile = Path()
          ..moveTo(cx - 95 * s, cy + 10 * s)
          ..quadraticBezierTo(cx - 80 * s, cy + 18 * s, cx - 65 * s, cy + 5 * s);
        canvas.drawPath(smile, p);
      },
    ),

    // =========================================================================
    // 🚗 2. KATEGORI KENDARAAN (6 Template Halus & Proporsional)
    // =========================================================================

    // 1. Mobil Sedan
    CanvasTemplateModel(
      id: 'kendaraan_mobil',
      title: 'Mobil',
      subtitle: 'Mobil keluarga Ali',
      category: 'kendaraan',
      emoji: '🚗',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Mobil Melengkung Halus
        final carBody = Path()
          ..moveTo(cx - 130 * s, cy + 35 * s)
          ..quadraticBezierTo(cx - 135 * s, cy + 10 * s, cx - 110 * s, cy)
          ..quadraticBezierTo(cx - 80 * s, cy - 10 * s, cx - 55 * s, cy - 55 * s)
          ..quadraticBezierTo(cx, cy - 65 * s, cx + 50 * s, cy - 55 * s)
          ..quadraticBezierTo(cx + 80 * s, cy - 10 * s, cx + 110 * s, cy + 10 * s)
          ..quadraticBezierTo(cx + 135 * s, cy + 20 * s, cx + 130 * s, cy + 35 * s)
          ..lineTo(cx + 85 * s, cy + 35 * s)
          ..arcToPoint(Offset(cx + 45 * s, cy + 35 * s), radius: Radius.circular(24 * s), clockwise: false)
          ..lineTo(cx - 45 * s, cy + 35 * s)
          ..arcToPoint(Offset(cx - 85 * s, cy + 35 * s), radius: Radius.circular(24 * s), clockwise: false)
          ..close();
        canvas.drawPath(carBody, f);
        canvas.drawPath(carBody, p);

        // Kaca Depan & Belakang
        final windowL = Path()
          ..moveTo(cx - 45 * s, cy - 48 * s)
          ..lineTo(cx - 5 * s, cy - 48 * s)
          ..lineTo(cx - 5 * s, cy - 10 * s)
          ..lineTo(cx - 65 * s, cy - 10 * s)
          ..close();
        canvas.drawPath(windowL, f);
        canvas.drawPath(windowL, p);

        final windowR = Path()
          ..moveTo(cx + 5 * s, cy - 48 * s)
          ..lineTo(cx + 45 * s, cy - 48 * s)
          ..lineTo(cx + 65 * s, cy - 10 * s)
          ..lineTo(cx + 5 * s, cy - 10 * s)
          ..close();
        canvas.drawPath(windowR, f);
        canvas.drawPath(windowR, p);

        // Roda Kiri & Kanan (Ban & Velg)
        canvas.drawCircle(Offset(cx - 65 * s, cy + 35 * s), 24 * s, Paint()..color = const Color(0xFF1E293B));
        canvas.drawCircle(Offset(cx - 65 * s, cy + 35 * s), 12 * s, Paint()..color = const Color(0xFFE2E8F0));
        canvas.drawCircle(Offset(cx + 65 * s, cy + 35 * s), 24 * s, Paint()..color = const Color(0xFF1E293B));
        canvas.drawCircle(Offset(cx + 65 * s, cy + 35 * s), 12 * s, Paint()..color = const Color(0xFFE2E8F0));

        // Lampu Depan & Belakang
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + 120 * s, cy + 12 * s, 10 * s, 14 * s), Radius.circular(4 * s)), p);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 130 * s, cy + 12 * s, 10 * s, 14 * s), Radius.circular(4 * s)), p);
      },
    ),

    // 2. Bus Sekolah Kuning
    CanvasTemplateModel(
      id: 'kendaraan_bus',
      title: 'Bus',
      subtitle: 'Bus sekolah ceria',
      category: 'kendaraan',
      emoji: '🚌',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Bus Kotak Melengkung
        final busRRect = RRect.fromRectAndCorners(
          Rect.fromCenter(center: Offset(cx, cy - 10 * s), width: 250 * s, height: 110 * s),
          topLeft: Radius.circular(20 * s),
          topRight: Radius.circular(30 * s),
          bottomLeft: Radius.circular(10 * s),
          bottomRight: Radius.circular(10 * s),
        );
        canvas.drawRRect(busRRect, f);
        canvas.drawRRect(busRRect, p);

        // Kaca Depan & Samping (3 Jendela)
        for (int i = 0; i < 4; i++) {
          final winRect = Rect.fromLTWH(cx - 105 * s + i * 54 * s, cy - 50 * s, 42 * s, 36 * s);
          canvas.drawRRect(RRect.fromRectAndRadius(winRect, Radius.circular(6 * s)), p);
        }

        // Garis Strip Bodi
        canvas.drawLine(Offset(cx - 125 * s, cy + 5 * s), Offset(cx + 125 * s, cy + 5 * s), p);

        // Roda Bus
        canvas.drawCircle(Offset(cx - 65 * s, cy + 45 * s), 22 * s, Paint()..color = const Color(0xFF1E293B));
        canvas.drawCircle(Offset(cx - 65 * s, cy + 45 * s), 10 * s, Paint()..color = const Color(0xFFE2E8F0));
        canvas.drawCircle(Offset(cx + 65 * s, cy + 45 * s), 22 * s, Paint()..color = const Color(0xFF1E293B));
        canvas.drawCircle(Offset(cx + 65 * s, cy + 45 * s), 10 * s, Paint()..color = const Color(0xFFE2E8F0));
      },
    ),

    // 3. Pesawat Terbang
    CanvasTemplateModel(
      id: 'kendaraan_pesawat',
      title: 'Pesawat',
      subtitle: 'Terbang tinggi menembus awan',
      category: 'kendaraan',
      emoji: '✈️',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Pesawat
        final fuselage = Path()
          ..moveTo(cx - 110 * s, cy)
          ..quadraticBezierTo(cx - 120 * s, cy - 15 * s, cx - 70 * s, cy - 20 * s)
          ..lineTo(cx + 70 * s, cy - 15 * s)
          ..lineTo(cx + 105 * s, cy - 55 * s) // Ekor atas
          ..lineTo(cx + 120 * s, cy - 50 * s)
          ..lineTo(cx + 100 * s, cy)
          ..lineTo(cx + 70 * s, cy + 15 * s)
          ..lineTo(cx - 70 * s, cy + 20 * s)
          ..close();
        canvas.drawPath(fuselage, f);
        canvas.drawPath(fuselage, p);

        // Sayap Utama
        final wing = Path()
          ..moveTo(cx - 15 * s, cy - 5 * s)
          ..lineTo(cx - 45 * s, cy + 65 * s)
          ..lineTo(cx - 20 * s, cy + 70 * s)
          ..lineTo(cx + 35 * s, cy + 5 * s)
          ..close();
        canvas.drawPath(wing, f);
        canvas.drawPath(wing, p);

        // Jendela Kokpit & Penumpang
        for (int i = 0; i < 5; i++) {
          canvas.drawCircle(Offset(cx - 60 * s + i * 26 * s, cy - 5 * s), 6 * s, p);
        }
      },
    ),

    // 4. Kapal Laut Layar
    CanvasTemplateModel(
      id: 'kendaraan_kapal',
      title: 'Kapal Layar',
      subtitle: 'Mengarungi samudra biru',
      category: 'kendaraan',
      emoji: '⛵',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Lambung Kapal
        final hull = Path()
          ..moveTo(cx - 100 * s, cy + 35 * s)
          ..lineTo(cx + 100 * s, cy + 35 * s)
          ..quadraticBezierTo(cx + 85 * s, cy + 85 * s, cx + 55 * s, cy + 85 * s)
          ..lineTo(cx - 65 * s, cy + 85 * s)
          ..quadraticBezierTo(cx - 85 * s, cy + 85 * s, cx - 100 * s, cy + 35 * s)
          ..close();
        canvas.drawPath(hull, f);
        canvas.drawPath(hull, p);

        // Tiang Layar
        canvas.drawLine(Offset(cx, cy + 35 * s), Offset(cx, cy - 95 * s), p);

        // Layar Utama Kanan (Segitiga Melengkung)
        final sailR = Path()
          ..moveTo(cx + 5 * s, cy - 85 * s)
          ..quadraticBezierTo(cx + 55 * s, cy - 25 * s, cx + 75 * s, cy + 20 * s)
          ..lineTo(cx + 5 * s, cy + 20 * s)
          ..close();
        canvas.drawPath(sailR, f);
        canvas.drawPath(sailR, p);

        // Layar Kiri
        final sailL = Path()
          ..moveTo(cx - 5 * s, cy - 70 * s)
          ..quadraticBezierTo(cx - 45 * s, cy - 25 * s, cx - 65 * s, cy + 20 * s)
          ..lineTo(cx - 5 * s, cy + 20 * s)
          ..close();
        canvas.drawPath(sailL, f);
        canvas.drawPath(sailL, p);

        // Ombak Air
        final waves = Path()
          ..moveTo(cx - 120 * s, cy + 95 * s)
          ..quadraticBezierTo(cx - 70 * s, cy + 85 * s, cx - 20 * s, cy + 95 * s)
          ..quadraticBezierTo(cx + 30 * s, cy + 105 * s, cx + 80 * s, cy + 95 * s)
          ..quadraticBezierTo(cx + 110 * s, cy + 88 * s, cx + 130 * s, cy + 95 * s);
        canvas.drawPath(waves, p);
      },
    ),

    // 5. Roket Luar Angkasa
    CanvasTemplateModel(
      id: 'kendaraan_roket',
      title: 'Roket',
      subtitle: 'Menjelajah planet & bintang',
      category: 'kendaraan',
      emoji: '🚀',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Roket Silinder Kerucut
        final rocket = Path()
          ..moveTo(cx, cy - 110 * s)
          ..quadraticBezierTo(cx + 45 * s, cy - 40 * s, cx + 45 * s, cy + 50 * s)
          ..lineTo(cx - 45 * s, cy + 50 * s)
          ..quadraticBezierTo(cx - 45 * s, cy - 40 * s, cx, cy - 110 * s)
          ..close();
        canvas.drawPath(rocket, f);
        canvas.drawPath(rocket, p);

        // Sirip Kiri & Kanan
        final finL = Path()
          ..moveTo(cx - 45 * s, cy + 10 * s)
          ..lineTo(cx - 85 * s, cy + 65 * s)
          ..lineTo(cx - 45 * s, cy + 50 * s)
          ..close();
        canvas.drawPath(finL, f);
        canvas.drawPath(finL, p);

        final finR = Path()
          ..moveTo(cx + 45 * s, cy + 10 * s)
          ..lineTo(cx + 85 * s, cy + 65 * s)
          ..lineTo(cx + 45 * s, cy + 50 * s)
          ..close();
        canvas.drawPath(finR, f);
        canvas.drawPath(finR, p);

        // Kaca Bulat Astronaut
        canvas.drawCircle(Offset(cx, cy - 25 * s), 22 * s, f);
        canvas.drawCircle(Offset(cx, cy - 25 * s), 22 * s, p);
        canvas.drawCircle(Offset(cx, cy - 25 * s), 15 * s, p);

        // Kobaran Api
        final fire = Path()
          ..moveTo(cx - 25 * s, cy + 50 * s)
          ..lineTo(cx - 15 * s, cy + 85 * s)
          ..lineTo(cx, cy + 70 * s)
          ..lineTo(cx + 15 * s, cy + 85 * s)
          ..lineTo(cx + 25 * s, cy + 50 * s);
        canvas.drawPath(fire, p);
      },
    ),

    // 6. Sepeda Gowes
    CanvasTemplateModel(
      id: 'kendaraan_sepeda',
      title: 'Sepeda',
      subtitle: 'Sepeda roda dua gowes',
      category: 'kendaraan',
      emoji: '🚲',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Roda Belakang & Roda Depan
        canvas.drawCircle(Offset(cx - 75 * s, cy + 30 * s), 36 * s, f);
        canvas.drawCircle(Offset(cx - 75 * s, cy + 30 * s), 36 * s, p);
        canvas.drawCircle(Offset(cx - 75 * s, cy + 30 * s), 8 * s, Paint()..color = const Color(0xFF334155));

        canvas.drawCircle(Offset(cx + 75 * s, cy + 30 * s), 36 * s, f);
        canvas.drawCircle(Offset(cx + 75 * s, cy + 30 * s), 36 * s, p);
        canvas.drawCircle(Offset(cx + 75 * s, cy + 30 * s), 8 * s, Paint()..color = const Color(0xFF334155));

        // Rangka Segitiga Sepeda
        final frame = Path()
          ..moveTo(cx - 75 * s, cy + 30 * s)
          ..lineTo(cx - 15 * s, cy + 30 * s) // Gir pedal
          ..lineTo(cx + 45 * s, cy - 25 * s) // Setang
          ..lineTo(cx - 25 * s, cy - 25 * s) // Sadel
          ..close();
        canvas.drawPath(frame, p);

        // Tiang Sadel & Tiang Garpu
        canvas.drawLine(Offset(cx - 15 * s, cy + 30 * s), Offset(cx - 25 * s, cy - 40 * s), p);
        canvas.drawLine(Offset(cx + 45 * s, cy - 25 * s), Offset(cx + 75 * s, cy + 30 * s), p);
        canvas.drawLine(Offset(cx + 45 * s, cy - 25 * s), Offset(cx + 40 * s, cy - 50 * s), p); // Setang atas

        // Sadel & Pegangan Setang
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 40 * s, cy - 45 * s, 32 * s, 8 * s), Radius.circular(4 * s)), p);
        canvas.drawLine(Offset(cx + 25 * s, cy - 50 * s), Offset(cx + 55 * s, cy - 50 * s), p);
      },
    ),

    // =========================================================================
    // 🍎 3. KATEGORI BUAH MANIS (6 Template Segar & Bersih)
    // =========================================================================

    // 1. Apel Merah
    CanvasTemplateModel(
      id: 'buah_apel',
      title: 'Apel',
      subtitle: 'Apel manis berkilau',
      category: 'buah',
      emoji: '🍎',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Buah Apel Lengkung Khas
        final apple = Path()
          ..moveTo(cx, cy - 55 * s)
          ..cubicTo(cx - 50 * s, cy - 75 * s, cx - 110 * s, cy - 25 * s, cx - 100 * s, cy + 35 * s)
          ..cubicTo(cx - 90 * s, cy + 95 * s, cx - 20 * s, cy + 95 * s, cx, cy + 75 * s)
          ..cubicTo(cx + 20 * s, cy + 95 * s, cx + 90 * s, cy + 95 * s, cx + 100 * s, cy + 35 * s)
          ..cubicTo(cx + 110 * s, cy - 25 * s, cx + 50 * s, cy - 75 * s, cx, cy - 55 * s)
          ..close();
        canvas.drawPath(apple, f);
        canvas.drawPath(apple, p);

        // Tangkai
        final stem = Path()
          ..moveTo(cx, cy - 55 * s)
          ..quadraticBezierTo(cx + 5 * s, cy - 85 * s, cx + 18 * s, cy - 95 * s);
        canvas.drawPath(stem, p..strokeWidth = 4.5);

        // Daun Apel Segar
        final leaf = Path()
          ..moveTo(cx + 8 * s, cy - 75 * s)
          ..quadraticBezierTo(cx + 45 * s, cy - 95 * s, cx + 65 * s, cy - 75 * s)
          ..quadraticBezierTo(cx + 40 * s, cy - 60 * s, cx + 8 * s, cy - 75 * s)
          ..close();
        canvas.drawPath(leaf, f);
        canvas.drawPath(leaf, p..strokeWidth = 3.5);
      },
    ),

    // 2. Pisang
    CanvasTemplateModel(
      id: 'buah_pisang',
      title: 'Pisang',
      subtitle: 'Pisang kuning manis',
      category: 'buah',
      emoji: '🍌',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Pisang Melengkung
        final banana = Path()
          ..moveTo(cx - 75 * s, cy - 75 * s)
          ..quadraticBezierTo(cx - 85 * s, cy - 65 * s, cx - 60 * s, cy - 10 * s)
          ..quadraticBezierTo(cx - 15 * s, cy + 75 * s, cx + 75 * s, cy + 75 * s)
          ..quadraticBezierTo(cx + 95 * s, cy + 65 * s, cx + 85 * s, cy + 50 * s)
          ..quadraticBezierTo(cx + 15 * s, cy + 45 * s, cx - 35 * s, cy - 25 * s)
          ..quadraticBezierTo(cx - 65 * s, cy - 65 * s, cx - 75 * s, cy - 75 * s)
          ..close();
        canvas.drawPath(banana, f);
        canvas.drawPath(banana, p);

        // Garis Rusuk Tengah Pisang
        final ridge = Path()
          ..moveTo(cx - 65 * s, cy - 65 * s)
          ..quadraticBezierTo(cx - 30 * s, cy - 10 * s, cx + 15 * s, cy + 55 * s);
        canvas.drawPath(ridge, p);
      },
    ),

    // 3. Semangka
    CanvasTemplateModel(
      id: 'buah_semangka',
      title: 'Semangka',
      subtitle: 'Potongan semangka segar',
      category: 'buah',
      emoji: '🍉',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Kulit Luar Hijau
        final rind = Path()
          ..moveTo(cx - 110 * s, cy - 20 * s)
          ..lineTo(cx + 110 * s, cy - 20 * s)
          ..quadraticBezierTo(cx + 90 * s, cy + 90 * s, cx, cy + 95 * s)
          ..quadraticBezierTo(cx - 90 * s, cy + 90 * s, cx - 110 * s, cy - 20 * s)
          ..close();
        canvas.drawPath(rind, f);
        canvas.drawPath(rind, p);

        // Daging Merah
        final flesh = Path()
          ..moveTo(cx - 95 * s, cy - 12 * s)
          ..lineTo(cx + 95 * s, cy - 12 * s)
          ..quadraticBezierTo(cx + 75 * s, cy + 75 * s, cx, cy + 80 * s)
          ..quadraticBezierTo(cx - 75 * s, cy + 75 * s, cx - 95 * s, cy - 12 * s)
          ..close();
        canvas.drawPath(flesh, f);
        canvas.drawPath(flesh, p);

        // Biji-Biji Semangka (Tetes Air)
        final seeds = [
          Offset(cx - 45 * s, cy + 10 * s),
          Offset(cx - 15 * s, cy + 30 * s),
          Offset(cx + 25 * s, cy + 15 * s),
          Offset(cx + 50 * s, cy + 35 * s),
          Offset(cx, cy + 55 * s),
        ];
        for (final seed in seeds) {
          canvas.drawOval(Rect.fromCenter(center: seed, width: 7 * s, height: 11 * s), Paint()..color = const Color(0xFF334155));
        }
      },
    ),

    // 4. Jeruk
    CanvasTemplateModel(
      id: 'buah_jeruk',
      title: 'Jeruk',
      subtitle: 'Jeruk bulat kaya vitamin C',
      category: 'buah',
      emoji: '🍊',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Buah Jeruk Bulat
        canvas.drawCircle(Offset(cx, cy + 5 * s), 85 * s, f);
        canvas.drawCircle(Offset(cx, cy + 5 * s), 85 * s, p);

        // Tangkai & Daun di Atas
        canvas.drawLine(Offset(cx, cy - 80 * s), Offset(cx, cy - 100 * s), p);

        final leaf = Path()
          ..moveTo(cx, cy - 90 * s)
          ..quadraticBezierTo(cx + 35 * s, cy - 110 * s, cx + 55 * s, cy - 95 * s)
          ..quadraticBezierTo(cx + 35 * s, cy - 75 * s, cx, cy - 90 * s)
          ..close();
        canvas.drawPath(leaf, f);
        canvas.drawPath(leaf, p);
      },
    ),

    // 5. Stroberi
    CanvasTemplateModel(
      id: 'buah_stroberi',
      title: 'Stroberi',
      subtitle: 'Stroberi merah manis',
      category: 'buah',
      emoji: '🍓',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bodi Buah Bentuk Hati Tumpul
        final berry = Path()
          ..moveTo(cx, cy - 40 * s)
          ..cubicTo(cx - 75 * s, cy - 45 * s, cx - 90 * s, cy + 25 * s, cx, cy + 95 * s)
          ..cubicTo(cx + 90 * s, cy + 25 * s, cx + 75 * s, cy - 45 * s, cx, cy - 40 * s)
          ..close();
        canvas.drawPath(berry, f);
        canvas.drawPath(berry, p);

        // Mahkota Daun Bintang di Atas
        final crown = Path()
          ..moveTo(cx - 55 * s, cy - 45 * s)
          ..lineTo(cx - 30 * s, cy - 30 * s)
          ..lineTo(cx, cy - 65 * s)
          ..lineTo(cx + 30 * s, cy - 30 * s)
          ..lineTo(cx + 55 * s, cy - 45 * s)
          ..lineTo(cx + 20 * s, cy - 25 * s)
          ..lineTo(cx, cy - 35 * s)
          ..lineTo(cx - 20 * s, cy - 25 * s)
          ..close();
        canvas.drawPath(crown, f);
        canvas.drawPath(crown, p);

        // Bintik-bintik Stroberi
        final dots = [
          Offset(cx - 30 * s, cy),
          Offset(cx, cy - 5 * s),
          Offset(cx + 30 * s, cy),
          Offset(cx - 15 * s, cy + 35 * s),
          Offset(cx + 15 * s, cy + 35 * s),
          Offset(cx, cy + 65 * s),
        ];
        for (final dot in dots) {
          canvas.drawCircle(dot, 3 * s, Paint()..color = const Color(0xFF334155));
        }
      },
    ),

    // 6. Anggur
    CanvasTemplateModel(
      id: 'buah_anggur',
      title: 'Anggur',
      subtitle: 'Sekumpulan anggur manis',
      category: 'buah',
      emoji: '🍇',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Tangkai Anggur
        canvas.drawLine(Offset(cx, cy - 60 * s), Offset(cx, cy - 90 * s), p..strokeWidth = 4.5);

        // Butiran Anggur Tersusun Segitiga Terbalik
        final positions = [
          // Baris 1 (Atas - 4 butir)
          Offset(cx - 45 * s, cy - 35 * s), Offset(cx - 15 * s, cy - 35 * s), Offset(cx + 15 * s, cy - 35 * s), Offset(cx + 45 * s, cy - 35 * s),
          // Baris 2 (Tengah - 3 butir)
          Offset(cx - 30 * s, cy - 5 * s), Offset(cx, cy - 5 * s), Offset(cx + 30 * s, cy - 5 * s),
          // Baris 3 (Bawah - 2 butir)
          Offset(cx - 15 * s, cy + 25 * s), Offset(cx + 15 * s, cy + 25 * s),
          // Baris 4 (Ujung bawah - 1 butir)
          Offset(cx, cy + 55 * s),
        ];

        for (final pos in positions) {
          canvas.drawCircle(pos, 18 * s, f);
          canvas.drawCircle(pos, 18 * s, p..strokeWidth = 3.5);
        }
      },
    ),

    // =========================================================================
    // 🧸 4. KATEGORI BENDA SERU (6 Template Menarik)
    // =========================================================================

    // 1. Balon Udara Cantik
    CanvasTemplateModel(
      id: 'benda_balon_udara',
      title: 'Balon Udara',
      subtitle: 'Melayang di langit biru',
      category: 'benda',
      emoji: '🎈',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Kubah Balon Udara
        final balloon = Path()
          ..moveTo(cx - 35 * s, cy + 45 * s)
          ..cubicTo(cx - 105 * s, cy + 15 * s, cx - 100 * s, cy - 95 * s, cx, cy - 95 * s)
          ..cubicTo(cx + 100 * s, cy - 95 * s, cx + 105 * s, cy + 15 * s, cx + 35 * s, cy + 45 * s)
          ..close();
        canvas.drawPath(balloon, f);
        canvas.drawPath(balloon, p);

        // Garis Pola Vertikal Balon
        canvas.drawLine(Offset(cx, cy - 95 * s), Offset(cx, cy + 45 * s), p);
        canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy - 25 * s), width: 70 * s, height: 140 * s), -math.pi / 2, math.pi, false, p);
        canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy - 25 * s), width: 70 * s, height: 140 * s), math.pi / 2, math.pi, false, p);

        // Tali Penggantung
        canvas.drawLine(Offset(cx - 25 * s, cy + 45 * s), Offset(cx - 18 * s, cy + 70 * s), p);
        canvas.drawLine(Offset(cx + 25 * s, cy + 45 * s), Offset(cx + 18 * s, cy + 70 * s), p);

        // Keranjang Penumpang
        final basket = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 85 * s), width: 44 * s, height: 30 * s), Radius.circular(6 * s));
        canvas.drawRRect(basket, f);
        canvas.drawRRect(basket, p);
      },
    ),

    // 2. Boneka Teddy Bear
    CanvasTemplateModel(
      id: 'benda_boneka',
      title: 'Boneka Beruang',
      subtitle: 'Teman tidur yang empuk',
      category: 'benda',
      emoji: '🧸',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Telinga Beruang
        canvas.drawCircle(Offset(cx - 50 * s, cy - 65 * s), 22 * s, f);
        canvas.drawCircle(Offset(cx - 50 * s, cy - 65 * s), 22 * s, p);
        canvas.drawCircle(Offset(cx + 50 * s, cy - 65 * s), 22 * s, f);
        canvas.drawCircle(Offset(cx + 50 * s, cy - 65 * s), 22 * s, p);

        // Badan
        final body = Rect.fromCenter(center: Offset(cx, cy + 50 * s), width: 120 * s, height: 110 * s);
        canvas.drawOval(body, f);
        canvas.drawOval(body, p);

        // Kepala
        final head = Rect.fromCenter(center: Offset(cx, cy - 20 * s), width: 130 * s, height: 110 * s);
        canvas.drawOval(head, f);
        canvas.drawOval(head, p);

        // Moncong Tengah
        final snout = Rect.fromCenter(center: Offset(cx, cy - 10 * s), width: 50 * s, height: 38 * s);
        canvas.drawOval(snout, f);
        canvas.drawOval(snout, p);

        // Hidung & Mulut
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - 16 * s), width: 18 * s, height: 12 * s), Paint()..color = const Color(0xFF334155));
        canvas.drawLine(Offset(cx, cy - 10 * s), Offset(cx, cy), p);
        final smile = Path()
          ..moveTo(cx - 10 * s, cy + 2 * s)
          ..quadraticBezierTo(cx, cy + 8 * s, cx + 10 * s, cy + 2 * s);
        canvas.drawPath(smile, p);

        // Mata Kancing
        canvas.drawCircle(Offset(cx - 30 * s, cy - 30 * s), 6 * s, Paint()..color = const Color(0xFF334155));
        canvas.drawCircle(Offset(cx + 30 * s, cy - 30 * s), 6 * s, Paint()..color = const Color(0xFF334155));
      },
    ),

    // 3. Rumah Impian
    CanvasTemplateModel(
      id: 'benda_rumah',
      title: 'Rumah',
      subtitle: 'Rumah hangat keluarga',
      category: 'benda',
      emoji: '🏠',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Tembok Rumah Utama
        final houseWall = Rect.fromCenter(center: Offset(cx, cy + 30 * s), width: 160 * s, height: 110 * s);
        canvas.drawRect(houseWall, f);
        canvas.drawRect(houseWall, p);

        // Atap Segitiga
        final roof = Path()
          ..moveTo(cx - 105 * s, cy - 25 * s)
          ..lineTo(cx, cy - 100 * s)
          ..lineTo(cx + 105 * s, cy - 25 * s)
          ..close();
        canvas.drawPath(roof, f);
        canvas.drawPath(roof, p);

        // Pintu Masuk
        final door = Rect.fromCenter(center: Offset(cx - 35 * s, cy + 50 * s), width: 40 * s, height: 70 * s);
        canvas.drawRect(door, f);
        canvas.drawRect(door, p);
        canvas.drawCircle(Offset(cx - 22 * s, cy + 50 * s), 4 * s, Paint()..color = const Color(0xFF334155));

        // Jendela Berjeruji
        final win = Rect.fromCenter(center: Offset(cx + 35 * s, cy + 25 * s), width: 44 * s, height: 44 * s);
        canvas.drawRect(win, f);
        canvas.drawRect(win, p);
        canvas.drawLine(Offset(cx + 35 * s, cy + 3 * s), Offset(cx + 35 * s, cy + 47 * s), p);
        canvas.drawLine(Offset(cx + 13 * s, cy + 25 * s), Offset(cx + 57 * s, cy + 25 * s), p);
      },
    ),

    // 4. Kue Ulang Tahun
    CanvasTemplateModel(
      id: 'benda_kue',
      title: 'Kue Ulang Tahun',
      subtitle: 'Kue manis bertingkat dengan lilin',
      category: 'benda',
      emoji: '🎂',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Piring Kue
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 85 * s), width: 210 * s, height: 35 * s), f);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 85 * s), width: 210 * s, height: 35 * s), p);

        // Tingkat Bawah Kue
        final bottomTier = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 45 * s), width: 170 * s, height: 65 * s), Radius.circular(12 * s));
        canvas.drawRRect(bottomTier, f);
        canvas.drawRRect(bottomTier, p);

        // Tingkat Atas Kue
        final topTier = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - 5 * s), width: 115 * s, height: 50 * s), Radius.circular(10 * s));
        canvas.drawRRect(topTier, f);
        canvas.drawRRect(topTier, p);

        // Lilin di Atas
        canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - 45 * s), width: 12 * s, height: 30 * s), f);
        canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - 45 * s), width: 12 * s, height: 30 * s), p);

        // Api Lilin (Tetesan Api)
        final flame = Path()
          ..moveTo(cx, cy - 85 * s)
          ..quadraticBezierTo(cx + 12 * s, cy - 65 * s, cx, cy - 60 * s)
          ..quadraticBezierTo(cx - 12 * s, cy - 65 * s, cx, cy - 85 * s)
          ..close();
        canvas.drawPath(flame, f);
        canvas.drawPath(flame, p);
      },
    ),

    // 5. Bintang Terang
    CanvasTemplateModel(
      id: 'benda_bintang',
      title: 'Bintang Terang',
      subtitle: 'Bintang senyum di langit malam',
      category: 'benda',
      emoji: '⭐',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Bintang 5 Sudut Proporsional
        final star = Path();
        const points = 5;
        const outerR = 95.0;
        const innerR = 42.0;

        for (int i = 0; i < points * 2; i++) {
          final r = (i % 2 == 0 ? outerR : innerR) * s;
          final angle = (i * math.pi / points) - math.pi / 2;
          final px = cx + math.cos(angle) * r;
          final py = cy + math.sin(angle) * r;
          if (i == 0) {
            star.moveTo(px, py);
          } else {
            star.lineTo(px, py);
          }
        }
        star.close();
        canvas.drawPath(star, f);
        canvas.drawPath(star, p);

        // Wajah Bintang Senyum
        canvas.drawCircle(Offset(cx - 20 * s, cy - 5 * s), 6 * s, Paint()..color = const Color(0xFF334155));
        canvas.drawCircle(Offset(cx + 20 * s, cy - 5 * s), 6 * s, Paint()..color = const Color(0xFF334155));

        final smile = Path()
          ..moveTo(cx - 15 * s, cy + 15 * s)
          ..quadraticBezierTo(cx, cy + 28 * s, cx + 15 * s, cy + 15 * s);
        canvas.drawPath(smile, p);
      },
    ),

    // 6. Matahari Ceria
    CanvasTemplateModel(
      id: 'benda_matahari',
      title: 'Matahari',
      subtitle: 'Matahari ceria di pagi hari',
      category: 'benda',
      emoji: '☀️',
      painter: (canvas, size, {strokePaint, fillPaint}) {
        final p = strokePaint ?? (Paint()..color = const Color(0xFF334155)..strokeWidth = 3.5..style = PaintingStyle.stroke);
        final f = fillPaint ?? (Paint()..color = const Color(0xFFF8FAFC)..style = PaintingStyle.fill);

        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final cx = w / 2;
        final cy = h / 2;
        final s = minDim / 340.0;

        // Sinar Matahari Segitiga Berputar
        const rays = 8;
        for (int i = 0; i < rays; i++) {
          final angle = (i / rays) * 2 * math.pi;
          final p1 = Offset(cx + math.cos(angle - 0.15) * 65 * s, cy + math.sin(angle - 0.15) * 65 * s);
          final p2 = Offset(cx + math.cos(angle) * 110 * s, cy + math.sin(angle) * 110 * s);
          final p3 = Offset(cx + math.cos(angle + 0.15) * 65 * s, cy + math.sin(angle + 0.15) * 65 * s);

          final rayPath = Path()
            ..moveTo(p1.dx, p1.dy)
            ..lineTo(p2.dx, p2.dy)
            ..lineTo(p3.dx, p3.dy)
            ..close();
          canvas.drawPath(rayPath, f);
          canvas.drawPath(rayPath, p);
        }

        // Lingkaran Matahari
        canvas.drawCircle(Offset(cx, cy), 65 * s, f);
        canvas.drawCircle(Offset(cx, cy), 65 * s, p);

        // Mata & Senyum Matahari
        canvas.drawCircle(Offset(cx - 22 * s, cy - 10 * s), 7 * s, Paint()..color = const Color(0xFF334155));
        canvas.drawCircle(Offset(cx + 22 * s, cy - 10 * s), 7 * s, Paint()..color = const Color(0xFF334155));

        final smile = Path()
          ..moveTo(cx - 24 * s, cy + 12 * s)
          ..quadraticBezierTo(cx, cy + 32 * s, cx + 24 * s, cy + 12 * s);
        canvas.drawPath(smile, p);
      },
    ),
  ];
}
