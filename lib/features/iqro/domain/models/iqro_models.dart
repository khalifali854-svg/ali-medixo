class IqroLevel {
  final int jilid;
  final String title;
  final String subtitle;
  final String description;
  final int totalPages;
  final int primaryColorHex;
  final int accentColorHex;
  final String? imageAsset;

  const IqroLevel({
    required this.jilid,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.totalPages,
    required this.primaryColorHex,
    required this.accentColorHex,
    this.imageAsset,
  });

  static const List<IqroLevel> allLevels = [
    IqroLevel(
      jilid: 1,
      title: "Iqro' 1",
      subtitle: "Huruf Tunggal Hijaiyah",
      description: "Mengenal huruf Hijaiyah berharakat fathah (A - Ya) dibaca pendek.",
      totalPages: 31,
      primaryColorHex: 0xFF059669, // Emerald
      accentColorHex: 0xFF10B981,
      imageAsset: "assets/images/iqro_3d_jilid1.jpg",
    ),
    IqroLevel(
      jilid: 2,
      title: "Iqro' 2",
      subtitle: "Huruf Sambung & Mad Asli",
      description: "Mengenal bentuk huruf sambung dan bacaan panjang 2 harakat.",
      totalPages: 30,
      primaryColorHex: 0xFF0284C7, // Sky blue
      accentColorHex: 0xFF38BDF8,
      imageAsset: "assets/images/iqro_3d_jilid2.jpg",
    ),
    IqroLevel(
      jilid: 3,
      title: "Iqro' 3",
      subtitle: "Kasrah, Dhammah & Mad",
      description: "Mengenal harakat kasrah (i), dhammah (u), dan mad thabi'i berangkai.",
      totalPages: 30,
      primaryColorHex: 0xFF7C3AED, // Purple
      accentColorHex: 0xFFA78BFA,
      imageAsset: "assets/images/iqro_3d_jilid3.jpg",
    ),
    IqroLevel(
      jilid: 4,
      title: "Iqro' 4",
      subtitle: "Tanwin & Sukun",
      description: "Mengenal harakat fathatain, kasratain, dhammatain dan huruf sukun.",
      totalPages: 30,
      primaryColorHex: 0xFFD97706, // Amber
      accentColorHex: 0xFFFBBF24,
      imageAsset: "assets/images/iqro_3d_jilid4.jpg",
    ),
    IqroLevel(
      jilid: 5,
      title: "Iqro' 5",
      subtitle: "Tasydid & Waqaf",
      description: "Mengenal tasydid, alif lam syamsiyah/qamariyah, dan waqaf.",
      totalPages: 30,
      primaryColorHex: 0xFFEA580C, // Orange
      accentColorHex: 0xFFFB923C,
      imageAsset: "assets/images/iqro_3d_jilid5.jpg",
    ),
    IqroLevel(
      jilid: 6,
      title: "Iqro' 6",
      subtitle: "Kaidah Tajwid & Ghunnah",
      description: "Hukum nun/mim mati, idgham, ikhfa, qolqolah & tanda wakaf.",
      totalPages: 30,
      primaryColorHex: 0xFF0D9488, // Teal
      accentColorHex: 0xFF2DD4BF,
      imageAsset: "assets/images/iqro_3d_jilid6.jpg",
    ),
  ];
}

enum IqroRowType {
  headerSample, // Baris contoh perkenalan paling atas
  practice,     // Baris latihan bacaan anak
  note,         // Catatan guru/pengingat
}

class IqroWordItem {
  final String id;
  final String arabic;         // Teks arab murni (bisa huruf tunggal, sambung 2-3 huruf, frasa)
  final String latin;          // Transliterasi latin ramah anak
  final String? audioTtsText;  // Teks yang dibaca oleh mesin suara
  final String? tip;           // Tips tajwid / makhraj

  const IqroWordItem({
    required this.id,
    required this.arabic,
    required this.latin,
    this.audioTtsText,
    this.tip,
  });
}

class IqroRow {
  final IqroRowType type;
  final List<IqroWordItem> items;
  final String? rowNote;

  const IqroRow({
    required this.type,
    required this.items,
    this.rowNote,
  });
}

class IqroPage {
  final int jilid;
  final int pageNumber;
  final String title;
  final String instruction; // Petunjuk guru
  final List<IqroRow> rows;

  const IqroPage({
    required this.jilid,
    required this.pageNumber,
    required this.title,
    required this.instruction,
    required this.rows,
  });
}
