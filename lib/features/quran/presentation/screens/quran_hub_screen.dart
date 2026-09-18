import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../domain/models/quran_models.dart';
import '../../data/quran_repository.dart';
import '../../data/source/quran_surah_list_data.dart';
import '../../data/source/quran_juz_list_data.dart';
import 'surah_reader_screen.dart';
import 'juz_reader_screen.dart';

enum QuranNavigationMode {
  surah,
  juz,
}

enum QuranFilterTab {
  all,
  juzAmma,
  makkiyyah,
  madaniyyah,
}

class QuranHubScreen extends StatefulWidget {
  const QuranHubScreen({super.key});

  @override
  State<QuranHubScreen> createState() => _QuranHubScreenState();
}

class _QuranHubScreenState extends State<QuranHubScreen> {
  QuranNavigationMode _navMode = QuranNavigationMode.surah;
  List<SurahInfo> _allSurahs = [];
  List<SurahInfo> _filteredSurahs = [];
  List<JuzInfo> _allJuz = QuranJuzListData.allJuz;
  List<JuzInfo> _filteredJuz = QuranJuzListData.allJuz;
  QuranLastRead? _lastRead;
  bool _isLoading = true;
  String _searchQuery = '';
  QuranFilterTab _activeTab = QuranFilterTab.all;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final surahs = await QuranRepository.getSurahList();
      final lastRead = await QuranRepository.getLastRead();

      if (mounted) {
        setState(() {
          _allSurahs = surahs;
          _lastRead = lastRead;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      debugPrint('Error in _loadData Quran: $e\n$stack');
      if (mounted) {
        setState(() {
          _allSurahs = QuranSurahListData.allSurahs;
          _applyFilters();
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    // 1. Filter Surah
    var surahList = _allSurahs;
    switch (_activeTab) {
      case QuranFilterTab.juzAmma:
        surahList = surahList.where((s) => s.isJuzAmma).toList();
        break;
      case QuranFilterTab.makkiyyah:
        surahList = surahList.where((s) => s.isMakkiyyah).toList();
        break;
      case QuranFilterTab.madaniyyah:
        surahList = surahList.where((s) => !s.isMakkiyyah).toList();
        break;
      case QuranFilterTab.all:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      surahList = surahList.where((s) {
        return s.transliteration.toLowerCase().contains(q) ||
            s.translation.toLowerCase().contains(q) ||
            s.number.toString() == q ||
            s.name.contains(q);
      }).toList();
    }
    _filteredSurahs = surahList;

    // 2. Filter Juz
    var juzList = _allJuz;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      juzList = juzList.where((j) {
        return j.number.toString() == q ||
            'juz ${j.number}'.contains(q) ||
            j.startSurahName.toLowerCase().contains(q) ||
            j.description.toLowerCase().contains(q);
      }).toList();
    }
    _filteredJuz = juzList;
  }

  void _openSurah(SurahInfo surah, {int initialAyah = 1}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahReaderScreen(
          surahInfo: surah,
          initialAyahNumber: initialAyah,
        ),
      ),
    ).then((_) {
      // Refresh last read upon return
      QuranRepository.getLastRead().then((lr) {
        if (mounted) setState(() => _lastRead = lr);
      });
    });
  }

  void _openJuz(JuzInfo juz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JuzReaderScreen(juzInfo: juz),
      ),
    ).then((_) {
      QuranRepository.getLastRead().then((lr) {
        if (mounted) setState(() => _lastRead = lr);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

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
        title: const Text(
          'Al-Qur\'an Digital',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.accentBrand))
            : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 840 : double.infinity),
                  child: Column(
                    children: [
                      // Header & Search Area
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Resume Last Read Banner
                            if (_lastRead != null) _buildResumeBanner(),

                            const SizedBox(height: 12),

                            // 2. Mode Navigasi Tab: [Surah (114)] & [Juz (30)]
                            _buildModeSegmentControl(),

                            const SizedBox(height: 12),

                            // 3. Search Box
                            _buildSearchBar(),

                            // 4. Sub-Filter Tabs (hanya tampil di mode Surah)
                            if (_navMode == QuranNavigationMode.surah) ...[
                              const SizedBox(height: 12),
                              _buildFilterTabs(),
                            ],
                          ],
                        ),
                      ),

                      // List Container (Surah or Juz)
                      Expanded(
                        child: _navMode == QuranNavigationMode.surah
                            ? (_filteredSurahs.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                                    itemCount: _filteredSurahs.length,
                                    itemBuilder: (context, index) {
                                      final surah = _filteredSurahs[index];
                                      return _buildSurahCard(surah);
                                    },
                                  ))
                            : (_filteredJuz.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                                    itemCount: _filteredJuz.length,
                                    itemBuilder: (context, index) {
                                      final juz = _filteredJuz[index];
                                      return _buildJuzCard(juz);
                                    },
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildResumeBanner() {
    final lr = _lastRead!;
    final surah = _allSurahs.firstWhere(
      (s) => s.number == lr.surahNumber,
      orElse: () => SurahInfo(
        number: lr.surahNumber,
        name: '',
        nameLong: '',
        numberOfVerse: 0,
        transliteration: lr.surahName,
        translation: '',
        revelation: '',
        tafsir: '',
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E242B), Color(0xFF2A343F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.accentLemon.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.r16),
            ),
            child: const Center(
              child: Icon(Iconsax.book_1, color: AppColors.accentLemon, size: 24),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TERAKHIR DIBACA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentLemon,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lr.surahName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Ayat ke-${lr.ayahNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _openSurah(surah, initialAyah: lr.ayahNumber),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentLemon,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Text(
              'Lanjut',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSegmentControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceInput,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_navMode != QuranNavigationMode.surah) {
                  setState(() {
                    _navMode = QuranNavigationMode.surah;
                    _applyFilters();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _navMode == QuranNavigationMode.surah
                      ? AppColors.surfaceCard
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: _navMode == QuranNavigationMode.surah
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.book_1,
                        size: 16,
                        color: _navMode == QuranNavigationMode.surah
                            ? const Color(0xFF047857)
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Surah (114)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _navMode == QuranNavigationMode.surah
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: _navMode == QuranNavigationMode.surah
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_navMode != QuranNavigationMode.juz) {
                  setState(() {
                    _navMode = QuranNavigationMode.juz;
                    _applyFilters();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _navMode == QuranNavigationMode.juz
                      ? AppColors.surfaceCard
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: _navMode == QuranNavigationMode.juz
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.archive_book,
                        size: 16,
                        color: _navMode == QuranNavigationMode.juz
                            ? const Color(0xFF047857)
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Juz (30)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: _navMode == QuranNavigationMode.juz
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: _navMode == QuranNavigationMode.juz
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.borderCard, width: 1.2),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val.trim();
            _applyFilters();
          });
        },
        decoration: InputDecoration(
          hintText: _navMode == QuranNavigationMode.surah
              ? 'Cari surah (e.g. Al-Fatihah, 114, Sapi)...'
              : 'Cari juz (e.g. Juz 30, Al-Baqarah)...',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
          prefixIcon: const Icon(Iconsax.search_normal, color: AppColors.textMuted, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _applyFilters();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip('Semua Surah (114)', QuranFilterTab.all),
          const SizedBox(width: 8),
          _buildFilterChip("Juz 'Amma (37)", QuranFilterTab.juzAmma),
          const SizedBox(width: 8),
          _buildFilterChip('Makkiyyah', QuranFilterTab.makkiyyah),
          const SizedBox(width: 8),
          _buildFilterChip('Madaniyyah', QuranFilterTab.madaniyyah),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, QuranFilterTab tab) {
    final isSelected = _activeTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tab;
          _applyFilters();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentBrand : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.accentBrand : AppColors.borderCard,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppColors.accentLemon : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSurahCard(SurahInfo surah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          onTap: () => _openSurah(surah),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderCard, width: 1.2),
            ),
            child: Row(
              children: [
                // Nomor Surah Badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: AppColors.borderSubtle, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.number}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Info Surah (Nama Latin & Terjemahan)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.transliteration,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
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
                ),

                // Kaligrafi Nama Surah Arab
                Text(
                  surah.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Amiri',
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJuzCard(JuzInfo juz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          onTap: () => _openJuz(juz),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderCard, width: 1.2),
            ),
            child: Row(
              children: [
                // Nomor Juz Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'JUZ',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF047857),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${juz.number}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Info Juz (Mulai dari Surah apa)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Juz ${juz.number}',
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        juz.description,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Potongan Arab Awal Juz
                Flexible(
                  child: Text(
                    juz.startAyahArab,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF064E3B),
                      fontFamily: 'Amiri',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.search_status, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            const Text(
              'Surah tidak ditemukan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Tidak ada surah yang cocok dengan "$_searchQuery"',
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
