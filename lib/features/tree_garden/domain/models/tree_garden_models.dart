import 'package:flutter/material.dart';

enum TreeGrowthStage {
  seed,      // Tahap 1: Menanam Biji di Pot
  watering,  // Tahap 2: Menyiram Air dengan Teko
  sunlight,  // Tahap 3: Memberi Sinar Matahari Hangat
  blooming,  // Pohon tumbuh & bunga bermekaran
  harvest,   // Tahap 4: Buah matang siap dipetik!
  completed, // Semua buah sudah dipetik ke keranjang
}

class TreeProfile {
  final String id;
  final String name;
  final String fruitEmoji;
  final String seedEmoji;
  final Color primaryColor;
  final Color lightBgColor;
  final String fruitName;
  final int fruitCount;
  final List<String> growthCues;

  const TreeProfile({
    required this.id,
    required this.name,
    required this.fruitEmoji,
    required this.seedEmoji,
    required this.primaryColor,
    required this.lightBgColor,
    required this.fruitName,
    this.fruitCount = 5,
    required this.growthCues,
  });
}

class TreeGardenRepository {
  static const List<TreeProfile> trees = [
    TreeProfile(
      id: 'apple',
      name: 'Pohon Apel Merah',
      fruitEmoji: '🍎',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFEF4444),
      lightBgColor: Color(0xFFFEF2F2),
      fruitName: 'Apel',
      growthCues: [
        'Ayo masukkan biji apel ke dalam pot tanah!',
        'Siram tanah dengan air segar agar bertunas!',
        'Beri sinar matahari hangat agar pohonnya tumbuh tinggi!',
        'Hore! Petik semua apel merah yang manis!',
      ],
    ),
    TreeProfile(
      id: 'orange',
      name: 'Pohon Jeruk Manis',
      fruitEmoji: '🍊',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFF97316),
      lightBgColor: Color(0xFFFFF7ED),
      fruitName: 'Jeruk',
      growthCues: [
        'Tanam biji jeruk ke tanah gembur!',
        'Kucurkan air segar dari teko siram!',
        'Sinar matahari membuat pohon jeruk berbunga harum!',
        'Petik buah jeruk segar yang kaya vitamin!',
      ],
    ),
    TreeProfile(
      id: 'banana',
      name: 'Pohon Pisang Emas',
      fruitEmoji: '🍌',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFEAB308),
      lightBgColor: Color(0xFFFEFCE8),
      fruitName: 'Pisang',
      growthCues: [
        'Tanam bibit pohon pisang ke dalam pot!',
        'Siram bibit dengan air agar daunnya mulai tumbuh!',
        'Matahari bersinar membuat jantung pisang mekar!',
        'Wah pisang emasnya sudah matang, yuk petik!',
      ],
    ),
    TreeProfile(
      id: 'strawberry',
      name: 'Kebun Stroberi',
      fruitEmoji: '🍓',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFF43F5E),
      lightBgColor: Color(0xFFFFF1F2),
      fruitName: 'Stroberi',
      growthCues: [
        'Tanam benih stroberi di tanah kebun!',
        'Siram lembut agar tanahnya basah dan subur!',
        'Hangatkan dengan sinar matahari yang cerah!',
        'Yummy! Petik stroberi merah manis ke keranjang!',
      ],
    ),
  ];
}
