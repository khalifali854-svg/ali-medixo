import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/models/iqro_models.dart';
import '../../data/iqro_repository.dart';
import '../widgets/iqro_word_tile.dart';

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
    super.dispose();
  }

  String _formatTtsText(String raw) {
    // Normalisasi audio untuk TTS mesin Arab:
    // 1. Alif fathah tunggal 'اَ' diubah jadi 'أَ' (alif hamzah fathah) agar berbunyi vokal 'A' murni
    // 2. Huruf 'شَ' tunggal dicegah agar tidak dianggap singkatan moneter
    // 3. Pada kaidah bahasa Arab standar (fusha), mesin TTS secara otomatis menerapkan hukum "Waqaf"
    //    (mematikan/mensukunkan harakat huruf terakhir dari suatu kata).
    //    Contoh: 'بَذَ' dibaca 'badz', 'كَتَبَ' dibaca 'katab'.
    //    Dalam Iqro jilid 1 & 2, harakat akhir WAJIB dibaca vokal penuh (A, I, U).
    //    Dengan menyematkan penahan vokal, TTS dipaksa mengucapkan harakat akhir secara utuh.
    final tokens = raw.trim().split(RegExp(r'\s+'));
    final processed = tokens.map((token) {
      if (token == 'اَ') return 'أَ';
      if (token == 'اِ') return 'إِ';
      if (token == 'اُ') return 'أُ';
      if (token == 'شَ') return 'شَا';

      // Jika kata diakhiri harakat fathah ( َ ) dan bukan huruf mad (seperti alif),
      // tambahkan alif fonetis di akhir agar TTS tidak mematikan huruf terakhir menjadi sukun (waqaf).
      // Contoh: 'بَذَ' -> 'بَذَا' (terdengar 'ba-dza' bukan 'badz').
      if (token.endsWith('\u064E') && !token.endsWith('ا\u064E') && !token.endsWith('ى\u064E')) {
        return '${token}ا';
      }

      return token;
    }).toList();

    return processed.join(' ، ');
  }

  Future<void> _speakItem(IqroWordItem item) async {
    setState(() {
      _currentlyHighlightedId = item.id;
    });

    final rawText = item.audioTtsText ?? item.arabic;
    final textToSpeak = _formatTtsText(rawText);
    try {
      await _flutterTts.speak(textToSpeak);
    } catch (_) {}

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted && _currentlyHighlightedId == item.id) {
        setState(() {
          _currentlyHighlightedId = null;
        });
      }
    });
  }

  Future<void> _playAllOnCurrentPage() async {
    if (_isPlayingAll) {
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
        final text = _formatTtsText(rawText);
        await _flutterTts.speak(text);
        await Future.delayed(const Duration(milliseconds: 1200));
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
