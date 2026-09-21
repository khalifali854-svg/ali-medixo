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
    TreeProfile(
      id: 'mango',
      name: 'Pohon Mangga Manis',
      fruitEmoji: '🥭',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFF59E0B),
      lightBgColor: Color(0xFFFFFBEB),
      fruitName: 'Mangga',
      growthCues: [
        'Tanam biji mangga harum ke dalam pot!',
        'Siram air agar akar mangga tumbuh kuat!',
        'Matahari cerah membuat bunga mangga bermekaran!',
        'Petik buah mangga harum manis yang ranum!',
      ],
    ),
    TreeProfile(
      id: 'watermelon',
      name: 'Kebun Semangka',
      fruitEmoji: '🍉',
      seedEmoji: '🌰',
      primaryColor: Color(0xFF10B981),
      lightBgColor: Color(0xFFECFDF5),
      fruitName: 'Semangka',
      growthCues: [
        'Tanam biji semangka ke tanah gembur!',
        'Siram tanah agar sulur semangka merambat!',
        'Sinar hangat membesarkan semangka bulat segar!',
        'Wah semangkanya besar berair, ayo petik!',
      ],
    ),
    TreeProfile(
      id: 'grape',
      name: 'Pohon Anggur Ungu',
      fruitEmoji: '🍇',
      seedEmoji: '🌱',
      primaryColor: Color(0xFF8B5CF6),
      lightBgColor: Color(0xFFF5F3FF),
      fruitName: 'Anggur',
      growthCues: [
        'Tanam bibit anggur manis ke pot subur!',
        'Siram secukupnya agar sulur anggur memanjat!',
        'Sinar matahari membuat gerombolan buah anggur ungu!',
        'Petik anggur ungu yang manis dan segar!',
      ],
    ),
    TreeProfile(
      id: 'coconut',
      name: 'Pohon Kelapa Pantai',
      fruitEmoji: '🥥',
      seedEmoji: '🌰',
      primaryColor: Color(0xFF0D9488),
      lightBgColor: Color(0xFFF0FDFA),
      fruitName: 'Kelapa',
      growthCues: [
        'Tanam tunas kelapa di pot pasir pantai!',
        'Siram air segar agar tunasnya menjulang tinggi!',
        'Angin dan mentari mematangkan buah kelapa!',
        'Petik buah kelapa segar pelepas dahaga!',
      ],
    ),
    TreeProfile(
      id: 'avocado',
      name: 'Pohon Alpukat Gurih',
      fruitEmoji: '🥑',
      seedEmoji: '🌰',
      primaryColor: Color(0xFF15803D),
      lightBgColor: Color(0xFFF0FDF4),
      fruitName: 'Alpukat',
      growthCues: [
        'Tanam biji alpukat besar ke tanah subur!',
        'Siram agar akar dan batangnya tumbuh kokoh!',
        'Sinar mentari membuat alpukat hijau membesar!',
        'Petik alpukat mentega yang gurih dan bergizi!',
      ],
    ),
    TreeProfile(
      id: 'pineapple',
      name: 'Kebun Nanas Manis',
      fruitEmoji: '🍍',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFCA8A04),
      lightBgColor: Color(0xFFFEFCE8),
      fruitName: 'Nanas',
      growthCues: [
        'Tanam mahkota nanas ke tanah kebun!',
        'Siram air agar daun berduri nanas tumbuh subur!',
        'Mentari tropis mematangkan buah nanas kuning cerah!',
        'Petik nanas manis segar bermahkota!',
      ],
    ),
    TreeProfile(
      id: 'papaya',
      name: 'Pohon Pepaya Madu',
      fruitEmoji: '🍈',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFFB923C),
      lightBgColor: Color(0xFFFFF7ED),
      fruitName: 'Pepaya',
      growthCues: [
        'Tanam biji pepaya hitam ke tanah basah!',
        'Siram teratur agar batangnya tinggi semampai!',
        'Bunga pepaya harum berubah jadi buah panjang!',
        'Petik buah pepaya madu yang kaya vitamin!',
      ],
    ),
    TreeProfile(
      id: 'cherry',
      name: 'Pohon Ceri Merah',
      fruitEmoji: '🍒',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFE11D48),
      lightBgColor: Color(0xFFFFF1F2),
      fruitName: 'Ceri',
      growthCues: [
        'Tanam biji ceri mungil ke pot tanaman!',
        'Siram lembut agar pohon ceri tumbuh rimbun!',
        'Bunga merah muda mekar indah disinari mentari!',
        'Petik buah ceri merah berkilau seperti permata!',
      ],
    ),
    TreeProfile(
      id: 'peach',
      name: 'Pohon Persik Merona',
      fruitEmoji: '🍑',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFF472B6),
      lightBgColor: Color(0xFFFDF2F8),
      fruitName: 'Persik',
      growthCues: [
        'Tanam biji persik di tanah gembur bernutrisi!',
        'Siram air agar kuncup persik mulai merekah!',
        'Sinar hangat membuat kulit buah persik merona merah muda!',
        'Petik buah persik lembut yang manis beraroma!',
      ],
    ),
    TreeProfile(
      id: 'pear',
      name: 'Pohon Pir Hijau',
      fruitEmoji: '🍐',
      seedEmoji: '🌰',
      primaryColor: Color(0xFF65A30D),
      lightBgColor: Color(0xFFF7FEE7),
      fruitName: 'Pir',
      growthCues: [
        'Tanam bibit pohon pir ke dalam pot!',
        'Siram air segar agar daun hijau pir rimbun!',
        'Mentari musim panas mematangkan buah pir renyah!',
        'Petik buah pir manis berair yang segar!',
      ],
    ),
    TreeProfile(
      id: 'lemon',
      name: 'Pohon Lemon Segar',
      fruitEmoji: '🍋',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFFACC15),
      lightBgColor: Color(0xFFFEFCE8),
      fruitName: 'Lemon',
      growthCues: [
        'Tanam biji lemon kuning ke pot kebun!',
        'Siram air agar daunnya menebarkan aroma citrus!',
        'Sinar matahari membuat buah lemon menguning cerah!',
        'Petik buah lemon segar kaya vitamin C!',
      ],
    ),
    TreeProfile(
      id: 'melon',
      name: 'Kebun Melon Wangi',
      fruitEmoji: '🍈',
      seedEmoji: '🌱',
      primaryColor: Color(0xFF84CC16),
      lightBgColor: Color(0xFFF7FEE7),
      fruitName: 'Melon',
      growthCues: [
        'Tanam benih melon hijau ke tanah subur!',
        'Siram tanah agar batang merambat dengan kokoh!',
        'Mentari hangat membuat melon bulat menebarkan wangi harum!',
        'Petik buah melon manis berair ke keranjang!',
      ],
    ),
    TreeProfile(
      id: 'blueberry',
      name: 'Kebun Bluberi Biru',
      fruitEmoji: '🫐',
      seedEmoji: '🌱',
      primaryColor: Color(0xFF3B82F6),
      lightBgColor: Color(0xFFEFF6FF),
      fruitName: 'Bluberi',
      growthCues: [
        'Tanam bibit semak bluberi ke tanah sejuk!',
        'Siram air agar tunas daun bluberi bertumbuh!',
        'Mentari pagi mengubah buah menjadi biru keunguan!',
        'Petik butiran buah bluberi manis dan sehat!',
      ],
    ),
    TreeProfile(
      id: 'kiwi',
      name: 'Pohon Kiwi Segar',
      fruitEmoji: '🥝',
      seedEmoji: '🌱',
      primaryColor: Color(0xFF4D7C0F),
      lightBgColor: Color(0xFFF7FEE7),
      fruitName: 'Kiwi',
      growthCues: [
        'Tanam bibit pohon kiwi di pot gembur!',
        'Siram teratur agar batang sulur kiwi memanjat!',
        'Sinar matahari membuat daging buah kiwi hijau segar!',
        'Petik buah kiwi segar yang kaya nutrisi!',
      ],
    ),
    TreeProfile(
      id: 'starfruit',
      name: 'Pohon Belimbing Bintang',
      fruitEmoji: '⭐',
      seedEmoji: '🌰',
      primaryColor: Color(0xFFEAB308),
      lightBgColor: Color(0xFFFEFCE8),
      fruitName: 'Belimbing',
      growthCues: [
        'Tanam biji pohon belimbing ke tanah basah!',
        'Siram dengan teko agar bunga merah mudanya mekar!',
        'Mentari tropis membentuk buah bersudut bintang lima!',
        'Petik belimbing bintang emas yang renyah berair!',
      ],
    ),
    TreeProfile(
      id: 'corn',
      name: 'Kebun Jagung Manis',
      fruitEmoji: '🌽',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFF59E0B),
      lightBgColor: Color(0xFFFFFBEB),
      fruitName: 'Jagung',
      growthCues: [
        'Tanam butir jagung emas ke dalam lubang tanah!',
        'Siram tanah gembur agar kecambah jagung bertunas!',
        'Sinar mentari membuat batang jagung tinggi berambut emas!',
        'Petik tongkol jagung manis yang gurih dan lezat!',
      ],
    ),
    TreeProfile(
      id: 'tomato',
      name: 'Pohon Tomat Merah',
      fruitEmoji: '🍅',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFEF4444),
      lightBgColor: Color(0xFFFEF2F2),
      fruitName: 'Tomat',
      growthCues: [
        'Tanam biji tomat merah ke tanah pot kebun!',
        'Siram air segar agar bunganya mulai tumbuh!',
        'Mentari cerah mengubah buah bulat tomat menjadi merah merona!',
        'Petik buah tomat segar yang penuh vitamin!',
      ],
    ),
    TreeProfile(
      id: 'dragonfruit',
      name: 'Pohon Buah Naga Unik',
      fruitEmoji: '🐉',
      seedEmoji: '🌱',
      primaryColor: Color(0xFFD946EF),
      lightBgColor: Color(0xFFFDF4FF),
      fruitName: 'Buah Naga',
      growthCues: [
        'Tanam bibit kaktus buah naga ke pot tanah!',
        'Siram air secukupnya agar batangnya menjulang!',
        'Bunga raksasa malam mekar disinari mentari pagi!',
        'Petik buah naga merah bersisik eksotis!',
      ],
    ),
  ];
}
