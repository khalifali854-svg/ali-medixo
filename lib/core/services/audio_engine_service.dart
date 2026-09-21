import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'web_speech_stub.dart'
    if (dart.library.html) 'web_speech_web.dart';
import '../components/sentence_builder_bar.dart';
import 'supabase_service.dart';

enum ActiveVoiceSource {
  abi,
  umma,
}

/// Audio Engine for Sentence Sequencing and Dual Voice Output for Ali
class AudioEngineService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isTtsInitialized = false;
  static ActiveVoiceSource activeVoiceSource = ActiveVoiceSource.abi;

  // Language & Voice Settings
  static String currentLanguage = 'id-ID'; // Wajib dan Permanen 'id-ID' (Bahasa Indonesia)
  static String? selectedVoiceName;
  static List<Map<String, String>> availableVoices = [];
  // Default natural speech speed
  static double speechRate = 0.46;
  // Tempo tartil pelan & jelas khusus huruf hijaiyah / Iqro / Quran anak-anak
  static const double arabicSpeechRate = 0.24;

  static Future<void> initialize() async {
    try {
      currentLanguage = 'id-ID';
      await _flutterTts.setLanguage('id-ID');
      await _flutterTts.setSpeechRate(speechRate);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(activeVoiceSource == ActiveVoiceSource.umma ? 1.25 : 0.95);
      await _flutterTts.awaitSpeakCompletion(false);
      _isTtsInitialized = true;
      await fetchAvailableVoices();

      // Pilih otomatis suara Bahasa Indonesia yang paling natural / realistis
      selectedVoiceName = _pickBestNaturalIndonesianVoice(availableVoices);

      // Pasang voice bot jika ada suara Indonesia di perangkat
      if (selectedVoiceName != null) {
        await _flutterTts.setVoice({
          'name': selectedVoiceName!,
          'locale': 'id-ID',
        });
      }
    } catch (e) {
      debugPrint('TTS init warning: $e');
    }
  }

  static Future<void> setSpeechRate(double rate) async {
    speechRate = rate;
    try {
      if (!_isTtsInitialized) await initialize();
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      debugPrint('Error setting speech rate: $e');
    }
  }

  /// Ambil daftar suara bot lokal yang tersedia di sistem operasi
  static Future<List<Map<String, String>>> fetchAvailableVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      if (voices is List) {
        availableVoices = voices.map((v) {
          final map = Map<String, dynamic>.from(v as Map);
          return {
            'name': map['name']?.toString() ?? '',
            'locale': map['locale']?.toString() ?? '',
          };
        }).where((v) => v['name']!.isNotEmpty).toList();
      }
    } catch (e) {
      debugPrint('Fetch voices error: $e');
    }
    return availableVoices;
  }

  /// Ganti bahasa pembaca (misal: 'id-ID', 'en-US', 'ar-SA')
  static Future<void> setLanguage(String langCode, {bool syncToSupabase = true}) async {
    currentLanguage = langCode;
    if (syncToSupabase) {
      SupabaseService.setAppSetting('voice_language', langCode);
    }
    try {
      if (!_isTtsInitialized) await initialize();
      await _flutterTts.setLanguage(langCode);

      // Refresh list voices jika belum terisi
      if (availableVoices.isEmpty) {
        await fetchAvailableVoices();
      }

      // Cari bot suara terbaik yang cocok dengan bahasa target
      if (langCode.toLowerCase().startsWith('id')) {
        final bestVoice = _pickBestNaturalIndonesianVoice(availableVoices);
        if (bestVoice != null) {
          selectedVoiceName = bestVoice;
          await _flutterTts.setVoice({
            'name': bestVoice,
            'locale': langCode,
          });
          if (syncToSupabase) {
            SupabaseService.setAppSetting('voice_bot', bestVoice);
          }
        }
      } else {
        final targetPrefix = langCode.toLowerCase().split('-').first; // 'en', 'ar'
        final matches = availableVoices.where((v) {
          final loc = (v['locale'] ?? '').toLowerCase().replaceAll('_', '-');
          final name = (v['name'] ?? '').toLowerCase();
          return loc.contains(targetPrefix) || name.contains(targetPrefix);
        }).toList();

        if (matches.isNotEmpty) {
          final selected = matches.first;
          selectedVoiceName = selected['name'];
          await _flutterTts.setVoice({
            'name': selected['name']!,
            'locale': selected['locale'] ?? langCode,
          });
          if (syncToSupabase) {
            SupabaseService.setAppSetting('voice_bot', selected['name']!);
          }
        } else {
          selectedVoiceName = null;
        }
      }
    } catch (e) {
      debugPrint('Error setting TTS language: $e');
    }
  }

  /// Memilih 1 suara Bahasa Indonesia yang paling mirip manusia/natural:
  /// Prioritas: Damayanti Enhanced/Premium (Apple iOS/macOS) > Google id-id (Android Neural/Wavenet) > Microsoft Gadis/Ardi
  static String? _pickBestNaturalIndonesianVoice(List<Map<String, String>> voices) {
    final idVoices = voices.where((v) {
      final loc = (v['locale'] ?? '').toLowerCase().replaceAll('_', '-');
      final name = (v['name'] ?? '').toLowerCase();
      return loc.contains('id-id') || loc.startsWith('id') || name.contains('indonesia');
    }).toList();

    if (idVoices.isEmpty) return null;

    // Hierarchy of highest quality natural human-sounding Indonesian voices across platforms:
    // 1. Apple macOS/iOS: Damayanti (Premium / Enhanced / Siri)
    final damayanti = idVoices.firstWhere(
      (v) {
        final n = v['name']!.toLowerCase();
        return n.contains('damayanti') && (n.contains('enhanced') || n.contains('premium'));
      },
      orElse: () => idVoices.firstWhere(
        (v) => v['name']!.toLowerCase().contains('damayanti'),
        orElse: () => {},
      ),
    );
    if (damayanti.isNotEmpty && damayanti['name'] != null) return damayanti['name'];

    // 2. Google / Android: Google id-id Neural/Wavenet voices (Network/High Quality)
    final googleNatural = idVoices.firstWhere(
      (v) {
        final n = v['name']!.toLowerCase();
        return n.contains('neural') || n.contains('wavenet') || n.contains('network');
      },
      orElse: () => idVoices.firstWhere(
        (v) => v['name']!.toLowerCase().contains('google') && v['name']!.toLowerCase().contains('id'),
        orElse: () => {},
      ),
    );
    if (googleNatural.isNotEmpty && googleNatural['name'] != null) return googleNatural['name'];

    // 3. Microsoft / Edge / Chrome Web Speech
    final msNatural = idVoices.firstWhere(
      (v) {
        final n = v['name']!.toLowerCase();
        return n.contains('gadis') || n.contains('ardi') || n.contains('natural');
      },
      orElse: () => {},
    );
    if (msNatural.isNotEmpty && msNatural['name'] != null) return msNatural['name'];

    // 4. Default Indonesian voice pertama
    return idVoices.first['name'];
  }

  /// Ganti model bot suara khusus
  static Future<void> setVoiceBot(String voiceName, {bool syncToSupabase = true}) async {
    selectedVoiceName = voiceName;
    if (syncToSupabase) {
      SupabaseService.setAppSetting('voice_bot', voiceName);
    }
    try {
      if (!_isTtsInitialized) await initialize();
      final voiceMap = availableVoices.firstWhere(
        (v) => v['name'] == voiceName,
        orElse: () => {'name': voiceName, 'locale': currentLanguage},
      );
      await _flutterTts.setVoice({
        'name': voiceMap['name']!,
        'locale': voiceMap['locale'] ?? currentLanguage,
      });
    } catch (e) {
      debugPrint('Error setting voice bot: $e');
    }
  }


  /// Switch active voice source between Abi and Umma
  static void setVoiceSource(ActiveVoiceSource source) {
    activeVoiceSource = source;
    if (_isTtsInitialized) {
      _flutterTts.setPitch(source == ActiveVoiceSource.umma ? 1.45 : 0.90);
    }
  }

  /// Speak plain text (shortcut for speakWord)
  static Future<void> speakText(String text) async {
    await speakWord(text: text);
  }

  /// Map huruf, nama hijaiyah, dan transliterasi ke pelafalan tajwid fonetik fasih (makhraj)
  static final Map<String, String> _hijaiyahPhoneticMap = {
    'ا': 'Alif',
    'أَلِف': 'Alif',
    'alif': 'Alif',
    'ب': 'Ba',
    'بَاء': 'Ba',
    'ba': 'Ba',
    'baa': 'Ba',
    'ت': 'Ta',
    'تَاء': 'Ta',
    'ta': 'Ta',
    'taa': 'Ta',
    'ث': 'Tsa',
    'ثَاء': 'Tsa',
    'tsa': 'Tsa',
    'tsaa': 'Tsa',
    'sa': 'Tsa',
    'ج': 'Jim',
    'جِيم': 'Jim',
    'jim': 'Jim',
    'jiim': 'Jim',
    'ja': 'Jim',
    'ح': 'Ha',
    'حَاء': 'Ha',
    'ha': 'Ha',
    'haa': 'Ha',
    'خ': 'Kho',
    'خَاء': 'Kho',
    'kha': 'Kho',
    'kho': 'Kho',
    'khoo': 'Kho',
    'د': 'Dal',
    'دَال': 'Dal',
    'dal': 'Dal',
    'daal': 'Dal',
    'ذ': 'Dzal',
    'ذَال': 'Dzal',
    'dzal': 'Dzal',
    'dzaal': 'Dzal',
    'zaal': 'Dzal',
    'ر': 'Ro',
    'رَاء': 'Ro',
    'ra': 'Ro',
    'ro': 'Ro',
    'roo': 'Ro',
    'ز': 'Zay',
    'زَاي': 'Zay',
    'zai': 'Zay',
    'zay': 'Zay',
    'zaay': 'Zay',
    'س': 'Sin',
    'سِين': 'Sin',
    'sin': 'Sin',
    'siin': 'Sin',
    'ش': 'Syin',
    'شِين': 'Syin',
    'syin': 'Syin',
    'syiin': 'Syin',
    'shin': 'Syin',
    'ص': 'Shod',
    'صَاد': 'Shod',
    'shad': 'Shod',
    'shod': 'Shod',
    'shood': 'Shod',
    'ض': 'Dhod',
    'ضَاد': 'Dhod',
    'dhad': 'Dhod',
    'dhod': 'Dhod',
    'dhood': 'Dhod',
    'ط': 'Tho',
    'طَاء': 'Tho',
    'tha': 'Tho',
    'tho': 'Tho',
    'thoo': 'Tho',
    'ظ': 'Zho',
    'ظَاء': 'Zho',
    'zha': 'Zho',
    'zho': 'Zho',
    'zhoo': 'Zho',
    'ع': 'Ain',
    'عَيْن': 'Ain',
    'ain': 'Ain',
    '\'ain': 'Ain',
    'a\'in': 'Ain',
    'غ': 'Ghoin',
    'غَيْن': 'Ghoin',
    'ghain': 'Ghoin',
    'ghoin': 'Ghoin',
    'ghooyn': 'Ghoin',
    'ف': 'Fa',
    'فَاء': 'Fa',
    'fa': 'Fa',
    'faa': 'Fa',
    'ق': 'Qof',
    'قَاف': 'Qof',
    'qaf': 'Qof',
    'qof': 'Qof',
    'qoof': 'Qof',
    'ك': 'Kaf',
    'كَاف': 'Kaf',
    'kaf': 'Kaf',
    'kaaf': 'Kaf',
    'ل': 'Lam',
    'لَام': 'Lam',
    'lam': 'Lam',
    'laam': 'Lam',
    'م': 'Mim',
    'مِيم': 'Mim',
    'mim': 'Mim',
    'miim': 'Mim',
    'ن': 'Nun',
    'نُون': 'Nun',
    'nun': 'Nun',
    'nuun': 'Nun',
    'ه': 'Ha',
    'هَاء': 'Ha',
    'ha bulat': 'Ha',
    'و': 'Waw',
    'وَاو': 'Waw',
    'wawu': 'Waw',
    'waw': 'Waw',
    'waaw': 'Waw',
    'لا': 'Lam Alif',
    'لَا': 'Lam Alif',
    'lam alif': 'Lam Alif',
    'ء': 'Hamzah',
    'هَمْزَة': 'Hamzah',
    'hamzah': 'Hamzah',
    'hamza': 'Hamzah',
    'ي': 'Ya',
    'يَاء': 'Ya',
    'ya': 'Ya',
    'yaa': 'Ya',
  };

  static String getArabicPhoneticFallback(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return text;

    // 1. Cek langsung kecocokan persis teks utuh
    if (_hijaiyahPhoneticMap.containsKey(trimmed)) {
      return _hijaiyahPhoneticMap[trimmed]!;
    }
    final lower = trimmed.toLowerCase();
    if (_hijaiyahPhoneticMap.containsKey(lower)) {
      return _hijaiyahPhoneticMap[lower]!;
    }

    // 2. Jika formatnya 'ب (Ba)' atau 'لا (Lam Alif)', ekstrak isi di dalam kurung atau hurufnya
    final matchParen = RegExp(r'\(([^)]+)\)').firstMatch(trimmed);
    if (matchParen != null) {
      final inside = matchParen.group(1)!.trim().toLowerCase();
      if (_hijaiyahPhoneticMap.containsKey(inside)) {
        return _hijaiyahPhoneticMap[inside]!;
      }
    }

    // 3. Khusus Lam Alif (kombinasi Lam dan Alif: 'لا' / 'لَا')
    if (trimmed.contains('لا') || trimmed.contains('لَا') || lower.contains('lam alif')) {
      return 'Lam Alif';
    }

    // 4. Cocokkan kata Arab berharakat / nama multi-karakter dari yang terpanjang
    final sortedKeys = _hijaiyahPhoneticMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final k in sortedKeys) {
      if (k.length > 1 && trimmed.contains(k)) {
        return _hijaiyahPhoneticMap[k]!;
      }
    }

    // 5. Cek karakter Arab tunggal jika tidak ada nama kata yang cocok
    for (final rune in trimmed.runes) {
      final ch = String.fromCharCode(rune);
      // Kecualikan hamzah 'ء' jika teks bukan murni 'ء'
      if (ch == 'ء' && trimmed.length > 1) continue;
      if (_hijaiyahPhoneticMap.containsKey(ch)) {
        return _hijaiyahPhoneticMap[ch]!;
      }
    }

    // 6. Fallback penggantian substring
    String result = trimmed;
    for (final k in sortedKeys) {
      if (result.contains(k)) {
        result = result.replaceAll(k, _hijaiyahPhoneticMap[k]!);
      }
    }

    // Hapus tanda kurung, karakter Arab sisa/harakat
    result = result.replaceAll(RegExp(r'[\(\)\[\]]'), ' ');
    result = result.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    return result.isNotEmpty ? result : trimmed;
  }

  /// Cek ketersediaan bot suara Arab asli di perangkat
  static bool get hasArabicVoice {
    return availableVoices.any((v) {
      final loc = (v['locale'] ?? '').toLowerCase();
      final name = (v['name'] ?? '').toLowerCase();
      return loc.startsWith('ar') || name.contains('arabic') || name.contains('tarik') || name.contains('maged');
    });
  }

  /// Map karakter / nama huruf hijaiyah ke file audio lokal makhraj asli
  static final Map<String, String> _hijaiyahAudioAssets = {
    'ا': 'assets/audio/hijaiyah/hij_alif.m4a',
    'أَلِف': 'assets/audio/hijaiyah/hij_alif.m4a',
    'alif': 'assets/audio/hijaiyah/hij_alif.m4a',
    'ب': 'assets/audio/hijaiyah/hij_ba.m4a',
    'بَاء': 'assets/audio/hijaiyah/hij_ba.m4a',
    'ba': 'assets/audio/hijaiyah/hij_ba.m4a',
    'ت': 'assets/audio/hijaiyah/hij_ta.m4a',
    'تَاء': 'assets/audio/hijaiyah/hij_ta.m4a',
    'ta': 'assets/audio/hijaiyah/hij_ta.m4a',
    'ث': 'assets/audio/hijaiyah/hij_tsa.m4a',
    'ثَاء': 'assets/audio/hijaiyah/hij_tsa.m4a',
    'tsa': 'assets/audio/hijaiyah/hij_tsa.m4a',
    'ج': 'assets/audio/hijaiyah/hij_jim.m4a',
    'جِيم': 'assets/audio/hijaiyah/hij_jim.m4a',
    'jim': 'assets/audio/hijaiyah/hij_jim.m4a',
    'ح': 'assets/audio/hijaiyah/hij_ha.m4a',
    'حَاء': 'assets/audio/hijaiyah/hij_ha.m4a',
    'ha': 'assets/audio/hijaiyah/hij_ha.m4a',
    'خ': 'assets/audio/hijaiyah/hij_kha.m4a',
    'خَاء': 'assets/audio/hijaiyah/hij_kha.m4a',
    'kha': 'assets/audio/hijaiyah/hij_kha.m4a',
    'kho': 'assets/audio/hijaiyah/hij_kha.m4a',
    'د': 'assets/audio/hijaiyah/hij_dal.m4a',
    'دَال': 'assets/audio/hijaiyah/hij_dal.m4a',
    'dal': 'assets/audio/hijaiyah/hij_dal.m4a',
    'ذ': 'assets/audio/hijaiyah/hij_dzal.m4a',
    'ذَال': 'assets/audio/hijaiyah/hij_dzal.m4a',
    'dzal': 'assets/audio/hijaiyah/hij_dzal.m4a',
    'ر': 'assets/audio/hijaiyah/hij_ra.m4a',
    'رَاء': 'assets/audio/hijaiyah/hij_ra.m4a',
    'ra': 'assets/audio/hijaiyah/hij_ra.m4a',
    'ro': 'assets/audio/hijaiyah/hij_ra.m4a',
    'ز': 'assets/audio/hijaiyah/hij_zai.m4a',
    'زَاي': 'assets/audio/hijaiyah/hij_zai.m4a',
    'zai': 'assets/audio/hijaiyah/hij_zai.m4a',
    'zay': 'assets/audio/hijaiyah/hij_zai.m4a',
    'س': 'assets/audio/hijaiyah/hij_sin.m4a',
    'سِين': 'assets/audio/hijaiyah/hij_sin.m4a',
    'sin': 'assets/audio/hijaiyah/hij_sin.m4a',
    'ش': 'assets/audio/hijaiyah/hij_syin.m4a',
    'شِين': 'assets/audio/hijaiyah/hij_syin.m4a',
    'syin': 'assets/audio/hijaiyah/hij_syin.m4a',
    'ص': 'assets/audio/hijaiyah/hij_shad.m4a',
    'صَاد': 'assets/audio/hijaiyah/hij_shad.m4a',
    'shod': 'assets/audio/hijaiyah/hij_shad.m4a',
    'shad': 'assets/audio/hijaiyah/hij_shad.m4a',
    'ض': 'assets/audio/hijaiyah/hij_dhad.m4a',
    'ضَاد': 'assets/audio/hijaiyah/hij_dhad.m4a',
    'dhod': 'assets/audio/hijaiyah/hij_dhad.m4a',
    'dhad': 'assets/audio/hijaiyah/hij_dhad.m4a',
    'ط': 'assets/audio/hijaiyah/hij_tha.m4a',
    'طَاء': 'assets/audio/hijaiyah/hij_tha.m4a',
    'tho': 'assets/audio/hijaiyah/hij_tha.m4a',
    'tha': 'assets/audio/hijaiyah/hij_tha.m4a',
    'ظ': 'assets/audio/hijaiyah/hij_zha.m4a',
    'ظَاء': 'assets/audio/hijaiyah/hij_zha.m4a',
    'zho': 'assets/audio/hijaiyah/hij_zha.m4a',
    'zha': 'assets/audio/hijaiyah/hij_zha.m4a',
    'ع': 'assets/audio/hijaiyah/hij_ain.m4a',
    'عَيْن': 'assets/audio/hijaiyah/hij_ain.m4a',
    'ain': 'assets/audio/hijaiyah/hij_ain.m4a',
    'غ': 'assets/audio/hijaiyah/hij_ghain.m4a',
    'غَيْن': 'assets/audio/hijaiyah/hij_ghain.m4a',
    'ghoin': 'assets/audio/hijaiyah/hij_ghain.m4a',
    'ghain': 'assets/audio/hijaiyah/hij_ghain.m4a',
    'ف': 'assets/audio/hijaiyah/hij_fa.m4a',
    'فَاء': 'assets/audio/hijaiyah/hij_fa.m4a',
    'fa': 'assets/audio/hijaiyah/hij_fa.m4a',
    'ق': 'assets/audio/hijaiyah/hij_qaf.m4a',
    'قَاف': 'assets/audio/hijaiyah/hij_qaf.m4a',
    'qof': 'assets/audio/hijaiyah/hij_qaf.m4a',
    'qaf': 'assets/audio/hijaiyah/hij_qaf.m4a',
    'ك': 'assets/audio/hijaiyah/hij_kaf.m4a',
    'كَاف': 'assets/audio/hijaiyah/hij_kaf.m4a',
    'kaf': 'assets/audio/hijaiyah/hij_kaf.m4a',
    'ل': 'assets/audio/hijaiyah/hij_lam.m4a',
    'لَام': 'assets/audio/hijaiyah/hij_lam.m4a',
    'lam': 'assets/audio/hijaiyah/hij_lam.m4a',
    'م': 'assets/audio/hijaiyah/hij_mim.m4a',
    'مِيم': 'assets/audio/hijaiyah/hij_mim.m4a',
    'mim': 'assets/audio/hijaiyah/hij_mim.m4a',
    'ن': 'assets/audio/hijaiyah/hij_nun.m4a',
    'نُون': 'assets/audio/hijaiyah/hij_nun.m4a',
    'nun': 'assets/audio/hijaiyah/hij_nun.m4a',
    'ه': 'assets/audio/hijaiyah/hij_ha_bulat.m4a',
    'هَاء': 'assets/audio/hijaiyah/hij_ha_bulat.m4a',
    'ha bulat': 'assets/audio/hijaiyah/hij_ha_bulat.m4a',
    'و': 'assets/audio/hijaiyah/hij_wawu.m4a',
    'وَاو': 'assets/audio/hijaiyah/hij_wawu.m4a',
    'waw': 'assets/audio/hijaiyah/hij_wawu.m4a',
    'wawu': 'assets/audio/hijaiyah/hij_wawu.m4a',
    'لا': 'assets/audio/hijaiyah/hij_lam_alif.m4a',
    'لَا': 'assets/audio/hijaiyah/hij_lam_alif.m4a',
    'lam alif': 'assets/audio/hijaiyah/hij_lam_alif.m4a',
    'ء': 'assets/audio/hijaiyah/hij_hamzah.m4a',
    'هَمْزَة': 'assets/audio/hijaiyah/hij_hamzah.m4a',
    'hamzah': 'assets/audio/hijaiyah/hij_hamzah.m4a',
    'hamza': 'assets/audio/hijaiyah/hij_hamzah.m4a',
    'ي': 'assets/audio/hijaiyah/hij_ya.m4a',
    'يَاء': 'assets/audio/hijaiyah/hij_ya.m4a',
    'ya': 'assets/audio/hijaiyah/hij_ya.m4a',
  };

  /// Ambil path asset audio hijaiyah jika ada (HANYA untuk huruf tunggal)
  static String? getHijaiyahAssetAudio(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    // 1. Cocokkan persis teks utuh
    if (_hijaiyahAudioAssets.containsKey(trimmed)) {
      return _hijaiyahAudioAssets[trimmed];
    }
    final lower = trimmed.toLowerCase();
    if (_hijaiyahAudioAssets.containsKey(lower)) {
      return _hijaiyahAudioAssets[lower];
    }

    // 2. Cek di dalam kurung 'ب (Ba)' jika formatnya memang kartu huruf
    final matchParen = RegExp(r'^\s*([^\(]+)\s*\(([^)]+)\)\s*$').firstMatch(trimmed);
    if (matchParen != null) {
      final inside = matchParen.group(2)!.trim().toLowerCase();
      if (_hijaiyahAudioAssets.containsKey(inside)) {
        return _hijaiyahAudioAssets[inside];
      }
      final outside = matchParen.group(1)!.trim().toLowerCase();
      if (_hijaiyahAudioAssets.containsKey(outside)) {
        return _hijaiyahAudioAssets[outside];
      }
    }

    // PENTING: JANGAN lakukan loop runes di sini karena akan mencocokkan huruf 'ب' 
    // pada kata/frasa apapun yang mengandung 'ba', sehingga membuat teks panjang terpotong menjadi 'ba ba ba'!
    return null;
  }

  static Future<void> _playAssetSource(String targetAudioUrl, {double playbackRate = 1.0}) async {
    final mime = targetAudioUrl.endsWith('.wav')
        ? 'audio/wav'
        : (targetAudioUrl.endsWith('.m4a') ? 'audio/mp4' : 'audio/mpeg');
    await _audioPlayer.stop();
    await _audioPlayer.setPlaybackRate(playbackRate);
    if (kIsWeb) {
      // Di Flutter Web rootBundle.load:
      // Asset path yang didaftarkan di pubspec adalah 'assets/audio/hijaiyah/...'.
      // Flutter Web loader internal mencari di URI "assets/" + key.
      // Jika key diberikan 'assets/...', web engine mencarinya di "assets/assets/...".
      // Oleh karena itu, kita HARUS melepas 'assets/' di depan agar menjadi 'audio/hijaiyah/...'!
      final keyForRootBundle = targetAudioUrl.startsWith('assets/')
          ? targetAudioUrl.replaceFirst('assets/', '')
          : targetAudioUrl;
      ByteData? byteData;
      try {
        byteData = await rootBundle.load(keyForRootBundle);
      } catch (_) {
        byteData = await rootBundle.load('assets/$keyForRootBundle');
      }
      final bytes = byteData.buffer.asUint8List();
      await _audioPlayer.play(BytesSource(bytes, mimeType: mime));
    } else {
      final assetPath = targetAudioUrl.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(assetPath));
    }
  }

  /// Play a single word / card audio or fallback to TTS
  static Future<void> speakWord({
    required String text,
    String? audioAbiUrl,
    String? audioUmmaUrl,
    String? audioUrl,
    String? phoneticFallback,
  }) async {
    try {
      // Prioritas UTAMA untuk huruf Hijaiyah: Selalu gunakan suara asli Majed dari asset lokal!
      final hijAsset = (audioUrl != null && audioUrl.startsWith('assets/audio/hijaiyah/'))
          ? audioUrl
          : (getHijaiyahAssetAudio(text) ?? ((audioUrl != null) ? getHijaiyahAssetAudio(audioUrl) : null));
      String? targetAudioUrl = hijAsset;

      if (targetAudioUrl == null || targetAudioUrl.isEmpty) {
        // Jika bukan huruf hijaiyah, baru gunakan rekaman custom pengguna
        targetAudioUrl = activeVoiceSource == ActiveVoiceSource.umma
            ? (audioUmmaUrl ?? audioUrl ?? audioAbiUrl)
            : (audioAbiUrl ?? audioUrl ?? audioUmmaUrl);
      }

      if (targetAudioUrl != null && targetAudioUrl.isNotEmpty) {
        try {
          if (targetAudioUrl.startsWith('assets/')) {
            await _playAssetSource(targetAudioUrl, playbackRate: 1.0);
            return;
          } else if (targetAudioUrl.startsWith('data:audio')) {
            final base64String = targetAudioUrl.split(',').last;
            final bytes = base64Decode(base64String);
            await _audioPlayer.stop();
            await _audioPlayer.setPlaybackRate(1.0);
            if (!kIsWeb) {
              final dir = await getTemporaryDirectory();
              final tempAudio = File('${dir.path}/play_${DateTime.now().millisecondsSinceEpoch}.m4a');
              await tempAudio.writeAsBytes(bytes);
              await _audioPlayer.play(DeviceFileSource(tempAudio.path));
            } else {
              await _audioPlayer.play(BytesSource(bytes, mimeType: 'audio/mpeg'));
            }
            return;
          } else if (targetAudioUrl.startsWith('/') || targetAudioUrl.startsWith('file://')) {
            final cleanPath = targetAudioUrl.replaceFirst('file://', '');
            await _audioPlayer.stop();
            await _audioPlayer.setPlaybackRate(1.0);
            await _audioPlayer.play(DeviceFileSource(cleanPath));
            return;
          } else {
            await _audioPlayer.stop();
            await _audioPlayer.setPlaybackRate(1.0);
            await _audioPlayer.play(UrlSource(targetAudioUrl));
            return;
          }
        } catch (audioErr) {
          debugPrint('Audio playback error, falling back to TTS: $audioErr');
          // Fallback ke TTS jika file audio gagal diputar
        }
      }

      // Deteksi teks Arab / Hijaiyah
      final bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
      String speechText = text;
      String targetLang = currentLanguage;

      if (isArabic) {
        // Teks Arab murni untuk Iqro atau Al-Quran selalu dibaca dengan pelafalan Arab
        speechText = text;
        targetLang = 'ar-SA';
      } else {
        // Teks non-Arab selalu gunakan Bahasa Indonesia default jika setting id-ID
        targetLang = currentLanguage.startsWith('id') ? 'id-ID' : currentLanguage;
      }

      if (kIsWeb) {
        _speakWebNative(speechText, lang: targetLang);
      } else {
        if (!_isTtsInitialized) await initialize();
        await _flutterTts.stop();
        await _flutterTts.setLanguage(targetLang);

        // Terapkan bot suara terpilih jika cocok dengan target bahasa
        if (targetLang.toLowerCase().startsWith('id')) {
          final idVoice = _pickBestNaturalIndonesianVoice(availableVoices);
          if (idVoice != null) {
            await _flutterTts.setVoice({
              'name': idVoice,
              'locale': 'id-ID',
            });
          }
        } else if (selectedVoiceName != null && selectedVoiceName!.isNotEmpty) {
          final match = availableVoices.any((v) => v['name'] == selectedVoiceName);
          if (match) {
            await _flutterTts.setVoice({
              'name': selectedVoiceName!,
              'locale': targetLang,
            });
          }
        }

        final effectiveRate = (isArabic || targetLang.toLowerCase().startsWith('ar'))
            ? arabicSpeechRate
            : speechRate;
        await _flutterTts.setSpeechRate(effectiveRate);
        await _flutterTts.speak(speechText);
      }
    } catch (e) {
      debugPrint('Error speaking word: $e');
    }
  }

  /// Web SpeechSynthesis langsung via window.aliSpeakText (index.html)
  /// Memanggil Web Speech API langsung — jauh lebih andal di mobile browser
  static void _speakWebNative(String text, {String? lang}) {
    if (!kIsWeb) return;
    try {
      final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
      final targetLang = lang ?? (isArabic ? 'ar-SA' : 'id-ID');
      final isUmma = activeVoiceSource == ActiveVoiceSource.umma;
      // Panggil window.aliSpeakText yang sudah ada di index.html
      _jsAliSpeakText(text, targetLang, isUmma);
    } catch (e) {
      debugPrint('Web speak error: $e');
    }
  }

  /// Trampoline ke window.aliSpeakText via dart:html (web) atau no-op (native)
  static void _jsAliSpeakText(String text, String lang, bool isUmma) {
    // callAliSpeakText di-import secara conditional:
    // - web: dart:html window.callMethod('aliSpeakText', ...)
    // - native: no-op stub
    callAliSpeakText(text, lang, isUmma);
  }


  /// Play full sentence sequence with seamless timing & callback for active word index
  static Future<void> playSentenceSequence({
    required List<SentenceItem> items,
    Function(int activeIndex)? onWordHighlight,
    VoidCallback? onComplete,
  }) async {
    if (items.isEmpty) return;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      onWordHighlight?.call(i);

      // Play word audio or fallback to gentle TTS
      await speakWord(
        text: item.label,
        audioAbiUrl: item.audioAbiUrl,
        audioUmmaUrl: item.audioUmmaUrl,
        audioUrl: item.audioUrl,
      );

      // Wait a natural, clear interval between words (950ms for Ali's speech development)
      await Future.delayed(const Duration(milliseconds: 950));
    }

    onComplete?.call();
  }

  static Future<void> stop() async {
    await _audioPlayer.stop();
    await _flutterTts.stop();
  }
}
