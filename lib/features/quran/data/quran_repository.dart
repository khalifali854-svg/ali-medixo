import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/quran_models.dart';

import 'source/quran_surah_list_data.dart';
import 'source/quran_details_provider.dart';

class QuranRepository {
  static const String _lastReadKey = 'quran_last_read';

  /// Ambil daftar 114 surah lengkap (instan, 100% offline, zero error)
  static Future<List<SurahInfo>> getSurahList() async {
    return QuranSurahListData.allSurahs;
  }

  /// Cache data timing kata per ayat
  static Map<String, dynamic>? _cachedTimingData;

  /// Ambil data timing per kata untuk surah tertentu:
  /// Mengembalikan Map: ayahNumber -> List of [wordIndex, startMs, endMs]
  static Future<Map<int, List<List<int>>>> getSurahWordTiming(int surahNumber) async {
    try {
      if (_cachedTimingData == null) {
        final jsonStr = await rootBundle.loadString('assets/data/quran/quran_word_timing.json');
        _cachedTimingData = jsonDecode(jsonStr) as Map<String, dynamic>;
      }
      final surahData = _cachedTimingData?[surahNumber.toString()] as Map<String, dynamic>?;
      if (surahData == null) return {};

      final result = <int, List<List<int>>>{};
      surahData.forEach((ayahKey, segments) {
        final ayahNum = int.tryParse(ayahKey);
        if (ayahNum != null && segments is List) {
          final segList = <List<int>>[];
          for (final seg in segments) {
            if (seg is List && seg.length >= 3) {
              segList.add([
                (seg[0] as num).toInt(),
                (seg[1] as num).toInt(),
                (seg[2] as num).toInt(),
              ]);
            }
          }
          result[ayahNum] = segList;
        }
      });
      return result;
    } catch (e) {
      debugPrint('Error loading quran word timing for surah $surahNumber: $e');
      return {};
    }
  }

  /// Ambil detail surah dan ayat-ayatnya (instan, 100% offline, zero network error)
  static Future<SurahDetail?> getSurahDetail(int surahNumber) async {
    return QuranDetailsProvider.getSurahDetail(surahNumber);
  }

  /// Ambil seluruh ayat dalam 1 Juz lengkap (bisa melintasi beberapa surah)
  /// Mengembalikan list Tuple/Item: (SurahInfo surah, Ayah ayah)
  static Future<List<({SurahInfo surah, Ayah ayah})>> getJuzAyahs(JuzInfo juz) async {
    final result = <({SurahInfo surah, Ayah ayah})>[];
    for (int sNum = juz.startSurahNumber; sNum <= juz.endSurahNumber; sNum++) {
      final surahDetail = await getSurahDetail(sNum);
      if (surahDetail == null) continue;

      for (final ayah in surahDetail.ayahs) {
        // Cek apakah ayat ini masuk dalam rentang juz
        final isAfterOrAtStart = (sNum > juz.startSurahNumber) || 
            (sNum == juz.startSurahNumber && ayah.numberInSurah >= juz.startAyahNumber);
        final isBeforeOrAtEnd = (sNum < juz.endSurahNumber) || 
            (sNum == juz.endSurahNumber && ayah.numberInSurah <= juz.endAyahNumber);

        if (isAfterOrAtStart && isBeforeOrAtEnd) {
          result.add((surah: surahDetail.info, ayah: ayah));
        }
      }
    }
    return result;
  }


  /// Simpan posisi terakhir dibaca
  static Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRead = QuranLastRead(
        surahNumber: surahNumber,
        surahName: surahName,
        ayahNumber: ayahNumber,
        timestamp: DateTime.now(),
      );
      await prefs.setString(_lastReadKey, jsonEncode(lastRead.toJson()));
    } catch (e) {
      debugPrint('Error saving last read: $e');
    }
  }

  /// Ambil posisi terakhir dibaca
  static Future<QuranLastRead?> getLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_lastReadKey);
      if (data != null && data.isNotEmpty) {
        return QuranLastRead.fromJson(jsonDecode(data));
      }
    } catch (e) {
      debugPrint('Error getting last read: $e');
    }
    return null;
  }
}
