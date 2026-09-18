import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/models/iqro_models.dart';
import '../../data/iqro_repository.dart';
import '../widgets/iqro_word_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/services/audio_engine_service.dart';

class IqroReaderScreen extends StatefulWidget {
  final IqroLevel level;
  final int initialPage;

  const IqroReaderScreen({
    super.key,
    required this.level,
    this.initialPage = 1,
  });

  @override
  State<IqroReaderScreen> createState() => _IqroReaderScreenState();
}

class _IqroReaderScreenState extends State<IqroReaderScreen> {
  late List<IqroPage> _pages;
  late int _currentPageIndex;
  late PageController _pageController;
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentlyHighlightedId;
  bool _isPlayingAll = false;

  @override
  void initState() {
    super.initState();
    _pages = IqroRepository.getPagesForJilid(widget.level.jilid);
    _currentPageIndex = (widget.initialPage - 1).clamp(0, _pages.length - 1);
    _pageController = PageController(initialPage: _currentPageIndex);
    _initTts();
    _saveCurrentProgress();
  }

  Future<void> _initTts() async {
    try {
      // Prioritaskan ar-SA (Saudi Arabia) yang didukung penuh oleh Google TTS di Chrome Web & Mobile
      final languages = await _flutterTts.getLanguages;
      if (languages is List && languages.any((l) => l.toString().toLowerCase().contains('ar-sa'))) {
        await _flutterTts.setLanguage("ar-SA");
      } else {
        await _flutterTts.setLanguage("ar");
      }

      // Coba pilih suara Arabic eksplisit jika tersedia di browser/sistem
      final voices = await _flutterTts.getVoices;
      if (voices is List) {
        for (final v in voices) {
          if (v is Map) {
            final name = (v['name'] ?? '').toString().toLowerCase();
            final locale = (v['locale'] ?? '').toString().toLowerCase();
            if (locale.contains('ar') || name.contains('arabic') || name.contains('majed')) {
              await _flutterTts.setVoice({"name": v['name'], "locale": v['locale']});
              break;
            }
          }
        }
      }

      await _flutterTts.setSpeechRate(0.35); // Kecepatan pelafalan tenang & jelas untuk anak
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint("Error init TTS: $e");
    }
  }

  void _saveCurrentProgress() {
    if (_currentPageIndex < _pages.length) {
      IqroRepository.saveProgress(widget.level.jilid, _pages[_currentPageIndex].pageNumber);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flutterTts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTtsText(String raw) {
    // Kaidah Bacaan Iqro (Wasal & Waqaf):
    // 1. WASAL (BACA SAMBUNG):
    //    Jika dalam satu baris/frasa TIDAK ADA tanda waqaf/berhenti, bacaan WAJIB BERSAMBUNG (alir nafas satu kesatuan).
    //    Kata-kata TIDAK BOLEH dipisahkan dengan koma atau jeda artifisial, dan harakat di tengah kalimat
    //    tetap dibaca hidup (washal ke kata berikutnya, misal alif lam syamsiyah/qomariyah).
    // 2. WAQAF (TANDA BERHENTI):
    //    Hanya berhenti jika ada tanda pemisah eksplisit di Iqro:
    //    - Lingkaran waqaf / ayat ('○')
    //    - Tanda strip pemisah latihan ('-')
    //    - Tanda sama dengan ('=')
    //    Saat waqaf di akhir, huruf terakhir barulah disukunkan / berhenti sesuai kaidah mad 'aridh lissukun.
    // 3. PANJANG PENDEK HARAKAT:
    //    - 1 Harakat: Harakat tunggal ( َ  ِ  ُ ), dibaca pendek 1 ketukan. JANGAN ditambah alif/ya/wawu sembarangan karena akan menjadi 2 harakat!
    //    - 2 Harakat (Mad Thabi'i): Sudah memiliki Alif/Wawu sukun/Ya sukun/Alif khanjariyah.
    //    - 3-5 Harakat (Mad Wajib/Jaiz): Ada tanda alis layar (~ / \u0653).
    //    - Tanwin: Fathatain/Kasratain/Dhammatain dibaca jelas tanwinnya saat washal.

    final hasExplicitWaqaf = raw.contains('○') || raw.contains(' - ') || raw.contains(' = ');

    // Pecah berdasarkan segmen waqaf jika ada tanda berhenti
    final segments = raw.split(RegExp(r'○|\s+-\s+|\s+=\s+'));
    final processedSegments = <String>[];

    for (var segment in segments) {
      segment = segment.replaceAll('○', '').replaceAll('-', '').replaceAll('=', '').trim();
      if (segment.isEmpty) continue;

      final words = segment.split(RegExp(r'\s+'));
      final processedWords = <String>[];

      for (int i = 0; i < words.length; i++) {
        var word = words[i];
        final isLastWordInSegment = (i == words.length - 1);

        // A. Normalisasi alif hamzah tunggal agar berbunyi vokal murni
        if (word == 'اَ') word = 'أَ';
        if (word == 'اِ') word = 'إِ';
        if (word == 'اُ') word = 'أُ';
        if (word == 'شَ') word = 'شَا';

        // B. Mad Far'i (Panjang 3-5 Harakat dengan alis layar)
        if (word.contains('\u0653') || word.contains('~')) {
          word = word.replaceAll('\u0653', 'آ').replaceAll('~', '');
        }

        // C. Aturan Waqaf vs Washal untuk kata terakhir di segmen:
        //    Jika ini BUKAN kata terakhir (masih di tengah frasa sambung),
        //    JANGAN PERNAH dimatikan/diubah, biarkan tersambung alami (washal).
        //    Jika kata terakhir dan ada tanda waqaf, biarkan berhenti secara alami.
        if (isLastWordInSegment && !hasExplicitWaqaf && widget.level.jilid <= 3) {
          // Khusus latihan huruf tunggal jilid 1-3 (misal "ba ta", "bata"),
          // anak belajar harakat akhir harus tetap berbunyi vokal pendek,
          // kita berikan tanda fatha/kasrah/dhammah murni dengan sedikit spasi penahan
          word = '$word ';
        }

        processedWords.add(word);
      }

      // Gabungkan kata-kata dalam satu segmen DENGAN SPASI BIASA (DISAMBUNG WASAL)
      // Tidak disisipkan tanda koma ' ، ' agar nafas dan bacaan mengalir sambung!
      processedSegments.add(processedWords.join(' '));
    }

    // Jika ada beberapa segmen karena ada tanda waqaf (misal ada '○' atau '-'),
    // barulah antar segmen diberi jeda nafas waqaf ( ' ، ' )
    return processedSegments.join(' ، ');
  }

  Future<void> _playArabicAudio(String arabicText, String latinFallback) async {
    try {
      final assetAudio = AudioEngineService.getHijaiyahAssetAudio(arabicText);
      await AudioEngineService.speakWord(
        text: arabicText,
        audioUrl: assetAudio,
      );
    } catch (e) {
      debugPrint("Iqro speak error: $e");
    }
  }

  Future<void> _speakItem(IqroWordItem item) async {
    setState(() {
      _currentlyHighlightedId = item.id;
    });

    final rawText = item.audioTtsText ?? item.arabic;
    final textToSpeak = _formatTtsText(rawText);

    await _playArabicAudio(textToSpeak, item.latin);

    // Durasi highlight proporsional dengan panjang teks (dinaikkan agar selaras dengan tempo tartil)
    final durationMs = math.max(1200, rawText.length * 480);
    Future.delayed(Duration(milliseconds: durationMs), () {
      if (mounted && _currentlyHighlightedId == item.id) {
        setState(() {
          _currentlyHighlightedId = null;
        });
      }
    });
  }

  Future<void> _playAllOnCurrentPage() async {
    if (_isPlayingAll) {
      _audioPlayer.stop();
      _flutterTts.stop();
      setState(() {
        _isPlayingAll = false;
        _currentlyHighlightedId = null;
      });
      return;
    }

    setState(() {
      _isPlayingAll = true;
    });

    final currentPage = _pages[_currentPageIndex];
    for (final row in currentPage.rows) {
      for (final item in row.items) {
        if (!_isPlayingAll || !mounted) break;

        setState(() {
          _currentlyHighlightedId = item.id;
        });

        final rawText = item.audioTtsText ?? item.arabic;
        final textToSpeak = _formatTtsText(rawText);
        await _playArabicAudio(textToSpeak, item.latin);
        // Delay disesuaikan dengan tempo tartil (1900ms) agar bacaan selesai sempurna sebelum kotak berikutnya
        await Future.delayed(const Duration(milliseconds: 1900));
      }
    }

    if (mounted) {
      setState(() {
        _isPlayingAll = false;
        _currentlyHighlightedId = null;
      });
    }
  }

  void _goToPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _audioPlayer.stop();
      _flutterTts.stop();
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showJumpToPageDialog(BuildContext context, Color themeColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetCtx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Halaman ${widget.level.title}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(bottomSheetCtx),
                  ),
                ],
              ),
              const Divider(height: 16),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _pages.length,
                  itemBuilder: (context, idx) {
                    final isCurrent = idx == _currentPageIndex;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(bottomSheetCtx);
                        _goToPage(idx);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent ? themeColor : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrent ? themeColor : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${idx + 1}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.white : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(widget.level.primaryColorHex);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              widget.level.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              "Halaman ${_currentPageIndex + 1} dari ${_pages.length}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Tombol Suara Guru (Auto-Guide)
          IconButton.filledTonal(
            icon: Icon(
              _isPlayingAll ? Iconsax.stop : Iconsax.play,
              color: themeColor,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: themeColor.withValues(alpha: 0.12),
            ),
            onPressed: _playAllOnCurrentPage,
            tooltip: _isPlayingAll ? "Hentikan Suara" : "Dengarkan Halaman Ini",
          ),
          const SizedBox(width: 8),
          // Tombol Modal Loncat Halaman
          IconButton(
            icon: const Icon(Iconsax.grid_5, color: Color(0xFF475569), size: 22),
            tooltip: "Pilih Halaman",
            onPressed: () => _showJumpToPageDialog(context, themeColor),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView Materi Digital Interaktif
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                    _currentlyHighlightedId = null;
                    _isPlayingAll = false;
                  });
                  _saveCurrentProgress();
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPageContent(page, isTablet, themeColor);
                },
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomNav(themeColor, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(IqroPage page, bool isTablet, Color themeColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 36 : 14,
        vertical: isTablet ? 20 : 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 760 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner Petunjuk Guru
              if (page.instruction.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 18 : 14,
                    vertical: isTablet ? 12 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Iconsax.info_circle, size: 18, color: themeColor),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          page.instruction,
                          style: TextStyle(
                            fontSize: isTablet ? 13.5 : 12.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
              ],

              // Baris-baris Kata / Huruf
              ...page.rows.map((row) => _buildRow(row, isTablet, themeColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IqroRow row, bool isTablet, Color themeColor) {
    final isHeader = row.type == IqroRowType.headerSample;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 14 : 10),
      padding: isHeader
          ? EdgeInsets.all(isTablet ? 10 : 8)
          : EdgeInsets.zero,
      decoration: isHeader
          ? BoxDecoration(
              color: themeColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: themeColor.withValues(alpha: 0.25), width: 1.5),
            )
          : null,
      child: Directionality(
        textDirection: TextDirection.rtl, // RTL: Kanan ke Kiri
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.items.map((item) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
                child: IqroWordTile(
                  item: item,
                  isTablet: isTablet,
                  isHighlighted: _currentlyHighlightedId == item.id,
                  onTap: () => _speakItem(item),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color themeColor, bool isTablet) {
    final hasPrev = _currentPageIndex > 0;
    final hasNext = _currentPageIndex < _pages.length - 1;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tombol Prev
          ElevatedButton.icon(
            onPressed: hasPrev ? () => _goToPage(_currentPageIndex - 1) : null,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text("Sebelumnya"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F5F9),
              foregroundColor: const Color(0xFF334155),
              elevation: 0,
              disabledBackgroundColor: const Color(0xFFF8FAFC),
              disabledForegroundColor: const Color(0xFFCBD5E1),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 14,
                vertical: isTablet ? 14 : 10,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),

          // Indikator Halaman
          InkWell(
            onTap: () => _showJumpToPageDialog(context, themeColor),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${_currentPageIndex + 1} / ${_pages.length}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B), size: 18),
                ],
              ),
            ),
          ),

          // Tombol Next
          ElevatedButton.icon(
            onPressed: hasNext ? () => _goToPage(_currentPageIndex + 1) : null,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text("Berikutnya"),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              elevation: 0,
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              disabledForegroundColor: const Color(0xFF94A3B8),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 14,
                vertical: isTablet ? 14 : 10,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}
