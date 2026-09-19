import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_smart_input.dart';
import '../../../../core/components/ali_camera_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/user_profile_service.dart';

class OnboardingFlowScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const OnboardingFlowScreen({
    super.key,
    required this.onCompleted,
  });

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form State
  bool _isSigningIn = false;
  final TextEditingController _childNameCtrl = TextEditingController(text: 'Ali');
  String? _childAvatarUrl;
  bool _isUploadingAvatar = false;
  String _selectedAgeGroup = 'toddler'; // toddler (2-4), child (5-8), teen (9+)
  String _fatherCall = 'Abi';
  String _motherCall = 'Umma';
  String _siblingCall = 'Kakak';
  String _primaryFocus = 'communication'; // communication, fine_motor, sensory_routine
  String _speechLevel = 'emerging'; // non_verbal, emerging, verbal

  bool _isCustomFather = false;
  bool _isCustomMother = false;
  final TextEditingController _customFatherCtrl = TextEditingController();
  final TextEditingController _customMotherCtrl = TextEditingController();
  dynamic _authSubscription;

  Future<void> _pickAvatarImage({required bool fromCamera}) async {
    try {
      Uint8List? bytes;
      if (fromCamera) {
        bytes = await AliCameraHelper.capturePhoto(context);
      } else {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 600,
          maxHeight: 600,
        );
        if (picked != null) {
          bytes = await picked.readAsBytes();
        }
      }

      if (bytes == null || bytes.isEmpty) return;

      setState(() => _isUploadingAvatar = true);

      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadedUrl = await SupabaseService.uploadImage(
        bytes: bytes,
        fileName: fileName,
      );

      if (mounted) {
        setState(() {
          _childAvatarUrl = uploadedUrl;
          _isUploadingAvatar = false;
        });
        if (uploadedUrl != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Foto profil anak berhasil diunggah!'),
              backgroundColor: Color(0xFF15803D),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunggah foto: $e'),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAvatarSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Foto Profil Anak',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Foto akan disimpan aman di Cloudflare R2 untuk profil ananda.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _pickAvatarImage(fromCamera: true);
                      },
                      icon: const Icon(Icons.camera_alt_rounded, size: 20),
                      label: const Text('Kamera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.borderCard, width: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _pickAvatarImage(fromCamera: false);
                      },
                      icon: const Icon(Icons.photo_library_rounded, size: 20, color: Colors.white),
                      label: const Text('Galeri'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.pureBlack,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              if (_childAvatarUrl != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() => _childAvatarUrl = null);
                    },
                    child: const Text(
                      'Hapus Foto (Gunakan Avatar Default)',
                      style: TextStyle(color: AppColors.accentCoral, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _authSubscription = SupabaseService.authStateChanges?.listen((data) {
      if (mounted) {
        setState(() {});
        if (data.session != null && _currentStep == 1) {
          // Otomatis lanjut ke step berikutnya setelah berhasil login
          _nextStep();
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _pageController.dispose();
    _childNameCtrl.dispose();
    _customFatherCtrl.dispose();
    _customMotherCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final finalChild = _childNameCtrl.text.trim().isNotEmpty ? _childNameCtrl.text.trim() : 'Ali';
    final finalFather = _customFatherCtrl.text.trim().isNotEmpty ? _customFatherCtrl.text.trim() : _fatherCall;
    final finalMother = _customMotherCtrl.text.trim().isNotEmpty ? _customMotherCtrl.text.trim() : _motherCall;

    // 1. Simpan ke local user profile service
    await UserProfileService.updateProfile(
      newChildName: finalChild,
      newFatherCall: finalFather,
      newMotherCall: finalMother,
      newSiblingCall: _siblingCall,
      newAvatarUrl: _childAvatarUrl,
    );

    // 2. Simpan ke Supabase Profiles jika user sedang login
    final user = SupabaseService.currentUser;
    if (user != null) {
      await SupabaseService.updateCurrentUserProfile(
        childName: finalChild,
        childAgeGroup: _selectedAgeGroup,
        fatherCall: finalFather,
        motherCall: finalMother,
        siblingCall: _siblingCall,
        avatarUrl: _childAvatarUrl,
      );

      // Simpan flag has_completed_onboarding ke user_metadata Supabase
      try {
        await SupabaseService.client?.auth.updateUser(
          UserAttributes(data: {'has_completed_onboarding': true}),
        );
      } catch (_) {}
    }

    // 3. Mark onboarding complete in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);

    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            // Airbnb Style Step Header with Segmented Progress Bar
            _buildAirbnbHeader(),

            // Step Content Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Enforce step buttons
                onPageChanged: (idx) => setState(() => _currentStep = idx),
                children: [
                  _buildStepWelcome(),
                  _buildStepAuth(),
                  _buildStepChildIdentity(),
                  _buildStepFamilyCallings(),
                  _buildStepBaselineFocus(),
                ],
              ),
            ),

            // Airbnb Style Persistent Footer
            _buildAirbnbFooter(),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // AIRBNB HEADER: Back button, Logo, & Segmented Progress Bar
  // ============================================================================
  Widget _buildAirbnbHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                GestureDetector(
                  onTap: _prevStep,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textPrimary),
                    ),
                  ),
                )
              else
                const SizedBox(width: 40),

              // Brand Mark
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePill,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/ali_logo.png', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ali',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      fontFamily: AppTypography.fontFamily,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),

              // Skip / Step counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfacePill,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.borderCard, width: 0.8),
                ),
                child: Text(
                  '${_currentStep + 1} dari $_totalSteps',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Segmented Progress Bar ala Airbnb
          Row(
            children: List.generate(_totalSteps, (idx) {
              final isPassed = idx <= _currentStep;
              return Expanded(
                child: Container(
                  height: 3.5,
                  margin: EdgeInsets.only(right: idx < _totalSteps - 1 ? 4.0 : 0.0),
                  decoration: BoxDecoration(
                    color: isPassed ? AppColors.pureBlack : AppColors.surfacePill,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // AIRBNB FOOTER: Secondary Cancel & Big High-Contrast Next Button
  // ============================================================================
  Widget _buildAirbnbFooter() {
    final isLast = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        border: const Border(
          top: BorderSide(color: AppColors.borderCard, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _prevStep,
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            const SizedBox(width: 80),

          // Primary Next CTA
          AliButton(
            label: isLast ? 'Mulai Sekarang ✨' : 'Lanjutkan',
            variant: AliButtonVariant.primaryHighContrast,
            suffixIcon: AliIcon(
              isLast ? Iconsax.tick_circle : Icons.arrow_forward_rounded,
              size: 16,
              color: AppColors.pureWhite,
            ),
            onPressed: () {
              if (_currentStep == 1 && SupabaseService.currentUser == null) {
                // Di step Auth, ingatkan user login atau izinkan lewati mode tamu
                _confirmSkipAuthOrProceed();
              } else {
                _nextStep();
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmSkipAuthOrProceed() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r20)),
        title: const Text('Gunakan Sebagai Tamu?'),
        content: const Text(
          'Anda belum masuk ke Google. Data latihan hanya tersimpan di perangkat ini dan tidak tersinkronisasi ke cloud keluarga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Login Dulu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pureBlack,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _nextStep();
            },
            child: const Text('Lanjut Tamu'),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 1: WELCOME & EMOTIONAL HOOK
  // ============================================================================
  Widget _buildStepWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentLemon,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: const Text(
              'SELAMAT DATANG DI APLIKASI ALI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.pureBlack,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Sahabat Tumbuh Kembang,\nMengaji & Belajar Ananda.',
            style: AppTypography.heroHeadline(),
          ),
          const SizedBox(height: 12),
          Text(
            'Ekosistem belajar interaktif ramah sensorik: Iqro digital bersuara makhraj, membaca kata, latihan menulis, hingga mini game hewan 3D.',
            style: AppTypography.heroSubtitle(),
          ),
          const SizedBox(height: 20),

          // 4 Feature Highlight Cards (Bento Style)
          _buildBentoValueItem(
            icon: Iconsax.book_1,
            iconColor: const Color(0xFF16A34A),
            title: "Belajar Mengaji Iqro' (Jilid 1 - 6)",
            description: "100% GRATIS selamanya sebagai amal jariyah. Audio makhraj tepat dan latihan tartil interaktif.",
            badgeText: 'GRATIS PENUH',
            badgeColor: const Color(0xFFDCFCE7),
            badgeTextColor: const Color(0xFF15803D),
          ),
          const SizedBox(height: 10),
          _buildBentoValueItem(
            icon: Iconsax.translate,
            iconColor: const Color(0xFF2563EB),
            title: 'Latihan Membaca Kata & Phonics',
            description: 'Belajar mengeja suku kata visual warna-warni secara terstruktur dari kata pendek hingga kalimat.',
          ),
          const SizedBox(height: 10),
          _buildBentoValueItem(
            icon: Iconsax.pet,
            iconColor: const Color(0xFFEA580C),
            title: 'Feeding Game & Hewan 3D',
            description: 'Beri makan Si Meong dan ragam hewan lucu sambil melatih fokus dan koordinasi motorik anak.',
          ),
          const SizedBox(height: 10),
          _buildBentoValueItem(
            icon: Iconsax.tree,
            iconColor: const Color(0xFF059669),
            title: 'Kebun Belajar & Papan AAC',
            description: 'Pohon kebiasaan baik tumbuh saat anak belajar, dilengkapi papan bicara AAC dengan rekaman suara keluarga.',
          ),
        ],
      ),
    );
  }

  Widget _buildBentoValueItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        border: Border.all(color: AppColors.borderCard, width: 1.0),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: Center(child: Icon(icon, size: 22, color: iconColor)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.cardTitle(),
                      ),
                    ),
                    if (badgeText != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: badgeColor ?? AppColors.accentLemon,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: badgeTextColor ?? Colors.black,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.cardDescription(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 2: ONE-TAP AUTH (Google / Family Account)
  // ============================================================================
  Widget _buildStepAuth() {
    final user = SupabaseService.currentUser;
    final isLoggedIn = user != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text(
            'Akun Orang Tua / Caregiver',
            style: AppTypography.heroHeadline(),
          ),
          const SizedBox(height: 12),
          Text(
            'Masuk dengan akun Anda untuk mengamankan data suara keluarga, sinkronisasi antar tablet, dan pencatatan riwayat belajar.',
            style: AppTypography.heroSubtitle(),
          ),
          const SizedBox(height: 24),

          // Auth Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: AppColors.borderCard, width: 1.2),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              children: [
                if (isLoggedIn) ...[
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.accentLemon,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: Center(
                          child: Text(
                            (user.email?.isNotEmpty == true ? user.email![0].toUpperCase() : 'A'),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userMetadata?['full_name'] as String? ?? user.email ?? 'Orang Tua Ali',
                              style: AppTypography.cardTitle().copyWith(fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email ?? '',
                              style: AppTypography.bodySmall(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_rounded, size: 16, color: Color(0xFF16A34A)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Akun terverifikasi. Sesi cloud aktif & siap digunakan.',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Center(
                    child: Icon(Iconsax.security_user, size: 48, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Masuk Cepat & Aman',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Satu ketukan tanpa perlu membuat kata sandi baru.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pureBlack,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                      onPressed: _isSigningIn
                          ? null
                          : () async {
                              setState(() => _isSigningIn = true);
                              try {
                                final success = await SupabaseService.signInWithGoogle();
                                if (success && mounted) {
                                  setState(() {});
                                }
                              } finally {
                                if (mounted) setState(() => _isSigningIn = false);
                              }
                            },
                      child: _isSigningIn
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.accentLemon),
                                SizedBox(width: 6),
                                Text(
                                  'Lanjutkan dengan Google',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Dengan masuk, Anda menyetujui Ketentuan Layanan & Kebijakan Privasi Ramah Anak Ali.',
              style: AppTypography.bodySmall(color: AppColors.textMuted).copyWith(fontSize: 10.5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 3: CHILD IDENTITY (Name & Age Group)
  // ============================================================================
  Widget _buildStepChildIdentity() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text(
            'Siapa nama jagoan kecil kita?',
            style: AppTypography.heroHeadline(),
          ),
          const SizedBox(height: 12),
          Text(
            'Nama ini akan disapa oleh sistem dan digunakan saat anak menyusun kalimat: "${_childNameCtrl.text.isEmpty ? 'Ali' : _childNameCtrl.text} mau Minum!".',
            style: AppTypography.heroSubtitle(),
          ),
          // Avatar Photo Picker (Upload ke R2)
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.accentLemon.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.pureBlack, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _isUploadingAvatar
                            ? const Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.pureBlack),
                                ),
                              )
                            : (_childAvatarUrl != null && _childAvatarUrl!.isNotEmpty
                                ? Image.network(
                                    _childAvatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text('👶', style: TextStyle(fontSize: 42)),
                                    ),
                                  )
                                : const Center(
                                    child: Text('👶', style: TextStyle(fontSize: 42)),
                                  )),
                      ),
                    ),
                    GestureDetector(
                      onTap: _isUploadingAvatar ? null : () => _showAvatarSourceSheet(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.pureBlack,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.0),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _isUploadingAvatar ? null : () => _showAvatarSourceSheet(),
                  icon: const Icon(Icons.photo_camera_rounded, size: 14, color: AppColors.textPrimary),
                  label: Text(
                    _childAvatarUrl != null ? 'Ganti Foto Anak' : 'Pasang Foto Anak (Opsional)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Name Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderCard, width: 1.0),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Panggilan Anak',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                AliSmartInput(
                  controller: _childNameCtrl,
                  hintText: 'Misal: Ali / Budi / Aisyah',
                  prefixIcon: Iconsax.user_tag,
                  onChanged: (val) => setState(() {}),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Kelompok Usia',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),

          // Age Group Options (Airbnb Card Selectors)
          Row(
            children: [
              _buildAgeOption(
                key: 'toddler',
                title: 'Balita',
                subtitle: '2 - 4 Tahun',
                emoji: '🐣',
              ),
              const SizedBox(width: 8),
              _buildAgeOption(
                key: 'child',
                title: 'Anak-anak',
                subtitle: '5 - 8 Tahun',
                emoji: '🎈',
              ),
              const SizedBox(width: 8),
              _buildAgeOption(
                key: 'teen',
                title: 'Mandiri',
                subtitle: '9+ Tahun',
                emoji: '🚀',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgeOption({
    required String key,
    required String title,
    required String subtitle,
    required String emoji,
  }) {
    final isSelected = _selectedAgeGroup == key;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedAgeGroup = key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pureBlack : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r20),
            border: Border.all(
              color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected ? AppShadows.cardShadow : [],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.accentLemon : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // STEP 4: FAMILY CALLINGS (Abi/Umma, Papa/Mama, Ayah/Bunda)
  // ============================================================================
  Widget _buildStepFamilyCallings() {
    final fatherOptions = ['Abi', 'Ayah', 'Papa', 'Papi'];
    final motherOptions = ['Umma', 'Bunda', 'Mama', 'Mami'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text(
            'Panggilan Hangat Keluarga',
            style: AppTypography.heroHeadline(),
          ),
          const SizedBox(height: 12),
          Text(
            'Ali akan menggunakan panggilan ini pada kartu komunikasi dan modul suara orang tua.',
            style: AppTypography.heroSubtitle(),
          ),
          const SizedBox(height: 24),

          // Panggilan Ayah Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderCard, width: 1.0),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🧔‍♂️', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Panggilan untuk Ayah', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...fatherOptions.map((opt) {
                      final isSel = !_isCustomFather && _fatherCall == opt;
                      return ChoiceChip(
                        label: Text(opt),
                        selected: isSel,
                        selectedColor: AppColors.pureBlack,
                        backgroundColor: AppColors.surfacePill,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSel ? AppColors.accentLemon : AppColors.textPrimary,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _isCustomFather = false;
                              _fatherCall = opt;
                              _customFatherCtrl.clear();
                            });
                          }
                        },
                      );
                    }),
                    ChoiceChip(
                      label: const Text('Lainnya (Ketik)'),
                      selected: _isCustomFather,
                      selectedColor: AppColors.pureBlack,
                      backgroundColor: AppColors.surfacePill,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _isCustomFather ? AppColors.accentLemon : AppColors.textPrimary,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _isCustomFather = true;
                          if (_customFatherCtrl.text.isNotEmpty) {
                            _fatherCall = _customFatherCtrl.text.trim();
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (_isCustomFather) ...[
                  const SizedBox(height: 14),
                  AliSmartInput(
                    controller: _customFatherCtrl,
                    hintText: 'Ketik panggilan untuk Ayah (misal: Baba, Papa, dll.)',
                    prefixIcon: Iconsax.edit_2,
                    onChanged: (val) {
                      setState(() {
                        if (val.trim().isNotEmpty) _fatherCall = val.trim();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Panggilan Ibu Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderCard, width: 1.0),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🧕', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Panggilan untuk Ibu', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...motherOptions.map((opt) {
                      final isSel = !_isCustomMother && _motherCall == opt;
                      return ChoiceChip(
                        label: Text(opt),
                        selected: isSel,
                        selectedColor: AppColors.pureBlack,
                        backgroundColor: AppColors.surfacePill,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSel ? AppColors.accentLemon : AppColors.textPrimary,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _isCustomMother = false;
                              _motherCall = opt;
                              _customMotherCtrl.clear();
                            });
                          }
                        },
                      );
                    }),
                    ChoiceChip(
                      label: const Text('Lainnya (Ketik)'),
                      selected: _isCustomMother,
                      selectedColor: AppColors.pureBlack,
                      backgroundColor: AppColors.surfacePill,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _isCustomMother ? AppColors.accentLemon : AppColors.textPrimary,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _isCustomMother = true;
                          if (_customMotherCtrl.text.isNotEmpty) {
                            _motherCall = _customMotherCtrl.text.trim();
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (_isCustomMother) ...[
                  const SizedBox(height: 14),
                  AliSmartInput(
                    controller: _customMotherCtrl,
                    hintText: 'Ketik panggilan untuk Ibu (misal: Ambu, Enin, dll.)',
                    prefixIcon: Iconsax.edit_2,
                    onChanged: (val) {
                      setState(() {
                        if (val.trim().isNotEmpty) _motherCall = val.trim();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STEP 5: BASELINE FOCUS & SPEECH LEVEL
  // ============================================================================
  Widget _buildStepBaselineFocus() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text(
            'Fokus Utama Terapi Anak',
            style: AppTypography.heroHeadline(),
          ),
          const SizedBox(height: 12),
          Text(
            'Kami akan menyesuaikan susunan beranda agar fitur yang paling dibutuhkan berada paling depan.',
            style: AppTypography.heroSubtitle(),
          ),
          const SizedBox(height: 24),

          _buildFocusCard(
            key: 'communication',
            icon: Iconsax.message_favorite,
            title: 'Mulai Bicara & Komunikasi',
            subtitle: 'Fokus pada kartu AAC bergambar riil, pilihan A/B, dan ekspresi keinginan dasar.',
          ),
          const SizedBox(height: 12),
          _buildFocusCard(
            key: 'fine_motor',
            icon: Iconsax.brush_1,
            title: 'Motorik Halus & Menulis',
            subtitle: 'Latihan tracing huruf, angka, dan coretan bebas tanpa tekanan visual.',
          ),
          const SizedBox(height: 12),
          _buildFocusCard(
            key: 'sensory_routine',
            icon: Iconsax.calendar_tick,
            title: 'Kemandirian & Rutinitas',
            subtitle: 'Jadwal visual terstruktur First-Then untuk mengurangi kecemasan transisi kegiatan.',
          ),
        ],
      ),
    );
  }

  Widget _buildFocusCard({
    required String key,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _primaryFocus == key;

    return GestureDetector(
      onTap: () => setState(() => _primaryFocus = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pureBlack : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          border: Border.all(
            color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentLemon : AppColors.surfacePill,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? AppColors.pureBlack : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontFamily: AppTypography.fontFamily,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                      fontFamily: AppTypography.fontFamily,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.accentLemon, size: 24),
          ],
        ),
      ),
    );
  }
}
