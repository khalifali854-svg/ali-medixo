import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import 'package:khalif_ali/core/components/ali_icon.dart';
import 'package:khalif_ali/core/services/user_profile_service.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar: Profil Ali & Portal Abi/Umma
              _buildTopBar(context),

              const SizedBox(height: 4),

              // 2. Baris 1: AAC & Belajar Menulis (2 Kolom)
              _buildRow1AacAndWriting(context),

              const SizedBox(height: 4),

              // 3. Baris 2: Kanvas Gambar & Tebak Gambar (2 Kolom)
              _buildRow2CanvasAndGuess(context),

              const SizedBox(height: 4),

              // 4. Baris 3: Katalog Kosa Kata & Jadwal Visual (2 Kolom)
              _buildRow3CatalogAndSchedule(context),

              const SizedBox(height: 4),

              // 5. Baris 4: Papan Pilihan & Belajar Iqro' (2 Kolom)
              _buildRow4ChoiceAndIqro(context),

              const SizedBox(height: 4),

              // 6. Quick Action Ribbon (Tambah Kartu Foto Baru)
              _buildQuickActionRibbon(),

              const SizedBox(height: 4),

              // 7. Pengaturan (Portal Orang Tua) - Card Khusus di Bawah
              _buildSettingsCard(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // BARIS 1: AAC & Belajar Menulis
  // ===========================================================================
  Widget _buildRow1AacAndWriting(BuildContext context) {
    return Row(
      children: [
        // KARTU 1: Papan Bicara AAC
        Expanded(
          child: _BouncyCard(
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
          ),
        ),

        const SizedBox(width: 4),

        // KARTU 2: Belajar Menulis
        Expanded(
          child: _BouncyCard(
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
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BARIS 2: Kanvas Gambar & Tebak Gambar
  // ===========================================================================
  Widget _buildRow2CanvasAndGuess(BuildContext context) {
    return Row(
      children: [
        // KARTU 3: Kanvas Gambar
        Expanded(
          child: _BouncyCard(
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
          ),
        ),

        const SizedBox(width: 4),

        // KARTU 4: Tebak Gambar
        Expanded(
          child: _BouncyCard(
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
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BARIS 3: Katalog Kosa Kata & Jadwal Visual
  // ===========================================================================
  Widget _buildRow3CatalogAndSchedule(BuildContext context) {
    return Row(
      children: [
        // KARTU 5: Katalog Kosa Kata
        Expanded(
          child: _BouncyCard(
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
          ),
        ),

        const SizedBox(width: 4),

        // KARTU 6: Jadwal Visual
        Expanded(
          child: _BouncyCard(
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
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // BARIS 4: Papan Pilihan & Belajar Iqro'
  // ===========================================================================
  Widget _buildRow4ChoiceAndIqro(BuildContext context) {
    return Row(
      children: [
        // KARTU 7: Papan Pilihan (Choice Board)
        Expanded(
          child: _BouncyCard(
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
          ),
        ),

        const SizedBox(width: 4),

        // KARTU 8: Belajar Iqro' (6 Jilid)
        Expanded(
          child: _BouncyCard(
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
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.borderCard, width: 1.0),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfacePill,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ali_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: UserProfileService.childNameNotifier,
                    builder: (context, currentName, _) {
                      return Row(
                        children: [
                          Text(
                            'Halo, $currentName!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              fontFamily: AppTypography.fontFamily,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('✨', style: TextStyle(fontSize: 14)),
                        ],
                      );
                    },
                  ),
                  const Text(
                    'Ayo bicara, belajar & bermain!',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: onOpenSettings,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfacePill,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderCard, width: 0.8),
              ),
              child: const Icon(
                Icons.settings_outlined,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
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
          Row(
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
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Kartu Foto Baru',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Ambil foto nyata & rekam suara',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

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
            Row(
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
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengaturan & Profil',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Portal orang tua, suara & preferensi',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
