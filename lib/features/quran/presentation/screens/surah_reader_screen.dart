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

class SurahReaderScreen extends StatefulWidget {
  final SurahInfo surahInfo;
  final int initialAyahNumber;

  const SurahReaderScreen({
    super.key,
    required this.surahInfo,
    this.initialAyahNumber = 1,
  });

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  SurahDetail? _detail;
  bool _isLoading = true;
  String? _errorMessage;

  // Audio & Highlight State
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentPlayingAyah;
  bool _isPlaying = false;
  bool _isAutoNext = true;
  StreamSubscription? _playerCompleteSub;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _playerPosSub;
  int _currentAudioPositionMs = 0;

  // Word-by-word timing data: ayahNumber -> List of [wordIndex, startMs, endMs]
  Map<int, List<List<int>>> _wordTimings = {};

  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _ayahKeys = {};

  @override
  void initState() {
    super.initState();
    _configureAudioContext();
    _loadSurah();
    _initAudioListeners();
  }

  void _configureAudioContext() {
    if (kIsWeb) return;
    // Ensure playback continues when phone screen locks or app moves to background
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
    if (_isAutoNext && _currentPlayingAyah != null && _detail != null) {
      final currentIndex = _detail!.ayahs.indexWhere((a) => a.numberInSurah == _currentPlayingAyah);
      if (currentIndex != -1 && currentIndex + 1 < _detail!.ayahs.length) {
        final nextAyah = _detail!.ayahs[currentIndex + 1];
        _playAyahAudio(nextAyah);
      } else {
        setState(() {
          _isPlaying = false;
          _currentPlayingAyah = null;
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

    // Real-time audio position for word-by-word highlight
    _playerPosSub = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted && _isPlaying && _currentPlayingAyah != null) {
        final posMs = position.inMilliseconds;
        // Update only if difference is meaningful to prevent excessive rebuilds
        if ((posMs - _currentAudioPositionMs).abs() > 40) {
          setState(() {
            _currentAudioPositionMs = posMs;
          });
        }
      }
    });
  }

  Future<void> _loadSurah() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = await QuranRepository.getSurahDetail(widget.surahInfo.number);
      final timings = await QuranRepository.getSurahWordTiming(widget.surahInfo.number);

      if (mounted) {
        setState(() {
          _detail = detail;
          _wordTimings = timings;
          _isLoading = false;
        });

        // Save last read
        QuranRepository.saveLastRead(
          surahNumber: widget.surahInfo.number,
          surahName: widget.surahInfo.transliteration,
          ayahNumber: widget.initialAyahNumber,
        );

        // Scroll to initial ayah if needed
        if (widget.initialAyahNumber > 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToAyah(widget.initialAyahNumber);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat ayat Al-Qur\'an: $e';
        });
      }
    }
  }

  void _scrollToAyah(int ayahNum) {
    final key = _ayahKeys[ayahNum];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        alignment: 0.15,
      );
    }
  }

  Future<void> _playAyahAudio(Ayah ayah) async {
    try {
      if (_currentPlayingAyah == ayah.numberInSurah && _isPlaying) {
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
        _currentPlayingAyah = ayah.numberInSurah;
        _isPlaying = true;
      });

      _scrollToAyah(ayah.numberInSurah);

      // Save last read to current playing ayah
      QuranRepository.saveLastRead(
        surahNumber: widget.surahInfo.number,
        surahName: widget.surahInfo.transliteration,
        ayahNumber: ayah.numberInSurah,
      );

      // verses.quran.com: CORS open (Access-Control-Allow-Origin: *), format MP3, live
      final surahPadded = widget.surahInfo.number.toString().padLeft(3, '0');
      final ayahPadded = ayah.numberInSurah.toString().padLeft(3, '0');
      final String audioUrl = 'https://verses.quran.com/Alafasy/mp3/$surahPadded$ayahPadded.mp3';

      if (kIsWeb) {
        // Di Web, gunakan HTML5 Audio element native (tidak pakai audioplayers)
        webPlayAudioUrl(
          audioUrl,
          onEnded: () {
            _onPlaybackEnded();
          },
          onPosition: (posMs) {
            if (mounted && _isPlaying && _currentPlayingAyah != null) {
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
      debugPrint('Error playing ayah audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio ayat ${ayah.numberInSurah}: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
      if (kIsWeb && _currentPlayingAyah != null) {
        webResumeAudio();
        setState(() {
          _isPlaying = true;
        });
        return;
      }
      if (_currentPlayingAyah != null && _detail != null) {
        final ayah = _detail!.ayahs.firstWhere(
          (a) => a.numberInSurah == _currentPlayingAyah,
          orElse: () => _detail!.ayahs.first,
        );
        _playAyahAudio(ayah);
      } else if (_detail != null && _detail!.ayahs.isNotEmpty) {
        _playAyahAudio(_detail!.ayahs.first);
      }
    }
  }

  void _playNextAyah() {
    if (_detail == null || _detail!.ayahs.isEmpty) return;
    final currentIndex = _detail!.ayahs.indexWhere((a) => a.numberInSurah == _currentPlayingAyah);
    if (currentIndex != -1 && currentIndex + 1 < _detail!.ayahs.length) {
      _playAyahAudio(_detail!.ayahs[currentIndex + 1]);
    }
  }

  void _playPrevAyah() {
    if (_detail == null || _detail!.ayahs.isEmpty) return;
    final currentIndex = _detail!.ayahs.indexWhere((a) => a.numberInSurah == _currentPlayingAyah);
    if (currentIndex > 0) {
      _playAyahAudio(_detail!.ayahs[currentIndex - 1]);
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
              widget.surahInfo.transliteration,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              '${widget.surahInfo.translation} • ${widget.surahInfo.numberOfVerse} Ayat',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.info_circle, color: AppColors.textPrimary),
            tooltip: 'Tafsir & Pengantar Surah',
            onPressed: _showSurahInfoDialog,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomPlayer(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentBrand),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 54, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadSurah,
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

    final detail = _detail!;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 820 : double.infinity),
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: detail.ayahs.length + 1, // Header banner + ayat list
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildSurahHeaderBanner();
            }
            final ayah = detail.ayahs[index - 1];
            _ayahKeys[ayah.numberInSurah] ??= GlobalKey();

            return Container(
              key: _ayahKeys[ayah.numberInSurah],
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildAyahCard(ayah),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSurahHeaderBanner() {
    final showBismillah = widget.surahInfo.number != 9 && widget.surahInfo.number != 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.borderCard, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceInput,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  widget.surahInfo.revelation.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLemon.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${widget.surahInfo.numberOfVerse} AYAT',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            widget.surahInfo.nameLong.isNotEmpty ? widget.surahInfo.nameLong : widget.surahInfo.name,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Amiri',
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            widget.surahInfo.translation,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          if (showBismillah) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.borderSubtle, thickness: 1),
            const SizedBox(height: 16),
            const Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: TextStyle(
                fontSize: 26,
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

  Widget _buildAyahCard(Ayah ayah) {
    final isSelected = _currentPlayingAyah == ayah.numberInSurah;
    final isThisPlaying = isSelected && _isPlaying;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // Background tetap bersih netral
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(
          // Border aktif: Hijau emerald tegas saat ayat sedang aktif/diputar
          color: isSelected
              ? const Color(0xFF10B981)
              : AppColors.borderCard,
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
          // Top Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nomor Ayat Badge & Indicator 'Sedang Diputar'
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF047857) // Deep emerald badge
                          : AppColors.surfaceInput,
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
                  if (isThisPlaying) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded, size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Diputar',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              // Tombol Audio & Salin
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
                    onPressed: () => _playAyahAudio(ayah),
                    tooltip: 'Putar Murottal',
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.copy, size: 18, color: AppColors.textMuted),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: '${ayah.arab}\n\n${ayah.transliteration}\n\n"${ayah.translation}"\n(QS. ${widget.surahInfo.transliteration}: ${ayah.numberInSurah})',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ayat ${ayah.numberInSurah} disalin!'),
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
                        surahNumber: widget.surahInfo.number,
                        surahName: widget.surahInfo.transliteration,
                        ayahNumber: ayah.numberInSurah,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ditandai terakhir dibaca di Ayat ${ayah.numberInSurah}'),
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

          // Teks Arab dengan Highlight Kata Real-time (Word-by-word Karaoke)
          _buildArabicTextWithHighlight(ayah, isThisPlaying),

          const SizedBox(height: 12),

          // Transliterasi Latin
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

          // Terjemahan Indonesia
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

  Widget _buildArabicTextWithHighlight(Ayah ayah, bool isThisPlaying) {
    final words = ayah.arab.trim().split(RegExp(r'\s+'));
    final ayahSegments = _wordTimings[ayah.numberInSurah];

    // Jika tidak sedang diputar atau data timing tidak tersedia, tampilkan teks biasa
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

    // Temukan kata yang sedang dilafalkan berdasarkan waktu audio milidetik saat ini
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

    // Jika lewat waktu segmen terakhir, nyalakan kata terakhir
    if (activeWordIndex == -1 && ayahSegments.isNotEmpty) {
      final lastSeg = ayahSegments.last;
      if (_currentAudioPositionMs > lastSeg[2]) {
        activeWordIndex = lastSeg[0];
      }
    }

    // Bangun TextSpan murni per kata — hanya warna teks yang berubah tanpa background container
    final spans = <TextSpan>[];
    for (int i = 0; i < words.length; i++) {
      final wordPos = i + 1; // 1-indexed matching Quran segments
      final isCurrentWord = isThisPlaying && activeWordIndex == wordPos;

      spans.add(
        TextSpan(
          text: words[i],
          style: TextStyle(
            fontSize: 27,
            fontWeight: isCurrentWord ? FontWeight.w800 : FontWeight.w600,
            // Warna kata yang sedang dilafalkan: Hijau Zamrud Emas / Emerald cerah berkilau
            // Kata lainnya: Warna teks utama (hitam/gelap elegan)
            color: isCurrentWord
                ? const Color(0xFF059669) // Vibrant Emerald Green
                : AppColors.textPrimary,
            fontFamily: 'Amiri',
            height: 2.1,
          ),
        ),
      );

      // Spasi antar kata
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
    if (_detail == null) return null;

    final currentAyah = _currentPlayingAyah ?? 1;

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
                    '${widget.surahInfo.transliteration} : Ayat $currentAyah',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Qari: Misyari Rasyid Al-Afasy',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded, size: 28, color: AppColors.textPrimary),
              onPressed: _playPrevAyah,
            ),
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.accentBrand,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: AppColors.accentLemon,
                    size: 26,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded, size: 28, color: AppColors.textPrimary),
              onPressed: _playNextAyah,
            ),
          ],
        ),
      ),
    );
  }

  void _showSurahInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r24)),
        title: Row(
          children: [
            const Icon(Iconsax.book, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              widget.surahInfo.transliteration,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Arti: "${widget.surahInfo.translation}"',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Golongan: ${widget.surahInfo.revelation} • ${widget.surahInfo.numberOfVerse} Ayat',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderSubtle),
              const SizedBox(height: 8),
              const Text(
                'Tafsir & Pengantar:',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                widget.surahInfo.tafsir.isNotEmpty
                    ? widget.surahInfo.tafsir
                    : 'Tidak ada catatan tafsir pengantar untuk surah ini.',
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
