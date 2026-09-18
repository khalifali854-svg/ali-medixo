import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import 'package:khalif_ali/core/components/ali_icon.dart';
import 'package:khalif_ali/core/services/user_profile_service.dart';
import 'package:khalif_ali/core/services/subscription_service.dart';
import 'package:khalif_ali/core/components/ali_paywall_dialog.dart';

class AliHomeHubScreen extends StatelessWidget {
  final VoidCallback onOpenAac;
  final VoidCallback onOpenWriting;
  final VoidCallback onOpenCanvas;
  final VoidCallback onOpenSettings;
  final VoidCallback onAddQuickVocab;
  final VoidCallback? onOpenCatalog;
  final VoidCallback? onOpenGuessGame;
  final VoidCallback? onOpenVisualSchedule;
  final VoidCallback? onOpenChoiceBoard;
  final VoidCallback? onOpenIqro;
  final VoidCallback? onOpenQuran;
  final VoidCallback? onOpenFeedingGame;
  final VoidCallback? onOpenTreeGarden;
  final VoidCallback? onOpenReading;

  const AliHomeHubScreen({
    super.key,
    required this.onOpenAac,
    required this.onOpenWriting,
    required this.onOpenCanvas,
    required this.onOpenSettings,
    required this.onAddQuickVocab,
    this.onOpenCatalog,
    this.onOpenGuessGame,
    this.onOpenVisualSchedule,
    this.onOpenChoiceBoard,
    this.onOpenIqro,
    this.onOpenQuran,
    this.onOpenFeedingGame,
    this.onOpenTreeGarden,
    this.onOpenReading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive: 3 columns on tablet/web (>650px), 2 columns on phone/narrow screens
            final int crossAxisCount = constraints.maxWidth > 650 ? 3 : 2;
            final double cardSpacing = 6.0;

            final List<Widget> featureCards = [
              _buildAacCard(context),
              _buildReadingCard(context),
              _buildWritingCard(context),
              _buildCanvasCard(context),
              _buildGuessCard(context),
              _buildFeedingCard(context),
              _buildTreeGardenCard(context),
              _buildCatalogCard(context),
              _buildScheduleCard(context),
              _buildChoiceCard(context),
              _buildIqroCard(context),
              _buildQuranCard(context),
            ];

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Bar: Profil Ali & Portal Abi/Umma
                  _buildTopBar(context),

                  const SizedBox(height: 8),

                  // 2. Feature Cards Grid: 2 cols on mobile, 3 cols on tablet/web
                  _buildCardsGrid(featureCards, crossAxisCount, cardSpacing),

                  const SizedBox(height: 8),

                  // 3. Quick Action Ribbon (Tambah Kartu Foto Baru)
                  _buildQuickActionRibbon(),

                  const SizedBox(height: 8),

                  // 4. Pengaturan (Portal Orang Tua) - Card Khusus di Bawah
                  _buildSettingsCard(),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardsGrid(List<Widget> cards, int crossAxisCount, double spacing) {
    final List<Widget> rows = [];
    for (int i = 0; i < cards.length; i += crossAxisCount) {
      final chunk = cards.sublist(i, (i + crossAxisCount > cards.length) ? cards.length : i + crossAxisCount);
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < chunk.length; j++) ...[
                if (j > 0) SizedBox(width: spacing),
                Expanded(child: chunk[j]),
              ],
              // Add dummy expanded spacer widgets if the last row isn't full
              for (int k = 0; k < crossAxisCount - chunk.length; k++) ...[
                SizedBox(width: spacing),
                const Expanded(child: SizedBox.shrink()),
              ],
            ],
          ),
        ),
      );
    }
    return Column(
      children: rows,
    );
  }

  // ===========================================================================
  // KARTU 1: PAPAN BICARA AAC (⭐ UTAMA - FLAGSHIP FITUR ALI)
  // ===========================================================================
  Widget _buildAacCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenAac,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFCF9EE),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFEADBBE), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A346).withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentLemon,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '⭐ UTAMA',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.pureBlack,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Transparent Megaphone Illustration
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_aac_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.volume_high, size: 48, color: Color(0xFFD4A346)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Papan Bicara AAC',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Sentuh & Bersuara Nyata',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfacePillDark,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bicara',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 2: BELAJAR MEMBACA (3D CLAY BOOK ASSET)
  // ===========================================================================
  Widget _buildReadingCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenReading ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF0F9FF),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '🌟 KURIKULUM',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0284C7),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Center 3D Book Visual
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_reading_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('📖 ✨', style: TextStyle(fontSize: 40)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Belajar Baca',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Fonik 5 Level Bertahap',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Membaca',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 3: BELAJAR MENULIS
  // ===========================================================================
  Widget _buildWritingCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenWriting,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF0F7FF),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFD4E6FA), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '✏️ LATIHAN',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0284C7),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Transparent Pencil & ABC
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_writing_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.edit, size: 48, color: Color(0xFF0284C7)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Belajar Menulis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Angka, Huruf & Kata',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tulis',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 4: KANVAS GAMBAR
  // ===========================================================================
  Widget _buildCanvasCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenCanvas,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFF4F2),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFFBD7D1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '🎨 KREATIF',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFDC2626),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Transparent Palette & Brush Splash
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_canvas_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.brush_2, size: 48, color: Color(0xFFDC2626)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Kanvas Gambar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Gambar & Buat Kartu',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Gambar',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 5: TEBAK GAMBAR
  // ===========================================================================
  Widget _buildGuessCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenGuessGame ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFBEB),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD97706).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'INTERAKTIF',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB45309),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Transparent Guess Game Illustration
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_guess_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.game, size: 48, color: Color(0xFFD97706)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Tebak Gambar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Buka Foto & Sebutkan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Main',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 6: JAM MAKAN HEWAN 3D
  // ===========================================================================
  Widget _buildFeedingCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenFeedingGame ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFBEB),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD97706).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '🎮 GAME',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB45309),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Center 3D Visual Asset
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_feeding_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('🐱 🥕', style: TextStyle(fontSize: 40)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Jam Makan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Beri Makan Hewan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Makan',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 7: KEBUN POHON AJAIB
  // ===========================================================================
  Widget _buildTreeGardenCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenTreeGarden ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF0FDF4),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A34A).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '🌱 SENSORI',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF15803D),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Center Plant / Garden Visual 3D
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_tree_garden_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('🌳', style: TextStyle(fontSize: 42)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Kebun Pohon',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Siram & Petik Buah',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kebun',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 8: KATALOG KOSA KATA
  // ===========================================================================
  Widget _buildCatalogCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenCatalog ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF0FDF4),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A34A).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'RESMI',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF15803D),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Transparent Catalog Illustration
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_catalog_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.book_1, size: 54, color: Color(0xFF16A34A)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Katalog Kata',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Buku Kosa Kata Resmi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Katalog',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 9: JADWAL VISUAL
  // ===========================================================================
  Widget _buildScheduleCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenVisualSchedule ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFEFF6FF),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'RUTINITAS',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D4ED8),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Visual Schedule Illustration
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_schedule_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.calendar_1, size: 54, color: Color(0xFF2563EB)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Jadwal Visual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Pertama - Lalu & Rutin',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Jadwal',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 10: PAPAN PILIHAN (CHOICE BOARD)
  // ===========================================================================
  Widget _buildChoiceCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenChoiceBoard ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAF5FF),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFE9D5FF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9333EA).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'PILIHAN',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7E22CE),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3D Choice Board Illustration
            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_choice_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Iconsax.category, size: 54, color: Color(0xFF9333EA)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Papan Pilihan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Pilih A atau B',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF9333EA),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pilih',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 11: BELAJAR IQRO' (6 JILID)
  // ===========================================================================
  Widget _buildIqroCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenIqro ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFECFDF5),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF059669).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    'MENGAJI',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF047857),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_iqro_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Center(
                      child: Text(
                        'اقرأ',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Belajar Iqro\'',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Sentuh Huruf & Suara',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mengaji',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // KARTU 12: AL-QUR'AN DIGITAL & MUROTTAL
  // ===========================================================================
  Widget _buildQuranCard(BuildContext context) {
    return _BouncyCard(
      onTap: onOpenQuran ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF0FDF4),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A34A).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Text(
                    '30 JUZ',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF15803D),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Center(
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/hub_quran_3d.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'القرآن',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Al-Qur\'an Digital',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              '114 Surah & Murottal',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF15803D),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Baca & Dengar',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    // Dynamic greeting based on current local hour
    final hour = DateTime.now().hour;
    final String greetingText;
    final String greetingEmoji;
    final String greetingSub;

    if (hour >= 4 && hour < 11) {
      greetingText = 'Selamat Pagi';
      greetingEmoji = '☀️';
      greetingSub = 'Semangat belajar hari ini!';
    } else if (hour >= 11 && hour < 15) {
      greetingText = 'Selamat Siang';
      greetingEmoji = '🌤️';
      greetingSub = 'Ayo main & bicara bersama!';
    } else if (hour >= 15 && hour < 18) {
      greetingText = 'Selamat Sore';
      greetingEmoji = '🌅';
      greetingSub = 'Waktunya kuis & mengulang kata!';
    } else {
      greetingText = 'Selamat Malam';
      greetingEmoji = '🌙';
      greetingSub = 'Dengar cerita & doa sebelum tidur';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.borderCard, width: 1.0),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Avatar Anak di KIRI (Tap untuk buka Pengaturan / Ganti Foto)
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onOpenSettings?.call();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfacePill,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentLemon, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: ValueListenableBuilder<String?>(
                  valueListenable: UserProfileService.childAvatarNotifier,
                  builder: (context, avatarUrl, _) {
                    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
                    if (!hasAvatar) {
                      return Image.asset(
                        'assets/images/ali_logo.png',
                        fit: BoxFit.cover,
                      );
                    }
                    if (avatarUrl.startsWith('assets/')) {
                      return Image.asset(avatarUrl, fit: BoxFit.cover);
                    }
                    return Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/ali_logo.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 2. Greeting & Nama Anak (Expanded agar fleksibel & auto-wrap jika layar sempit)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Baris 1: Nama Anak Prioritas Utama (Bersih & Elegan)
                ValueListenableBuilder<String>(
                  valueListenable: UserProfileService.childNameNotifier,
                  builder: (context, currentName, _) {
                    return Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Hi, ${currentName.isNotEmpty ? currentName : "Ali"}!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              fontFamily: AppTypography.fontFamily,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('✨', style: TextStyle(fontSize: 12)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 1),
                // Baris 2: Sapaan Waktu Ringkas & Kontekstual
                Row(
                  children: [
                    Text(
                      '$greetingText $greetingEmoji',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        fontFamily: AppTypography.fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 3. Status Subscription Badge di KANAN (Unified Design Tokens)
          ValueListenableBuilder<bool>(
            valueListenable: SubscriptionService.isProNotifier,
            builder: (context, isPro, _) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AliPaywallDialog.show(
                    context,
                    featureName: 'Semua Fitur Ali Pro',
                    featureDescription:
                        'Akses tanpa batas ke seluruh kurikulum membaca, koleksi hewan 3D, tracing A-Z, dan fitur komunikasi anak.',
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPro ? AppColors.surfacePillDark : AppColors.surfacePillDark,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPro ? Icons.verified_rounded : Icons.star_rounded,
                        size: 13,
                        color: AppColors.accentLemon,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPro ? 'PRO' : 'UPGRADE',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textOnDark,
                          fontFamily: AppTypography.fontFamily,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildQuickActionRibbon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r24),
        border: Border.all(color: AppColors.borderCard, width: 1.2),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.accentLemon,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt_rounded, size: 20, color: AppColors.pureBlack),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Kartu Foto Baru',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Ambil foto nyata & rekam suara',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          _BouncyCard(
            onTap: onAddQuickVocab,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfacePillDark,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Tambah',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSettingsCard() {
    return _BouncyCard(
      onTap: onOpenSettings,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.r24),
          border: Border.all(color: AppColors.borderCard, width: 1.2),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePill,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    child: const Center(
                      child: AliIcon(Iconsax.setting_2, size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pengaturan & Profil',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Portal orang tua, suara & preferensi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfacePillDark,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Row(
                children: [
                  Text(
                    'Buka',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget kartu interaktif dengan efek skala sentuh halus (*bouncy tactile*) & haptic
class _BouncyCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncyCard({
    required this.child,
    required this.onTap,
  });

  @override
  State<_BouncyCard> createState() => _BouncyCardState();
}

class _BouncyCardState extends State<_BouncyCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
