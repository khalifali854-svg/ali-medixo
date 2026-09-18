
class SurahInfo {
  final int number;
  final String name; // Arabic name, e.g. "الفاتحة"
  final String nameLong; // e.g. "سُورَةُ ٱلْفَاتِحَةِ"
  final int numberOfVerse;
  final String transliteration; // e.g. "Al-Fatihah"
  final String translation; // e.g. "Pembukaan"
  final String revelation; // "Makkiyyah" or "Madaniyyah"
  final String tafsir; // Surah overview tafsir

  const SurahInfo({
    required this.number,
    required this.name,
    required this.nameLong,
    required this.numberOfVerse,
    required this.transliteration,
    required this.translation,
    required this.revelation,
    required this.tafsir,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'] as int? ?? 1,
      name: json['name'] as String? ?? '',
      nameLong: json['name_long'] as String? ?? '',
      numberOfVerse: json['number_of_verse'] as int? ?? 0,
      transliteration: json['transliteration'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      revelation: json['revelation'] as String? ?? 'Makkiyyah',
      tafsir: json['tafsir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'name_long': nameLong,
      'number_of_verse': numberOfVerse,
      'transliteration': transliteration,
      'translation': translation,
      'revelation': revelation,
      'tafsir': tafsir,
    };
  }

  bool get isMakkiyyah => revelation.toLowerCase().contains('makki');
  bool get isJuzAmma => number >= 78;
}

class Ayah {
  final int numberInSurah;
  final int numberInQuran;
  final int juz;
  final int page;
  final String arab;
  final String transliteration;
  final String translation;
  final String shortTafsir;
  final bool sajda;
  final String audioUrl;

  const Ayah({
    required this.numberInSurah,
    required this.numberInQuran,
    required this.juz,
    required this.page,
    required this.arab,
    required this.transliteration,
    required this.translation,
    required this.shortTafsir,
    required this.sajda,
    required this.audioUrl,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      numberInSurah: json['number_in_surah'] as int? ?? 1,
      numberInQuran: json['number_in_quran'] as int? ?? 1,
      juz: json['juz'] as int? ?? 1,
      page: json['page'] as int? ?? 1,
      arab: json['arab'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      shortTafsir: json['short_tafsir'] as String? ?? '',
      sajda: json['sajda'] as bool? ?? false,
      audioUrl: json['audio_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number_in_surah': numberInSurah,
      'number_in_quran': numberInQuran,
      'juz': juz,
      'page': page,
      'arab': arab,
      'transliteration': transliteration,
      'translation': translation,
      'short_tafsir': shortTafsir,
      'sajda': sajda,
      'audio_url': audioUrl,
    };
  }
}

class SurahDetail {
  final SurahInfo info;
  final List<Ayah> ayahs;

  const SurahDetail({
    required this.info,
    required this.ayahs,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      info: SurahInfo.fromJson(json['info'] as Map<String, dynamic>),
      ayahs: (json['ayahs'] as List<dynamic>?)
              ?.map((e) => Ayah.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'ayahs': ayahs.map((e) => e.toJson()).toList(),
    };
  }
}

class QuranLastRead {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final DateTime timestamp;

  const QuranLastRead({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.timestamp,
  });

  factory QuranLastRead.fromJson(Map<String, dynamic> json) {
    return QuranLastRead(
      surahNumber: json['surah_number'] as int? ?? 1,
      surahName: json['surah_name'] as String? ?? 'Al-Fatihah',
      ayahNumber: json['ayah_number'] as int? ?? 1,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah_number': surahNumber,
      'surah_name': surahName,
      'ayah_number': ayahNumber,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class JuzInfo {
  final int number;
  final int startSurahNumber;
  final int startAyahNumber;
  final int endSurahNumber;
  final int endAyahNumber;
  final String startSurahName;
  final String startAyahArab;
  final String description;

  const JuzInfo({
    required this.number,
    required this.startSurahNumber,
    required this.startAyahNumber,
    required this.endSurahNumber,
    required this.endAyahNumber,
    required this.startSurahName,
    required this.startAyahArab,
    required this.description,
  });
}
