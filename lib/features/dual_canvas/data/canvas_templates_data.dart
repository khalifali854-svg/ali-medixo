import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/models/canvas_template_model.dart';

/// Helper untuk membuat segment lingkaran/oval dalam ruang 0.0 - 1.0
TemplateSegment makeCircleSegment(Offset center, double radius, {int steps = 36, String? partName}) {
  final pts = <Offset>[];
  for (int i = 0; i <= steps; i++) {
    final angle = (i / steps) * 2 * math.pi;
    pts.add(Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    ));
  }
  return TemplateSegment(points: pts, isClosed: true, partName: partName);
}

/// Helper untuk membuat segment oval/elips dalam ruang 0.0 - 1.0
TemplateSegment makeOvalSegment(Offset center, double rx, double ry, {int steps = 36, String? partName}) {
  final pts = <Offset>[];
  for (int i = 0; i <= steps; i++) {
    final angle = (i / steps) * 2 * math.pi;
    pts.add(Offset(
      center.dx + rx * math.cos(angle),
      center.dy + ry * math.sin(angle),
    ));
  }
  return TemplateSegment(points: pts, isClosed: true, partName: partName);
}

/// 30 Template Kerangka Gambar (10 Kendaraan, 10 Buah, 10 Benda)
class CanvasTemplatesData {
  static const List<String> categories = ['kendaraan', 'buah', 'benda'];

  static String getCategoryLabel(String cat) {
    switch (cat) {
      case 'kendaraan':
        return '🚗 Kendaraan';
      case 'buah':
        return '🍎 Buah';
      case 'benda':
        return '🧸 Benda';
      default:
        return 'Koleksi';
    }
  }

  static List<CanvasTemplateModel> getByCategory(String cat) {
    return allTemplates.where((t) => t.category == cat).toList();
  }

  static final List<CanvasTemplateModel> allTemplates = [
    // =========================================================================
    // 🚗 KENDARAAN (10 Template)
    // =========================================================================

    // 1. Mobil Sedan
    CanvasTemplateModel(
      id: 'kendaraan_mobil',
      title: 'Mobil',
      subtitle: 'Mobil keluarga Ali',
      category: 'kendaraan',
      emoji: '🚗',
      segments: [
        // Bodi Mobil Luar
        const TemplateSegment(
          points: [
            Offset(0.12, 0.65),
            Offset(0.12, 0.55),
            Offset(0.24, 0.50),
            Offset(0.35, 0.30),
            Offset(0.68, 0.30),
            Offset(0.82, 0.50),
            Offset(0.92, 0.55),
            Offset(0.92, 0.65),
            Offset(0.82, 0.65),
            Offset(0.78, 0.65),
            Offset(0.42, 0.65),
            Offset(0.38, 0.65),
            Offset(0.12, 0.65),
          ],
          isClosed: true,
          partName: 'Bodi Mobil',
        ),
        // Jendela Kiri & Kanan
        const TemplateSegment(
          points: [
            Offset(0.38, 0.35),
            Offset(0.50, 0.35),
            Offset(0.50, 0.48),
            Offset(0.30, 0.48),
            Offset(0.38, 0.35),
          ],
          isClosed: true,
          partName: 'Jendela Depan',
        ),
        const TemplateSegment(
          points: [
            Offset(0.54, 0.35),
            Offset(0.66, 0.35),
            Offset(0.76, 0.48),
            Offset(0.54, 0.48),
            Offset(0.54, 0.35),
          ],
          isClosed: true,
          partName: 'Jendela Belakang',
        ),
        // Roda Kiri (Lingkaran Luar & Velg)
        makeCircleSegment(const Offset(0.30, 0.65), 0.10, partName: 'Roda Depan'),
        makeCircleSegment(const Offset(0.30, 0.65), 0.04, partName: 'Velg Depan'),
        // Roda Kanan (Lingkaran Luar & Velg)
        makeCircleSegment(const Offset(0.74, 0.65), 0.10, partName: 'Roda Belakang'),
        makeCircleSegment(const Offset(0.74, 0.65), 0.04, partName: 'Velg Belakang'),
        // Lampu Depan & Belakang
        const TemplateSegment(
          points: [Offset(0.12, 0.56), Offset(0.16, 0.56), Offset(0.16, 0.61), Offset(0.12, 0.61)],
          isClosed: true,
          partName: 'Lampu Depan',
        ),
      ],
    ),

    // 2. Bus Sekolah
    CanvasTemplateModel(
      id: 'kendaraan_bus',
      title: 'Bus',
      subtitle: 'Bus sekolah kuning',
      category: 'kendaraan',
      emoji: '🚌',
      segments: [
        // Bodi Bus Kotak Melengkung
        const TemplateSegment(
          points: [
            Offset(0.12, 0.28),
            Offset(0.88, 0.28),
            Offset(0.92, 0.36),
            Offset(0.92, 0.66),
            Offset(0.12, 0.66),
            Offset(0.12, 0.28),
          ],
          isClosed: true,
          partName: 'Bodi Bus',
        ),
        // Garis Pembatas Warna
        const TemplateSegment(
          points: [Offset(0.12, 0.50), Offset(0.92, 0.50)],
          isClosed: false,
          partName: 'Strip Bus',
        ),
        // Jendela Depan Sopir
        const TemplateSegment(
          points: [Offset(0.76, 0.34), Offset(0.88, 0.34), Offset(0.88, 0.48), Offset(0.76, 0.48), Offset(0.76, 0.34)],
          isClosed: true,
          partName: 'Kaca Depan',
        ),
        // 3 Jendela Penumpang
        const TemplateSegment(
          points: [Offset(0.56, 0.34), Offset(0.70, 0.34), Offset(0.70, 0.48), Offset(0.56, 0.48), Offset(0.56, 0.34)],
          isClosed: true,
        ),
        const TemplateSegment(
          points: [Offset(0.36, 0.34), Offset(0.50, 0.34), Offset(0.50, 0.48), Offset(0.36, 0.48), Offset(0.36, 0.34)],
          isClosed: true,
        ),
        const TemplateSegment(
          points: [Offset(0.18, 0.34), Offset(0.30, 0.34), Offset(0.30, 0.48), Offset(0.18, 0.48), Offset(0.18, 0.34)],
          isClosed: true,
        ),
        // 2 Roda Besar
        makeCircleSegment(const Offset(0.30, 0.66), 0.10, partName: 'Roda Belakang'),
        makeCircleSegment(const Offset(0.30, 0.66), 0.04),
        makeCircleSegment(const Offset(0.74, 0.66), 0.10, partName: 'Roda Depan'),
        makeCircleSegment(const Offset(0.74, 0.66), 0.04),
      ],
    ),

    // 3. Truk
    CanvasTemplateModel(
      id: 'kendaraan_truk',
      title: 'Truk',
      subtitle: 'Truk barang yang kuat',
      category: 'kendaraan',
      emoji: '🚚',
      segments: [
        // Bak Belakang
        const TemplateSegment(
          points: [
            Offset(0.12, 0.32),
            Offset(0.60, 0.32),
            Offset(0.60, 0.65),
            Offset(0.12, 0.65),
            Offset(0.12, 0.32),
          ],
          isClosed: true,
          partName: 'Bak Muatan',
        ),
        // Kepala Truk (Kabin Depan)
        const TemplateSegment(
          points: [
            Offset(0.60, 0.42),
            Offset(0.74, 0.42),
            Offset(0.88, 0.50),
            Offset(0.88, 0.65),
            Offset(0.60, 0.65),
          ],
          isClosed: true,
          partName: 'Kepala Truk',
        ),
        // Kaca Kabin
        const TemplateSegment(
          points: [
            Offset(0.64, 0.45),
            Offset(0.74, 0.45),
            Offset(0.84, 0.52),
            Offset(0.64, 0.52),
            Offset(0.64, 0.45),
          ],
          isClosed: true,
        ),
        // 3 Roda Truk
        makeCircleSegment(const Offset(0.24, 0.66), 0.09),
        makeCircleSegment(const Offset(0.46, 0.66), 0.09),
        makeCircleSegment(const Offset(0.76, 0.66), 0.09),
      ],
    ),

    // 4. Kereta Api
    CanvasTemplateModel(
      id: 'kendaraan_kereta',
      title: 'Kereta Api',
      subtitle: 'Kereta api tut tut tut',
      category: 'kendaraan',
      emoji: '🚂',
      segments: [
        // Badan Lokomotif
        const TemplateSegment(
          points: [
            Offset(0.15, 0.38),
            Offset(0.45, 0.38),
            Offset(0.45, 0.50),
            Offset(0.85, 0.50),
            Offset(0.85, 0.70),
            Offset(0.15, 0.70),
            Offset(0.15, 0.38),
          ],
          isClosed: true,
          partName: 'Lokomotif',
        ),
        // Jendela Masinis
        const TemplateSegment(
          points: [Offset(0.20, 0.44), Offset(0.38, 0.44), Offset(0.38, 0.56), Offset(0.20, 0.56), Offset(0.20, 0.44)],
          isClosed: true,
        ),
        // Cerobong Asap
        const TemplateSegment(
          points: [Offset(0.70, 0.50), Offset(0.68, 0.36), Offset(0.78, 0.36), Offset(0.76, 0.50)],
          isClosed: true,
          partName: 'Cerobong',
        ),
        // Awan Asap
        makeCircleSegment(const Offset(0.73, 0.28), 0.05),
        makeCircleSegment(const Offset(0.66, 0.20), 0.07),
        // Roda Belakang Besar & Roda Depan Kecil
        makeCircleSegment(const Offset(0.30, 0.72), 0.11),
        makeCircleSegment(const Offset(0.55, 0.72), 0.08),
        makeCircleSegment(const Offset(0.75, 0.72), 0.08),
      ],
    ),

    // 5. Pesawat Terbang
    CanvasTemplateModel(
      id: 'kendaraan_pesawat',
      title: 'Pesawat',
      subtitle: 'Pesawat terbang di angkasa',
      category: 'kendaraan',
      emoji: '✈️',
      segments: [
        // Bodi Pesawat
        makeOvalSegment(const Offset(0.50, 0.50), 0.38, 0.10, partName: 'Bodi Pesawat'),
        // Sayap Atas
        const TemplateSegment(
          points: [Offset(0.42, 0.42), Offset(0.55, 0.18), Offset(0.68, 0.18), Offset(0.58, 0.42)],
          isClosed: true,
          partName: 'Sayap Atas',
        ),
        // Sayap Bawah
        const TemplateSegment(
          points: [Offset(0.42, 0.58), Offset(0.55, 0.82), Offset(0.68, 0.82), Offset(0.58, 0.58)],
          isClosed: true,
          partName: 'Sayap Bawah',
        ),
        // Ekor Pesawat
        const TemplateSegment(
          points: [Offset(0.14, 0.48), Offset(0.10, 0.30), Offset(0.20, 0.30), Offset(0.25, 0.48)],
          isClosed: true,
          partName: 'Ekor',
        ),
        // Jendela Baris Bulat
        makeCircleSegment(const Offset(0.48, 0.50), 0.025),
        makeCircleSegment(const Offset(0.58, 0.50), 0.025),
        makeCircleSegment(const Offset(0.68, 0.50), 0.025),
      ],
    ),

    // 6. Helikopter
    CanvasTemplateModel(
      id: 'kendaraan_helikopter',
      title: 'Helikopter',
      subtitle: 'Helikopter dengan baling-baling',
      category: 'kendaraan',
      emoji: '🚁',
      segments: [
        // Bodi Kabin Bulat Kapsul
        makeOvalSegment(const Offset(0.45, 0.50), 0.22, 0.16, partName: 'Kabin'),
        // Kaca Depan
        const TemplateSegment(
          points: [Offset(0.52, 0.38), Offset(0.64, 0.46), Offset(0.64, 0.56), Offset(0.52, 0.56), Offset(0.52, 0.38)],
          isClosed: true,
          partName: 'Kaca Depan',
        ),
        // Baling-Baling Atas
        const TemplateSegment(
          points: [Offset(0.45, 0.34), Offset(0.45, 0.25)],
          isClosed: false,
          partName: 'Tiang Baling-Baling',
        ),
        const TemplateSegment(
          points: [Offset(0.18, 0.25), Offset(0.72, 0.25)],
          isClosed: false,
          partName: 'Baling-Baling Utama',
        ),
        // Ekor & Baling-Baling Belakang
        const TemplateSegment(
          points: [Offset(0.23, 0.50), Offset(0.10, 0.50), Offset(0.10, 0.40)],
          isClosed: false,
          partName: 'Ekor Helikopter',
        ),
        makeCircleSegment(const Offset(0.10, 0.40), 0.05, partName: 'Baling Ekor'),
        // Kaki Pijakan / Skid
        const TemplateSegment(
          points: [Offset(0.35, 0.66), Offset(0.35, 0.74)],
          isClosed: false,
        ),
        const TemplateSegment(
          points: [Offset(0.55, 0.66), Offset(0.55, 0.74)],
          isClosed: false,
        ),
        const TemplateSegment(
          points: [Offset(0.24, 0.74), Offset(0.68, 0.74)],
          isClosed: false,
          partName: 'Pijakan Kaki',
        ),
      ],
    ),

    // 7. Kapal Layar
    CanvasTemplateModel(
      id: 'kendaraan_kapal',
      title: 'Kapal Layar',
      subtitle: 'Perahu berlayar di laut',
      category: 'kendaraan',
      emoji: '⛵',
      segments: [
        // Lambung Kapal
        const TemplateSegment(
          points: [
            Offset(0.15, 0.65),
            Offset(0.85, 0.65),
            Offset(0.75, 0.82),
            Offset(0.25, 0.82),
            Offset(0.15, 0.65),
          ],
          isClosed: true,
          partName: 'Lambung Kapal',
        ),
        // Tiang Layar Tengah
        const TemplateSegment(
          points: [Offset(0.50, 0.20), Offset(0.50, 0.65)],
          isClosed: false,
          partName: 'Tiang Layar',
        ),
        // Layar Utama Kanan
        const TemplateSegment(
          points: [Offset(0.52, 0.24), Offset(0.80, 0.60), Offset(0.52, 0.60), Offset(0.52, 0.24)],
          isClosed: true,
          partName: 'Layar Kanan',
        ),
        // Layar Kiri
        const TemplateSegment(
          points: [Offset(0.48, 0.28), Offset(0.26, 0.60), Offset(0.48, 0.60), Offset(0.48, 0.28)],
          isClosed: true,
          partName: 'Layar Kiri',
        ),
        // Ombak Air
        const TemplateSegment(
          points: [
            Offset(0.08, 0.86),
            Offset(0.22, 0.83),
            Offset(0.36, 0.86),
            Offset(0.50, 0.83),
            Offset(0.64, 0.86),
            Offset(0.78, 0.83),
            Offset(0.92, 0.86),
          ],
          isClosed: false,
          partName: 'Ombak Laut',
        ),
      ],
    ),

    // 8. Sepeda
    CanvasTemplateModel(
      id: 'kendaraan_sepeda',
      title: 'Sepeda',
      subtitle: 'Sepeda roda dua gowes',
      category: 'kendaraan',
      emoji: '🚲',
      segments: [
        // Dua Roda
        makeCircleSegment(const Offset(0.26, 0.66), 0.13, partName: 'Roda Belakang'),
        makeCircleSegment(const Offset(0.74, 0.66), 0.13, partName: 'Roda Depan'),
        // Rangka Segitiga Sepeda
        const TemplateSegment(
          points: [
            Offset(0.26, 0.66),
            Offset(0.46, 0.66), // Gir tengah
            Offset(0.64, 0.45), // Sambungan stang
            Offset(0.42, 0.45), // Sambungan sadel
            Offset(0.26, 0.66),
          ],
          isClosed: true,
          partName: 'Rangka Sepeda',
        ),
        const TemplateSegment(
          points: [Offset(0.46, 0.66), Offset(0.42, 0.45)],
          isClosed: false,
          partName: 'Pipa Tengah',
        ),
        // Garpu Depan ke Roda
        const TemplateSegment(
          points: [Offset(0.64, 0.45), Offset(0.74, 0.66)],
          isClosed: false,
        ),
        // Stang & Pegangan
        const TemplateSegment(
          points: [Offset(0.64, 0.45), Offset(0.64, 0.35), Offset(0.58, 0.33), Offset(0.68, 0.33)],
          isClosed: false,
          partName: 'Stang',
        ),
        // Sadel Sepeda
        const TemplateSegment(
          points: [Offset(0.36, 0.41), Offset(0.48, 0.41)],
          isClosed: false,
          partName: 'Sadel',
        ),
      ],
    ),

    // 9. Sepeda Motor (Skuter / Vespa)
    CanvasTemplateModel(
      id: 'kendaraan_motor',
      title: 'Motor Skuter',
      subtitle: 'Skuter imut brum brum',
      category: 'kendaraan',
      emoji: '🛵',
      segments: [
        // Bodi Belakang Bulat
        makeOvalSegment(const Offset(0.35, 0.60), 0.16, 0.11, partName: 'Bodi Belakang'),
        // Lantai Pijakan Kaki
        const TemplateSegment(
          points: [Offset(0.45, 0.66), Offset(0.60, 0.66), Offset(0.65, 0.50)],
          isClosed: false,
          partName: 'Pijakan',
        ),
        // Tameng Depan & Batang Stang
        const TemplateSegment(
          points: [Offset(0.60, 0.66), Offset(0.68, 0.44), Offset(0.66, 0.35)],
          isClosed: false,
          partName: 'Stang Depan',
        ),
        // Lampu Depan Bulat
        makeCircleSegment(const Offset(0.67, 0.33), 0.05, partName: 'Lampu Depan'),
        // Jok Dudukan
        const TemplateSegment(
          points: [Offset(0.24, 0.49), Offset(0.44, 0.49), Offset(0.42, 0.53), Offset(0.26, 0.53)],
          isClosed: true,
          partName: 'Jok',
        ),
        // 2 Roda
        makeCircleSegment(const Offset(0.28, 0.72), 0.09, partName: 'Roda Belakang'),
        makeCircleSegment(const Offset(0.68, 0.72), 0.09, partName: 'Roda Depan'),
      ],
    ),

    // 10. Roket Luar Angkasa
    CanvasTemplateModel(
      id: 'kendaraan_roket',
      title: 'Roket',
      subtitle: 'Roket terbang ke bintang',
      category: 'kendaraan',
      emoji: '🚀',
      segments: [
        // Bodi Roket Silinder Kerucut
        const TemplateSegment(
          points: [
            Offset(0.50, 0.12),
            Offset(0.66, 0.30),
            Offset(0.66, 0.70),
            Offset(0.34, 0.70),
            Offset(0.34, 0.30),
            Offset(0.50, 0.12),
          ],
          isClosed: true,
          partName: 'Bodi Roket',
        ),
        // Ujung Kepala Roket
        const TemplateSegment(
          points: [Offset(0.38, 0.28), Offset(0.62, 0.28)],
          isClosed: false,
        ),
        // Jendela Astronaut Bulat
        makeCircleSegment(const Offset(0.50, 0.42), 0.08, partName: 'Jendela'),
        makeCircleSegment(const Offset(0.50, 0.42), 0.05),
        // Sirip Kiri
        const TemplateSegment(
          points: [Offset(0.34, 0.52), Offset(0.18, 0.74), Offset(0.34, 0.70)],
          isClosed: true,
          partName: 'Sirip Kiri',
        ),
        // Sirip Kanan
        const TemplateSegment(
          points: [Offset(0.66, 0.52), Offset(0.82, 0.74), Offset(0.66, 0.70)],
          isClosed: true,
          partName: 'Sirip Kanan',
        ),
        // Api Peluncur Bawah
        const TemplateSegment(
          points: [
            Offset(0.40, 0.70),
            Offset(0.44, 0.86),
            Offset(0.50, 0.78),
            Offset(0.56, 0.86),
            Offset(0.60, 0.70),
          ],
          isClosed: true,
          partName: 'Api Roket',
        ),
      ],
    ),

    // =========================================================================
    // 🍎 BUAH-BUAHAN (10 Template)
    // =========================================================================

    // 1. Apel
    CanvasTemplateModel(
      id: 'buah_apel',
      title: 'Apel',
      subtitle: 'Apel merah manis',
      category: 'buah',
      emoji: '🍎',
      segments: [
        // Bentuk Apel Lengkung Khas
        const TemplateSegment(
          points: [
            Offset(0.50, 0.28),
            Offset(0.36, 0.24),
            Offset(0.22, 0.36),
            Offset(0.20, 0.56),
            Offset(0.26, 0.76),
            Offset(0.42, 0.84),
            Offset(0.50, 0.78),
            Offset(0.58, 0.84),
            Offset(0.74, 0.76),
            Offset(0.80, 0.56),
            Offset(0.78, 0.36),
            Offset(0.64, 0.24),
            Offset(0.50, 0.28),
          ],
          isClosed: true,
          partName: 'Buah Apel',
        ),
        // Tangkai Apel
        const TemplateSegment(
          points: [Offset(0.50, 0.28), Offset(0.52, 0.16), Offset(0.56, 0.14)],
          isClosed: false,
          partName: 'Tangkai',
        ),
        // Daun Apel
        const TemplateSegment(
          points: [
            Offset(0.52, 0.20),
            Offset(0.66, 0.14),
            Offset(0.72, 0.20),
            Offset(0.58, 0.22),
            Offset(0.52, 0.20),
          ],
          isClosed: true,
          partName: 'Daun',
        ),
      ],
    ),

    // 2. Pisang
    CanvasTemplateModel(
      id: 'buah_pisang',
      title: 'Pisang',
      subtitle: 'Pisang kuning bergizi',
      category: 'buah',
      emoji: '🍌',
      segments: [
        // Lengkungan Pisang
        const TemplateSegment(
          points: [
            Offset(0.22, 0.20), // Batang atas
            Offset(0.28, 0.22),
            Offset(0.48, 0.44),
            Offset(0.72, 0.68),
            Offset(0.84, 0.62), // Ujung bawah
            Offset(0.82, 0.70),
            Offset(0.64, 0.76),
            Offset(0.40, 0.64),
            Offset(0.22, 0.34),
            Offset(0.22, 0.20),
          ],
          isClosed: true,
          partName: 'Buah Pisang',
        ),
        // Garis Punggung Pisang
        const TemplateSegment(
          points: [Offset(0.26, 0.24), Offset(0.44, 0.54), Offset(0.78, 0.68)],
          isClosed: false,
          partName: 'Garis Tengah',
        ),
      ],
    ),

    // 3. Jeruk
    CanvasTemplateModel(
      id: 'buah_jeruk',
      title: 'Jeruk',
      subtitle: 'Jeruk segar kaya vitamin C',
      category: 'buah',
      emoji: '🍊',
      segments: [
        // Lingkaran Jeruk Sempurna
        makeCircleSegment(const Offset(0.50, 0.54), 0.32, partName: 'Buah Jeruk'),
        // Tangkai
        const TemplateSegment(
          points: [Offset(0.50, 0.22), Offset(0.50, 0.14)],
          isClosed: false,
          partName: 'Tangkai',
        ),
        // 2 Daun di Tangkai
        const TemplateSegment(
          points: [Offset(0.50, 0.18), Offset(0.66, 0.12), Offset(0.68, 0.22), Offset(0.50, 0.20)],
          isClosed: true,
          partName: 'Daun Kanan',
        ),
        const TemplateSegment(
          points: [Offset(0.50, 0.18), Offset(0.34, 0.14), Offset(0.32, 0.22), Offset(0.50, 0.20)],
          isClosed: true,
          partName: 'Daun Kiri',
        ),
      ],
    ),

    // 4. Semangka (Potongan Semangka)
    CanvasTemplateModel(
      id: 'buah_semangka',
      title: 'Semangka',
      subtitle: 'Semangka segar manis',
      category: 'buah',
      emoji: '🍉',
      segments: [
        // Lengkungan Kulit Luar Hijau
        const TemplateSegment(
          points: [
            Offset(0.15, 0.40),
            Offset(0.25, 0.66),
            Offset(0.50, 0.82),
            Offset(0.75, 0.66),
            Offset(0.85, 0.40),
            Offset(0.15, 0.40),
          ],
          isClosed: true,
          partName: 'Kulit Semangka',
        ),
        // Lapisan Daging Merah
        const TemplateSegment(
          points: [
            Offset(0.20, 0.42),
            Offset(0.30, 0.62),
            Offset(0.50, 0.74),
            Offset(0.70, 0.62),
            Offset(0.80, 0.42),
            Offset(0.20, 0.42),
          ],
          isClosed: true,
          partName: 'Daging Merah',
        ),
        // Biji-biji Semangka
        makeCircleSegment(const Offset(0.36, 0.50), 0.02, steps: 12),
        makeCircleSegment(const Offset(0.50, 0.54), 0.02, steps: 12),
        makeCircleSegment(const Offset(0.64, 0.50), 0.02, steps: 12),
        makeCircleSegment(const Offset(0.42, 0.62), 0.02, steps: 12),
        makeCircleSegment(const Offset(0.58, 0.62), 0.02, steps: 12),
      ],
    ),

    // 5. Stroberi
    CanvasTemplateModel(
      id: 'buah_stroberi',
      title: 'Stroberi',
      subtitle: 'Stroberi merah berbintik',
      category: 'buah',
      emoji: '🍓',
      segments: [
        // Bodi Stroberi Bentuk Hati Tumpul
        const TemplateSegment(
          points: [
            Offset(0.50, 0.32),
            Offset(0.34, 0.32),
            Offset(0.24, 0.48),
            Offset(0.32, 0.70),
            Offset(0.50, 0.85),
            Offset(0.68, 0.70),
            Offset(0.76, 0.48),
            Offset(0.66, 0.32),
            Offset(0.50, 0.32),
          ],
          isClosed: true,
          partName: 'Buah Stroberi',
        ),
        // Mahkota Daun Zig-zag di Atas
        const TemplateSegment(
          points: [
            Offset(0.26, 0.30),
            Offset(0.38, 0.36),
            Offset(0.42, 0.22),
            Offset(0.50, 0.36),
            Offset(0.58, 0.22),
            Offset(0.62, 0.36),
            Offset(0.74, 0.30),
            Offset(0.50, 0.34),
            Offset(0.26, 0.30),
          ],
          isClosed: true,
          partName: 'Mahkota Daun',
        ),
        // Tangkai Kecil
        const TemplateSegment(
          points: [Offset(0.50, 0.26), Offset(0.50, 0.16)],
          isClosed: false,
        ),
        // Bintik Biji Stroberi
        makeCircleSegment(const Offset(0.40, 0.48), 0.015, steps: 8),
        makeCircleSegment(const Offset(0.60, 0.48), 0.015, steps: 8),
        makeCircleSegment(const Offset(0.50, 0.58), 0.015, steps: 8),
        makeCircleSegment(const Offset(0.42, 0.68), 0.015, steps: 8),
        makeCircleSegment(const Offset(0.58, 0.68), 0.015, steps: 8),
      ],
    ),

    // 6. Anggur
    CanvasTemplateModel(
      id: 'buah_anggur',
      title: 'Anggur',
      subtitle: 'Gugusan buah anggur ungu',
      category: 'buah',
      emoji: '🍇',
      segments: [
        // Tangkai & Daun
        const TemplateSegment(
          points: [Offset(0.50, 0.15), Offset(0.50, 0.28)],
          isClosed: false,
          partName: 'Tangkai',
        ),
        const TemplateSegment(
          points: [Offset(0.50, 0.20), Offset(0.66, 0.16), Offset(0.62, 0.26), Offset(0.50, 0.22)],
          isClosed: true,
          partName: 'Daun',
        ),
        // Baris 1 (Paling Atas: 3 Biji)
        makeCircleSegment(const Offset(0.36, 0.36), 0.08),
        makeCircleSegment(const Offset(0.50, 0.36), 0.08),
        makeCircleSegment(const Offset(0.64, 0.36), 0.08),
        // Baris 2 (Tengah: 3 Biji)
        makeCircleSegment(const Offset(0.32, 0.50), 0.08),
        makeCircleSegment(const Offset(0.50, 0.50), 0.08),
        makeCircleSegment(const Offset(0.68, 0.50), 0.08),
        // Baris 3 (Bawah: 2 Biji)
        makeCircleSegment(const Offset(0.42, 0.64), 0.08),
        makeCircleSegment(const Offset(0.58, 0.64), 0.08),
        // Baris 4 (Ujung: 1 Biji)
        makeCircleSegment(const Offset(0.50, 0.77), 0.08),
      ],
    ),

    // 7. Nanas
    CanvasTemplateModel(
      id: 'buah_nanas',
      title: 'Nanas',
      subtitle: 'Nanas mahkota berduri',
      category: 'buah',
      emoji: '🍍',
      segments: [
        // Badan Nanas Lonjong
        makeOvalSegment(const Offset(0.50, 0.60), 0.24, 0.26, partName: 'Buah Nanas'),
        // Mahkota Daun Atas Tajam
        const TemplateSegment(
          points: [
            Offset(0.40, 0.38),
            Offset(0.30, 0.18),
            Offset(0.42, 0.24),
            Offset(0.50, 0.10),
            Offset(0.58, 0.24),
            Offset(0.70, 0.18),
            Offset(0.60, 0.38),
          ],
          isClosed: true,
          partName: 'Daun Mahkota',
        ),
        // Garis Anyaman / Grid Silang Nanas
        const TemplateSegment(points: [Offset(0.32, 0.48), Offset(0.68, 0.72)], isClosed: false),
        const TemplateSegment(points: [Offset(0.28, 0.60), Offset(0.60, 0.82)], isClosed: false),
        const TemplateSegment(points: [Offset(0.68, 0.48), Offset(0.32, 0.72)], isClosed: false),
        const TemplateSegment(points: [Offset(0.72, 0.60), Offset(0.40, 0.82)], isClosed: false),
      ],
    ),

    // 8. Mangga
    CanvasTemplateModel(
      id: 'buah_mangga',
      title: 'Mangga',
      subtitle: 'Mangga manis harum',
      category: 'buah',
      emoji: '🥭',
      segments: [
        // Bodi Mangga Asimetris Khas
        const TemplateSegment(
          points: [
            Offset(0.50, 0.24),
            Offset(0.36, 0.26),
            Offset(0.24, 0.40),
            Offset(0.24, 0.62),
            Offset(0.38, 0.80),
            Offset(0.56, 0.84),
            Offset(0.74, 0.74),
            Offset(0.78, 0.54),
            Offset(0.68, 0.34),
            Offset(0.50, 0.24),
          ],
          isClosed: true,
          partName: 'Buah Mangga',
        ),
        // Tangkai
        const TemplateSegment(
          points: [Offset(0.50, 0.24), Offset(0.48, 0.14)],
          isClosed: false,
          partName: 'Tangkai',
        ),
        // Daun Mangga Lonjong
        const TemplateSegment(
          points: [Offset(0.48, 0.18), Offset(0.34, 0.12), Offset(0.28, 0.18), Offset(0.44, 0.22), Offset(0.48, 0.18)],
          isClosed: true,
          partName: 'Daun',
        ),
      ],
    ),

    // 9. Alpukat
    CanvasTemplateModel(
      id: 'buah_alpukat',
      title: 'Alpukat',
      subtitle: 'Alpukat lembut kaya nutrisi',
      category: 'buah',
      emoji: '🥑',
      segments: [
        // Kulit Luar Buah Alpukat Terbelah
        const TemplateSegment(
          points: [
            Offset(0.50, 0.18),
            Offset(0.38, 0.24),
            Offset(0.34, 0.40),
            Offset(0.22, 0.56),
            Offset(0.24, 0.76),
            Offset(0.38, 0.86),
            Offset(0.50, 0.88),
            Offset(0.62, 0.86),
            Offset(0.76, 0.76),
            Offset(0.78, 0.56),
            Offset(0.66, 0.40),
            Offset(0.62, 0.24),
            Offset(0.50, 0.18),
          ],
          isClosed: true,
          partName: 'Kulit Luar',
        ),
        // Lapisan Daging Dalam
        const TemplateSegment(
          points: [
            Offset(0.50, 0.24),
            Offset(0.40, 0.30),
            Offset(0.38, 0.42),
            Offset(0.28, 0.56),
            Offset(0.30, 0.72),
            Offset(0.42, 0.80),
            Offset(0.50, 0.82),
            Offset(0.58, 0.80),
            Offset(0.70, 0.72),
            Offset(0.72, 0.56),
            Offset(0.62, 0.42),
            Offset(0.60, 0.30),
            Offset(0.50, 0.24),
          ],
          isClosed: true,
          partName: 'Daging Alpukat',
        ),
        // Biji Bulat Besar di Tengah
        makeCircleSegment(const Offset(0.50, 0.65), 0.12, partName: 'Biji Alpukat'),
      ],
    ),

    // 10. Ceri
    CanvasTemplateModel(
      id: 'buah_ceri',
      title: 'Ceri',
      subtitle: 'Dua buah ceri merah kembar',
      category: 'buah',
      emoji: '🍒',
      segments: [
        // 2 Buah Ceri Bulat
        makeCircleSegment(const Offset(0.34, 0.68), 0.13, partName: 'Ceri Kiri'),
        makeCircleSegment(const Offset(0.66, 0.68), 0.13, partName: 'Ceri Kanan'),
        // Tangkai Lengkung Menghubungkan Keduanya
        const TemplateSegment(
          points: [Offset(0.34, 0.56), Offset(0.42, 0.36), Offset(0.50, 0.22)],
          isClosed: false,
          partName: 'Tangkai Kiri',
        ),
        const TemplateSegment(
          points: [Offset(0.66, 0.56), Offset(0.58, 0.36), Offset(0.50, 0.22)],
          isClosed: false,
          partName: 'Tangkai Kanan',
        ),
        // Daun Kembar di Pucuk Tangkai
        const TemplateSegment(
          points: [Offset(0.50, 0.22), Offset(0.68, 0.16), Offset(0.72, 0.26), Offset(0.50, 0.24)],
          isClosed: true,
          partName: 'Daun',
        ),
      ],
    ),

    // =========================================================================
    // 🧸 BENDA SEHARI-HARI (10 Template)
    // =========================================================================

    // 1. Rumah
    CanvasTemplateModel(
      id: 'benda_rumah',
      title: 'Rumah',
      subtitle: 'Rumah tempat tinggal kita',
      category: 'benda',
      emoji: '🏠',
      segments: [
        // Atap Segitiga
        const TemplateSegment(
          points: [Offset(0.50, 0.18), Offset(0.85, 0.44), Offset(0.15, 0.44), Offset(0.50, 0.18)],
          isClosed: true,
          partName: 'Atap Rumah',
        ),
        // Cerobong Asap
        const TemplateSegment(
          points: [Offset(0.70, 0.25), Offset(0.70, 0.16), Offset(0.78, 0.16), Offset(0.78, 0.32)],
          isClosed: true,
          partName: 'Cerobong',
        ),
        // Dinding Kotak
        const TemplateSegment(
          points: [Offset(0.22, 0.44), Offset(0.78, 0.44), Offset(0.78, 0.82), Offset(0.22, 0.82), Offset(0.22, 0.44)],
          isClosed: true,
          partName: 'Dinding',
        ),
        // Pintu
        const TemplateSegment(
          points: [Offset(0.42, 0.56), Offset(0.58, 0.56), Offset(0.58, 0.82), Offset(0.42, 0.82), Offset(0.42, 0.56)],
          isClosed: true,
          partName: 'Pintu',
        ),
        makeCircleSegment(const Offset(0.54, 0.70), 0.015, steps: 8, partName: 'Gagang Pintu'),
        // Jendela Kiri
        const TemplateSegment(
          points: [Offset(0.28, 0.52), Offset(0.38, 0.52), Offset(0.38, 0.64), Offset(0.28, 0.64), Offset(0.28, 0.52)],
          isClosed: true,
          partName: 'Jendela Kiri',
        ),
        // Jendela Kanan
        const TemplateSegment(
          points: [Offset(0.62, 0.52), Offset(0.72, 0.52), Offset(0.72, 0.64), Offset(0.62, 0.64), Offset(0.62, 0.52)],
          isClosed: true,
          partName: 'Jendela Kanan',
        ),
      ],
    ),

    // 2. Jam Dinding / Beker
    CanvasTemplateModel(
      id: 'benda_jam',
      title: 'Jam Weker',
      subtitle: 'Jam penunjuk waktu',
      category: 'benda',
      emoji: '⏰',
      segments: [
        // Lingkaran Jam
        makeCircleSegment(const Offset(0.50, 0.52), 0.28, partName: 'Badan Jam'),
        makeCircleSegment(const Offset(0.50, 0.52), 0.22, partName: 'Muka Jam'),
        // 2 Lonceng Atas
        const TemplateSegment(
          points: [Offset(0.28, 0.28), Offset(0.22, 0.36), Offset(0.34, 0.38)],
          isClosed: true,
          partName: 'Lonceng Kiri',
        ),
        const TemplateSegment(
          points: [Offset(0.72, 0.28), Offset(0.78, 0.36), Offset(0.66, 0.38)],
          isClosed: true,
          partName: 'Lonceng Kanan',
        ),
        // 2 Kaki Penopang
        const TemplateSegment(points: [Offset(0.32, 0.76), Offset(0.24, 0.86)], isClosed: false),
        const TemplateSegment(points: [Offset(0.68, 0.76), Offset(0.76, 0.86)], isClosed: false),
        // Jarum Pendek & Jarum Panjang
        const TemplateSegment(points: [Offset(0.50, 0.52), Offset(0.50, 0.36)], isClosed: false, partName: 'Jarum Panjang'),
        const TemplateSegment(points: [Offset(0.50, 0.52), Offset(0.62, 0.52)], isClosed: false, partName: 'Jarum Pendek'),
      ],
    ),

    // 3. Baju / Kaos
    CanvasTemplateModel(
      id: 'benda_baju',
      title: 'Baju Kaos',
      subtitle: 'Baju yang nyaman dipakai',
      category: 'benda',
      emoji: '👕',
      segments: [
        // Pola Kaos Lengkap
        const TemplateSegment(
          points: [
            Offset(0.42, 0.22), // Kerah leher kiri
            Offset(0.50, 0.28), // Lengkung leher tengah
            Offset(0.58, 0.22), // Kerah leher kanan
            Offset(0.80, 0.28), // Bahu kanan
            Offset(0.86, 0.44), // Ujung lengan kanan luar
            Offset(0.72, 0.48), // Ujung lengan kanan bawah
            Offset(0.70, 0.40), // Ketiak kanan
            Offset(0.70, 0.80), // Bawah kanan
            Offset(0.30, 0.80), // Bawah kiri
            Offset(0.30, 0.40), // Ketiak kiri
            Offset(0.28, 0.48), // Ujung lengan kiri bawah
            Offset(0.14, 0.44), // Ujung lengan kiri luar
            Offset(0.20, 0.28), // Bahu kiri
            Offset(0.42, 0.22),
          ],
          isClosed: true,
          partName: 'Baju Kaos',
        ),
        // Garis Kerah Lingkar
        const TemplateSegment(
          points: [Offset(0.42, 0.22), Offset(0.50, 0.28), Offset(0.58, 0.22)],
          isClosed: false,
          partName: 'Kerah',
        ),
      ],
    ),

    // 4. Sepatu
    CanvasTemplateModel(
      id: 'benda_sepatu',
      title: 'Sepatu',
      subtitle: 'Sepatu untuk berjalan & berlari',
      category: 'benda',
      emoji: '👟',
      segments: [
        // Bodi Sepatu
        const TemplateSegment(
          points: [
            Offset(0.20, 0.42),
            Offset(0.36, 0.42),
            Offset(0.48, 0.52),
            Offset(0.76, 0.60),
            Offset(0.86, 0.66),
            Offset(0.86, 0.76),
            Offset(0.16, 0.76),
            Offset(0.16, 0.52),
            Offset(0.20, 0.42),
          ],
          isClosed: true,
          partName: 'Bodi Sepatu',
        ),
        // Sol Bawah Sepatu
        const TemplateSegment(
          points: [Offset(0.16, 0.76), Offset(0.86, 0.76), Offset(0.86, 0.84), Offset(0.16, 0.84), Offset(0.16, 0.76)],
          isClosed: true,
          partName: 'Sol Sepatu',
        ),
        // Tali Sepatu Silang
        const TemplateSegment(points: [Offset(0.38, 0.48), Offset(0.48, 0.54)], isClosed: false),
        const TemplateSegment(points: [Offset(0.42, 0.54), Offset(0.52, 0.60)], isClosed: false),
      ],
    ),

    // 5. Payung
    CanvasTemplateModel(
      id: 'benda_payung',
      title: 'Payung',
      subtitle: 'Payung pelindung hujan',
      category: 'benda',
      emoji: '☂️',
      segments: [
        // Kubah Payung Atas
        const TemplateSegment(
          points: [
            Offset(0.12, 0.52),
            Offset(0.24, 0.32),
            Offset(0.50, 0.20),
            Offset(0.76, 0.32),
            Offset(0.88, 0.52),
            // Gelombang Scalloped Bawah Payung
            Offset(0.74, 0.48),
            Offset(0.62, 0.52),
            Offset(0.50, 0.48),
            Offset(0.38, 0.52),
            Offset(0.26, 0.48),
            Offset(0.12, 0.52),
          ],
          isClosed: true,
          partName: 'Kubah Payung',
        ),
        // Ujung Runcing Atas
        const TemplateSegment(points: [Offset(0.50, 0.20), Offset(0.50, 0.14)], isClosed: false),
        // Gagang Payung Huruf J
        const TemplateSegment(
          points: [
            Offset(0.50, 0.48),
            Offset(0.50, 0.80),
            Offset(0.44, 0.86),
            Offset(0.38, 0.80),
          ],
          isClosed: false,
          partName: 'Gagang Payung',
        ),
      ],
    ),

    // 6. Gelas / Cangkir
    CanvasTemplateModel(
      id: 'benda_gelas',
      title: 'Cangkir Susu',
      subtitle: 'Gelas cangkir tempat minum',
      category: 'benda',
      emoji: '🥛',
      segments: [
        // Badan Silinder Cangkir
        const TemplateSegment(
          points: [
            Offset(0.28, 0.34),
            Offset(0.72, 0.34),
            Offset(0.68, 0.78),
            Offset(0.32, 0.78),
            Offset(0.28, 0.34),
          ],
          isClosed: true,
          partName: 'Badan Cangkir',
        ),
        // Bibir Gelas Elips
        makeOvalSegment(const Offset(0.50, 0.34), 0.22, 0.05, partName: 'Bibir Gelas'),
        // Telinga Pegangan Samping
        const TemplateSegment(
          points: [
            Offset(0.71, 0.42),
            Offset(0.84, 0.44),
            Offset(0.84, 0.66),
            Offset(0.69, 0.68),
          ],
          isClosed: false,
          partName: 'Gagang',
        ),
        // Uap Hangat di Atas
        const TemplateSegment(
          points: [Offset(0.44, 0.26), Offset(0.42, 0.18), Offset(0.46, 0.12)],
          isClosed: false,
          partName: 'Uap Hangat',
        ),
        const TemplateSegment(
          points: [Offset(0.56, 0.26), Offset(0.54, 0.18), Offset(0.58, 0.12)],
          isClosed: false,
        ),
      ],
    ),

    // 7. Buku Terbuka
    CanvasTemplateModel(
      id: 'benda_buku',
      title: 'Buku',
      subtitle: 'Buku bacaan jendela ilmu',
      category: 'benda',
      emoji: '📖',
      segments: [
        // Halaman Kiri
        const TemplateSegment(
          points: [
            Offset(0.50, 0.34),
            Offset(0.18, 0.30),
            Offset(0.16, 0.72),
            Offset(0.50, 0.76),
            Offset(0.50, 0.34),
          ],
          isClosed: true,
          partName: 'Halaman Kiri',
        ),
        // Halaman Kanan
        const TemplateSegment(
          points: [
            Offset(0.50, 0.34),
            Offset(0.82, 0.30),
            Offset(0.84, 0.72),
            Offset(0.50, 0.76),
            Offset(0.50, 0.34),
          ],
          isClosed: true,
          partName: 'Halaman Kanan',
        ),
        // Garis-garis Tulisan Kiri
        const TemplateSegment(points: [Offset(0.24, 0.42), Offset(0.44, 0.44)], isClosed: false),
        const TemplateSegment(points: [Offset(0.24, 0.52), Offset(0.44, 0.54)], isClosed: false),
        const TemplateSegment(points: [Offset(0.24, 0.62), Offset(0.44, 0.64)], isClosed: false),
        // Garis-garis Tulisan Kanan
        const TemplateSegment(points: [Offset(0.56, 0.44), Offset(0.76, 0.42)], isClosed: false),
        const TemplateSegment(points: [Offset(0.56, 0.54), Offset(0.76, 0.52)], isClosed: false),
        const TemplateSegment(points: [Offset(0.56, 0.64), Offset(0.76, 0.62)], isClosed: false),
      ],
    ),

    // 8. Topi (Topi Biasa / Baseball Cap)
    CanvasTemplateModel(
      id: 'benda_topi',
      title: 'Topi',
      subtitle: 'Topi santai pelindung matahari',
      category: 'benda',
      emoji: '🧢',
      segments: [
        // Kubah Topi Melengkung
        const TemplateSegment(
          points: [
            Offset(0.20, 0.60),
            Offset(0.26, 0.38),
            Offset(0.45, 0.28),
            Offset(0.65, 0.34),
            Offset(0.75, 0.56),
            Offset(0.20, 0.60),
          ],
          isClosed: true,
          partName: 'Kubah Topi',
        ),
        // Lidah Topi (Visor) Melengkung ke Kanan
        const TemplateSegment(
          points: [
            Offset(0.72, 0.52),
            Offset(0.92, 0.56),
            Offset(0.88, 0.66),
            Offset(0.66, 0.64),
          ],
          isClosed: true,
          partName: 'Lidah Topi',
        ),
        // Kancing Kecil di Puncak Topi
        makeCircleSegment(const Offset(0.45, 0.27), 0.025, steps: 12, partName: 'Kancing Puncak'),
        // Garis Panel Jahitan Topi
        const TemplateSegment(
          points: [Offset(0.45, 0.28), Offset(0.46, 0.60)],
          isClosed: false,
          partName: 'Jahitan Tengah',
        ),
      ],
    ),

    // 9. Lampu Belajar
    CanvasTemplateModel(
      id: 'benda_lampu',
      title: 'Lampu Belajar',
      subtitle: 'Lampu penerang saat belajar',
      category: 'benda',
      emoji: '💡',
      segments: [
        // Kap Tudung Lampu (Trapesium Miring)
        const TemplateSegment(
          points: [
            Offset(0.38, 0.20),
            Offset(0.56, 0.24),
            Offset(0.64, 0.40),
            Offset(0.34, 0.36),
            Offset(0.38, 0.20),
          ],
          isClosed: true,
          partName: 'Tudung Lampu',
        ),
        // Bohlam Lampu Bersinar
        makeCircleSegment(const Offset(0.48, 0.38), 0.06, partName: 'Bohlam'),
        // Leher Lampu Melengkung
        const TemplateSegment(
          points: [
            Offset(0.46, 0.22),
            Offset(0.36, 0.38),
            Offset(0.36, 0.68),
            Offset(0.45, 0.76),
          ],
          isClosed: false,
          partName: 'Leher Lampu',
        ),
        // Pijakan Alas Meja Oval
        makeOvalSegment(const Offset(0.50, 0.80), 0.20, 0.06, partName: 'Alas Meja'),
      ],
    ),

    // 10. Tas Ransel Sekolah
    CanvasTemplateModel(
      id: 'benda_tas',
      title: 'Tas Ransel',
      subtitle: 'Tas untuk membawa buku sekolah',
      category: 'benda',
      emoji: '🎒',
      segments: [
        // Bodi Ransel Tinggi Membulat
        const TemplateSegment(
          points: [
            Offset(0.24, 0.80),
            Offset(0.24, 0.44),
            Offset(0.36, 0.26),
            Offset(0.64, 0.26),
            Offset(0.76, 0.44),
            Offset(0.76, 0.80),
            Offset(0.24, 0.80),
          ],
          isClosed: true,
          partName: 'Bodi Ransel',
        ),
        // Pegangan Jinjing di Atas
        const TemplateSegment(
          points: [Offset(0.40, 0.26), Offset(0.40, 0.18), Offset(0.60, 0.18), Offset(0.60, 0.26)],
          isClosed: false,
          partName: 'Pegangan Atas',
        ),
        // Kantong Depan Beritsleting
        const TemplateSegment(
          points: [
            Offset(0.32, 0.54),
            Offset(0.68, 0.54),
            Offset(0.68, 0.78),
            Offset(0.32, 0.78),
            Offset(0.32, 0.54),
          ],
          isClosed: true,
          partName: 'Kantong Depan',
        ),
        // Garis Resleting Kantong
        const TemplateSegment(points: [Offset(0.36, 0.60), Offset(0.64, 0.60)], isClosed: false),
      ],
    ),
  ];
}
