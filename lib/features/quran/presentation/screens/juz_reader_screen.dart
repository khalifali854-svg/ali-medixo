import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:iconsax/iconsax.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import '../../domain/models/quran_models.dart';
import '../../data/quran_repository.dart';
import '../services/web_quran_audio_stub.dart'
    if (dart.library.html) '../services/web_quran_audio_web.dart';

class JuzReaderScreen extends StatefulWidget {
  final JuzInfo juzInfo;

  const JuzReaderScreen({
    super.key,
    required this.juzInfo,
  });

  @override
  State<JuzReaderScreen> createState() => _JuzReaderScreenState();
}

class _JuzReaderScreenState extends State<JuzReaderScreen> {
  List<({SurahInfo surah, Ayah ayah})> _juzAyahs = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Audio & Highlight State
  final AudioPlayer _audioPlayer = AudioPlayer();
  // Key format: "${surahNumber}_${ayahNumberInSurah}"
  String? _currentPlayingKey;
  bool _isPlaying = false;
  bool _isAutoNext = true;
  StreamSubscription? _playerCompleteSub;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _playerPosSub;
  int _currentAudioPositionMs = 0;

  // Word-by-word timing data cache: surahNumber -> (ayahNumber -> List of [wordIndex, startMs, endMs])
  final Map<int, Map<int, List<List<int>>>> _wordTimingsCache = {};

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _ayahKeys = {};

  @override
  void initState() {
    super.initState();
    _configureAudioContext();
    _loadJuz();
    _initAudioListeners();
  }

  void _configureAudioContext() {
    _audioPlayer.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: const {
            AVAudioSessionOptions.duckOthers,
          },
        ),
        android: const AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _playerCompleteSub?.cancel();
    _playerStateSub?.cancel();
    _playerPosSub?.cancel();
    if (kIsWeb) {
      webStopAudio();
    }
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPlaybackEnded() {
    if (!mounted) return;
    if (_isAutoNext && _currentPlayingKey != null && _juzAyahs.isNotEmpty) {
      final currentIndex = _juzAyahs.indexWhere((item) =>
          '${item.surah.number}_${item.ayah.numberInSurah}' == _currentPlayingKey);
      if (currentIndex != -1 && currentIndex + 1 < _juzAyahs.length) {
        final nextItem = _juzAyahs[currentIndex + 1];
        _playAyahAudio(nextItem.surah, nextItem.ayah);
      } else {
        setState(() {
          _isPlaying = false;
          _currentPlayingKey = null;
          _currentAudioPositionMs = 0;
        });
      }
    } else {
      setState(() {
        _isPlaying = false;
        _currentAudioPositionMs = 0;
      });
    }
  }

  void _initAudioListeners() {
    _playerCompleteSub = _audioPlayer.onPlayerComplete.listen((_) {
      _onPlaybackEnded();
    });

    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _playerPosSub = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted && _isPlaying && _currentPlayingKey != null) {
        final posMs = position.inMilliseconds;
        if ((posMs - _currentAudioPositionMs).abs() > 40) {
          setState(() {
            _currentAudioPositionMs = posMs;
          });
        }
      }
    });
  }

  Future<void> _loadJuz() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ayahs = await QuranRepository.getJuzAyahs(widget.juzInfo);

      // Pre-fetch timings for all surahs in this juz
      final surahNumbers = ayahs.map((e) => e.surah.number).toSet();
      for (final sNum in surahNumbers) {
        final t = await QuranRepository.getSurahWordTiming(sNum);
        _wordTimingsCache[sNum] = t;
      }

      if (mounted) {
        setState(() {
          _juzAyahs = ayahs;
          _isLoading = false;
        });

        // Save last read at starting ayah of this juz
        QuranRepository.saveLastRead(
          surahNumber: widget.juzInfo.startSurahNumber,
          surahName: widget.juzInfo.startSurahName,
          ayahNumber: widget.juzInfo.startAyahNumber,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat ayat Juz ${widget.juzInfo.number}: $e';
        });
      }
    }
  }

  void _scrollToAyah(String keyStr) {
    final key = _ayahKeys[keyStr];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        alignment: 0.15,
      );
    }
  }

  Future<void> _playAyahAudio(SurahInfo surah, Ayah ayah) async {
    try {
      final keyStr = '${surah.number}_${ayah.numberInSurah}';
      if (_currentPlayingKey == keyStr && _isPlaying) {
        if (kIsWeb) {
          webPauseAudio();
        } else {
          await _audioPlayer.pause();
        }
        setState(() {
          _isPlaying = false;
        });
        return;
      }

      setState(() {
        _currentPlayingKey = keyStr;
        _isPlaying = true;
      });

      _scrollToAyah(keyStr);

      QuranRepository.saveLastRead(
        surahNumber: surah.number,
        surahName: surah.transliteration,
        ayahNumber: ayah.numberInSurah,
      );

      // R2 CDN kita sendiri: https://ali.medixo.id/quran/Alafasy/XXXYYY.mp3
      final surahPadded = surah.number.toString().padLeft(3, '0');
      final ayahPadded = ayah.numberInSurah.toString().padLeft(3, '0');
      final String audioUrl = 'https://ali.medixo.id/quran/Alafasy/$surahPadded${ayahPadded}.mp3';

      if (kIsWeb) {
        webPlayAudioUrl(
          audioUrl,
          onEnded: () {
            _onPlaybackEnded();
          },
          onPosition: (posMs) {
            if (mounted && _isPlaying && _currentPlayingKey != null) {
              if ((posMs - _currentAudioPositionMs).abs() > 40) {
                setState(() {
                  _currentAudioPositionMs = posMs;
                });
              }
            }
          },
        );
        return;
      }

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl, mimeType: 'audio/mpeg'));
    } catch (e) {
      debugPrint('Error playing juz ayah audio: $e');
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      if (kIsWeb) {
        webPauseAudio();
      } else {
        _audioPlayer.pause();
      }
      setState(() {
        _isPlaying = false;
      });
    } else {
      if (kIsWeb && _currentPlayingKey != null) {
        webResumeAudio();
        setState(() {
          _isPlaying = true;
        });
        return;
      }
      if (_currentPlayingKey != null && _juzAyahs.isNotEmpty) {
        final item = _juzAyahs.firstWhere(
          (i) => '${i.surah.number}_${i.ayah.numberInSurah}' == _currentPlayingKey,
          orElse: () => _juzAyahs.first,
        );
        _playAyahAudio(item.surah, item.ayah);
      } else if (_juzAyahs.isNotEmpty) {
        _playAyahAudio(_juzAyahs.first.surah, _juzAyahs.first.ayah);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              'Juz ${widget.juzInfo.number}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              widget.juzInfo.description,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isAutoNext ? Icons.autorenew_rounded : Icons.sync_disabled_rounded,
              color: _isAutoNext ? const Color(0xFF047857) : AppColors.textMuted,
            ),
            tooltip: _isAutoNext ? 'Auto-Next Ayat: Aktif' : 'Auto-Next Ayat: Mati',
            onPressed: () {
              setState(() => _isAutoNext = !_isAutoNext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isAutoNext ? 'Putar ayat otomatis aktif' : 'Putar ayat otomatis nonaktif'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.accentBrand))
            : _buildContent(),
      ),
      bottomNavigationBar: _buildBottomPlayer(),
    );
  }

  Widget _buildContent() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.accentCoral),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadJuz,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentLemon,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 820 : double.infinity),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: _juzAyahs.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildJuzHeaderBanner();
            }

            final item = _juzAyahs[index - 1];
            final prevItem = index > 1 ? _juzAyahs[index - 2] : null;
            final isNewSurah = prevItem == null || prevItem.surah.number != item.surah.number;

            final keyStr = '${item.surah.number}_${item.ayah.numberInSurah}';
            _ayahKeys[keyStr] ??= GlobalKey();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isNewSurah) _buildSurahTransitionHeader(item.surah, item.ayah.numberInSurah == 1),
                Container(
                  key: _ayahKeys[keyStr],
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildAyahCard(item.surah, item.ayah),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildJuzHeaderBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'JUZ ${widget.juzInfo.number}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.juzInfo.startAyahArab,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Amiri',
              height: 1.8,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.juzInfo.description} • ${_juzAyahs.length} Ayat',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahTransitionHeader(SurahInfo surah, bool isAyahOne) {
    final showBismillah = isAyahOne && surah.number != 9 && surah.number != 1;

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.transliteration,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${surah.translation} • ${surah.numberOfVerse} Ayat • ${surah.revelation}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                surah.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF047857),
                  fontFamily: 'Amiri',
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          if (showBismillah) ...[
            const SizedBox(height: 10),
            const Divider(color: AppColors.borderSubtle, thickness: 1),
            const SizedBox(height: 8),
            const Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Amiri',
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAyahCard(SurahInfo surah, Ayah ayah) {
    final keyStr = '${surah.number}_${ayah.numberInSurah}';
    final isSelected = _currentPlayingKey == keyStr;
    final isThisPlaying = isSelected && _isPlaying;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(
          color: isSelected ? const Color(0xFF10B981) : AppColors.borderCard,
          width: isSelected ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF10B981).withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isSelected ? 12 : 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF047857) : AppColors.surfaceInput,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${ayah.numberInSurah}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    surah.transliteration,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isThisPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: isSelected ? const Color(0xFF047857) : AppColors.textSecondary,
                      size: 28,
                    ),
                    onPressed: () => _playAyahAudio(surah, ayah),
                    tooltip: 'Putar Murottal',
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.copy, size: 18, color: AppColors.textMuted),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: '${ayah.arab}\n\n${ayah.transliteration}\n\n"${ayah.translation}"\n(QS. ${surah.transliteration}: ${ayah.numberInSurah})',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${surah.transliteration} : ${ayah.numberInSurah} disalin!'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    tooltip: 'Salin Ayat',
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.bookmark, size: 18, color: AppColors.textMuted),
                    onPressed: () {
                      QuranRepository.saveLastRead(
                        surahNumber: surah.number,
                        surahName: surah.transliteration,
                        ayahNumber: ayah.numberInSurah,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ditandai terakhir dibaca di ${surah.transliteration} : ${ayah.numberInSurah}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    tooltip: 'Tandai Terakhir Dibaca',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildArabicTextWithHighlight(surah, ayah, isThisPlaying),
          const SizedBox(height: 12),
          Text(
            ayah.transliteration,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D9488),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ayah.translation,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabicTextWithHighlight(SurahInfo surah, Ayah ayah, bool isThisPlaying) {
    final words = ayah.arab.trim().split(RegExp(r'\s+'));
    final surahTiming = _wordTimingsCache[surah.number];
    final ayahSegments = surahTiming?[ayah.numberInSurah];

    if (!isThisPlaying || ayahSegments == null || ayahSegments.isEmpty) {
      return Text(
        ayah.arab,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 2.1,
          fontFamily: 'Amiri',
        ),
      );
    }

    int activeWordIndex = -1;
    for (final seg in ayahSegments) {
      final wIdx = seg[0];
      final startMs = seg[1];
      final endMs = seg[2];
      if (_currentAudioPositionMs >= startMs && _currentAudioPositionMs <= endMs) {
        activeWordIndex = wIdx;
        break;
      }
    }

    if (activeWordIndex == -1 && ayahSegments.isNotEmpty) {
      final lastSeg = ayahSegments.last;
      if (_currentAudioPositionMs > lastSeg[2]) {
        activeWordIndex = lastSeg[0];
      }
    }

    // Regex untuk mengenali tanda waqf / tanda henti Al-Qur'an (seperti ۚ, ۖ, ۗ, ۘ, ۙ, ۛ, ۜ, dll)
    // Tanda waqf bukan kata yang dilafalkan, jadi tidak dihitung dalam data timing quran
    final isWaqfRegex = RegExp(r'^[\u06D6-\u06ED\u06E9-\u06ED]+$');

    final spans = <TextSpan>[];
    int spokenWordCounter = 0;

    for (int i = 0; i < words.length; i++) {
      final token = words[i];
      final isWaqf = isWaqfRegex.hasMatch(token);

      int? wordPos;
      if (!isWaqf) {
        spokenWordCounter++;
        wordPos = spokenWordCounter;
      }

      final isCurrentWord = !isWaqf && isThisPlaying && activeWordIndex == wordPos;

      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(
            fontSize: isWaqf ? 20 : 27,
            fontWeight: isCurrentWord ? FontWeight.w800 : (isWaqf ? FontWeight.w400 : FontWeight.w600),
            color: isCurrentWord
                ? const Color(0xFF059669)
                : (isWaqf ? const Color(0xFF9CA3AF) : AppColors.textPrimary),
            fontFamily: 'Amiri',
            height: 2.1,
          ),
        ),
      );

      if (i < words.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    );
  }

  Widget? _buildBottomPlayer() {
    if (_juzAyahs.isEmpty) return null;

    final currentItem = _currentPlayingKey != null
        ? _juzAyahs.firstWhere(
            (i) => '${i.surah.number}_${i.ayah.numberInSurah}' == _currentPlayingKey,
            orElse: () => _juzAyahs.first,
          )
        : _juzAyahs.first;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        border: const Border(top: BorderSide(color: AppColors.borderSubtle, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentItem.surah.transliteration} : Ayat ${currentItem.ayah.numberInSurah}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Misyari Rasyid Al-Afasy (Juz Mode)',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                color: const Color(0xFF047857),
                size: 38,
              ),
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}
