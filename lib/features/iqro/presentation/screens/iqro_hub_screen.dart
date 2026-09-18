import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/models/iqro_models.dart';
import '../../data/iqro_repository.dart';
import 'iqro_reader_screen.dart';

class IqroHubScreen extends StatefulWidget {
  const IqroHubScreen({super.key});

  @override
  State<IqroHubScreen> createState() => _IqroHubScreenState();
}

class _IqroHubScreenState extends State<IqroHubScreen> {
  int _lastJilid = 1;
  int _lastPage = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await IqroRepository.getLastProgress();
    if (mounted) {
      setState(() {
        _lastJilid = progress.jilid;
        _lastPage = progress.page;
        _isLoading = false;
      });
    }
  }

  void _openLevel(IqroLevel level, {int initialPage = 1}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IqroReaderScreen(
          level: level,
          initialPage: initialPage,
        ),
      ),
    ).then((_) => _loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    final levels = IqroRepository.getLevels();
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
        title: const Text(
          "Belajar Iqro'",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 16,
                  vertical: 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 840 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Banner "Lanjutkan Belajar Terakhir"
                        _buildResumeBanner(levels, isTablet),

                        const SizedBox(height: 24),

                        // 2. Judul Section Pilihan Jilid
                        const Text(
                          "Pilih Jilid Iqro'",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Mulai dari Jilid 1 untuk pengenalan huruf hijaiyah dasar",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 3. Grid Kartu Jilid 1 - 6
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: levels.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 3 : 2,
                            crossAxisSpacing: isTablet ? 16 : 12,
                            mainAxisSpacing: isTablet ? 16 : 14,
                            childAspectRatio: isTablet ? 0.76 : 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final level = levels[index];
                            return _buildLevelCard(level, isTablet);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildResumeBanner(List<IqroLevel> levels, bool isTablet) {
    final currentLevel = levels.firstWhere(
      (l) => l.jilid == _lastJilid,
      orElse: () => levels.first,
    );

    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentLevel.imageAsset != null) ...[
            Container(
              width: 58,
              height: 58,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(currentLevel.imageAsset!, fit: BoxFit.contain),
              ),
            ),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "TERAKHIR DIBACA",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${currentLevel.title} • Halaman $_lastPage",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentLevel.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _openLevel(currentLevel, initialPage: _lastPage),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF065F46),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Lanjut",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                SizedBox(width: 4),
                Icon(Icons.play_arrow_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(IqroLevel level, bool isTablet) {
    final primaryColor = Color(level.primaryColorHex);
    final accentColor = Color(level.accentColorHex);

    return InkWell(
      onTap: () => _openLevel(level),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 14 : 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card: Badge Nomor Jilid & Status Free
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primaryColor, accentColor]),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "JILID ${level.jilid}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'GRATIS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 3D Clay Book Illustration
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'iqro_cover_${level.jilid}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.16),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: level.imageAsset != null
                          ? Image.asset(
                              level.imageAsset!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Iconsax.book_1,
                                size: 54,
                                color: primaryColor,
                              ),
                            )
                          : Icon(
                              Iconsax.book_1,
                              size: 54,
                              color: primaryColor,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Judul & Deskripsi Jilid
            Text(
              level.title,
              style: TextStyle(
                fontSize: isTablet ? 17 : 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              level.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),

            // Footer info halaman
            Row(
              children: [
                Icon(Iconsax.book, size: 13, color: primaryColor),
                const SizedBox(width: 4),
                Text(
                  "${IqroRepository.getPagesForJilid(level.jilid).length} Halaman",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
