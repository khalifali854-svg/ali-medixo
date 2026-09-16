import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onAddNewVocab;
  final VoidCallback? onBack;

  const SettingsScreen({
    super.key,
    this.onAddNewVocab,
    this.onBack,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _activeTab = 0;
  bool _hapticFeedback = true;
  bool _highContrastMode = true;
  bool _autoSyncCloud = true;
  bool _voiceVolumeBoost = true;
  bool _isLoggingIn = false;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    AudioEngineService.fetchAvailableVoices().then((_) {
      if (mounted) setState(() {});
    });
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await SupabaseService.getCurrentUserProfile();
    if (mounted) {
      setState(() => _userProfile = profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = SupabaseService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Header Section (Margin 4px)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin), // Exactly 4.0
                child: AliHeaderSection(
                  title: 'Pengaturan & Akun',
                  onBackTap: widget.onBack,
                  tabs: const ['Akun & Paket Pro', 'Suara & Sensorik', 'Jurnal Aktivitas'],
                  activeTabIndex: _activeTab,
                  onTabChanged: (idx) => setState(() => _activeTab = idx),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // ================= TAB 0: PROFIL & LANGGANAN =================
            if (_activeTab == 0) ...[
              // 1. Akun Profile Card (Google Auth / Status Akun)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: currentUser == null
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              final isCompact = constraints.maxWidth < 460;
                              final loginBtn = AliButton(
                                label: _isLoggingIn ? 'Memproses...' : 'Masuk Google',
                                prefixIcon: const AliIcon(Iconsax.login, size: 16, color: AppColors.pureWhite),
                                variant: AliButtonVariant.primaryHighContrast,
                                size: AliButtonSize.small,
                                isLoading: _isLoggingIn,
                                onPressed: _isLoggingIn
                                    ? null
                                    : () async {
                                        setState(() => _isLoggingIn = true);
                                        final ok = await SupabaseService.signInWithGoogle();
                                        if (mounted) {
                                          setState(() => _isLoggingIn = false);
                                        }
                                      },
                              );

                              if (isCompact) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppColors.surfacePill,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: AppColors.borderCard, width: 1.0),
                                          ),
                                          child: const Center(
                                            child: Icon(Iconsax.user, size: 22, color: AppColors.textSecondary),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.s12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Masuk ke Akun Keluarga', style: AppTypography.cardTitle()),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Simpan cloud & sinkronisasi tablet',
                                                style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(width: double.infinity, child: loginBtn),
                                  ],
                                );
                              }

                              return Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfacePill,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                                    ),
                                    child: const Center(
                                      child: Icon(Iconsax.user, size: 24, color: AppColors.textSecondary),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.s12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Masuk ke Akun Keluarga', style: AppTypography.cardTitle()),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Simpan data cloud, suara keluarga, & sinkronisasi tablet',
                                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  loginBtn,
                                ],
                              );
                            },
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final isCompact = constraints.maxWidth < 460;
                              final tier = _userProfile?['subscription_tier']?.toString() ?? 'free';
                              final isPro = tier == 'pro';

                              final tierBadge = Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isPro ? AppColors.pureBlack : AppColors.surfacePill,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  border: Border.all(
                                    color: isPro ? AppColors.accentLemon : AppColors.borderCard,
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  isPro ? '⭐ ALI PRO' : 'FREE TIER (10 KARTU)',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: isPro ? AppColors.accentLemon : AppColors.textSecondary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              );

                              final logoutBtn = IconButton(
                                tooltip: 'Keluar',
                                icon: const Icon(Iconsax.logout, size: 20, color: AppColors.accentCoral),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r20)),
                                      title: const Text('Keluar Akun?'),
                                      content: const Text('Karya dan data cloud akan tetap aman di akun Anda.'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Keluar', style: TextStyle(color: AppColors.accentCoral)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await SupabaseService.signOut();
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.remove('has_completed_onboarding');
                                    if (mounted) setState(() {});
                                  }
                                },
                              );

                              final avatar = Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.accentLemon,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.borderCard, width: 1.0),
                                ),
                                child: Center(
                                  child: Text(
                                    (currentUser.email?.isNotEmpty == true
                                        ? currentUser.email![0].toUpperCase()
                                        : 'A'),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );

                              final name = _userProfile?['full_name'] as String? ??
                                  currentUser.userMetadata?['full_name'] as String? ??
                                  currentUser.email ??
                                  'Orang Tua Ali';

                              if (isCompact) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        avatar,
                                        const SizedBox(width: AppSpacing.s12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                style: AppTypography.cardTitle(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                currentUser.email ?? 'Akun Terhubung',
                                                style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        logoutBtn,
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    tierBadge,
                                  ],
                                );
                              }

                              return Row(
                                children: [
                                  avatar,
                                  const SizedBox(width: AppSpacing.s12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                name,
                                                style: AppTypography.cardTitle(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            tierBadge,
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          currentUser.email ?? 'Akun Terhubung',
                                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  logoutBtn,
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)),

              // 2. Personalisasi Nama Anak & Panggilan Keluarga
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.s8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.surfacePill,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const AliIcon(Iconsax.profile_2user, size: 18, color: AppColors.textPrimary),
                                ),
                                const SizedBox(width: AppSpacing.s10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Profil Anak & Panggilan Keluarga', style: AppTypography.titleMedium()),
                                    Text(
                                      'Nama anak dan suara pemandu di seluruh modul Ali',
                                      style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s14),
                        const Divider(color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: AppSpacing.s12),

                        // Nama Anak Input
                        _ProfileTextField(
                          label: 'Nama Anak',
                          hint: 'Misal: Ali',
                          icon: Iconsax.user,
                          initialValue: UserProfileService.childName,
                          onSaved: (val) {
                            UserProfileService.updateProfile(
                              newChildName: val,
                              newFatherCall: UserProfileService.fatherCall,
                              newMotherCall: UserProfileService.motherCall,
                              newSiblingCall: UserProfileService.siblingCall,
                            );
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: AppSpacing.s10),

                        // Panggilan Ayah & Ibu (Responsive Stack / Side-by-side)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 460;
                            final ayahField = _ProfileTextField(
                              label: 'Panggilan Ayah',
                              hint: 'Abi / Papa / Ayah',
                              icon: Iconsax.man,
                              initialValue: UserProfileService.fatherCall,
                              onSaved: (val) {
                                UserProfileService.updateProfile(
                                  newChildName: UserProfileService.childName,
                                  newFatherCall: val,
                                  newMotherCall: UserProfileService.motherCall,
                                  newSiblingCall: UserProfileService.siblingCall,
                                );
                                setState(() {});
                              },
                            );

                            final ibuField = _ProfileTextField(
                              label: 'Panggilan Ibu',
                              hint: 'Umma / Mama / Ibu',
                              icon: Iconsax.woman,
                              initialValue: UserProfileService.motherCall,
                              onSaved: (val) {
                                UserProfileService.updateProfile(
                                  newChildName: UserProfileService.childName,
                                  newFatherCall: UserProfileService.fatherCall,
                                  newMotherCall: val,
                                  newSiblingCall: UserProfileService.siblingCall,
                                );
                                setState(() {});
                              },
                            );

                            if (isCompact) {
                              return Column(
                                children: [
                                  ayahField,
                                  const SizedBox(height: AppSpacing.s10),
                                  ibuField,
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: ayahField),
                                const SizedBox(width: AppSpacing.s10),
                                Expanded(child: ibuField),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.s10),

                        // Panggilan Saudara
                        _ProfileTextField(
                          label: 'Panggilan Saudara (Kakak / Adik)',
                          hint: 'Misal: Alesha / Kakak / Adik',
                          icon: Iconsax.people,
                          initialValue: UserProfileService.siblingCall,
                          onSaved: (val) {
                            UserProfileService.updateProfile(
                              newChildName: UserProfileService.childName,
                              newFatherCall: UserProfileService.fatherCall,
                              newMotherCall: UserProfileService.motherCall,
                              newSiblingCall: val,
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)),

              // 3. Ali Pro Upgrade Card (Rp 99.000 / Bulan)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.accentLemon.withOpacity(0.5), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentLemon,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 14, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(
                                    'PAKET KELUARGA LENGKAP',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Rp 99.000 / bln',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.accentLemon,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Ali Family Pro ⭐',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Akses tanpa batas ke seluruh ekosistem komunikasi, motorik, dan jurnal evaluasi anak.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.4),
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: Color(0xFF334155), height: 1),
                        const SizedBox(height: 14),
                        const Column(
                          children: [
                            _ProFeatureRow(title: 'Unlimited Kosa Kata AAC & Bebas Tambah Foto Kamera Asli'),
                            SizedBox(height: 8),
                            _ProFeatureRow(title: 'Rekam Suara Abi & Umma Sepuasnya untuk Semua Kartu'),
                            SizedBox(height: 8),
                            _ProFeatureRow(title: 'Choice Board 4 Pilihan & Jadwal Rutinitas Mingguan'),
                            SizedBox(height: 8),
                            _ProFeatureRow(title: 'Sinkronisasi Multi-Device Cloudflare & Supabase'),
                            SizedBox(height: 8),
                            _ProFeatureRow(title: 'Jurnal Telemetri Lengkap Siap Dibagikan ke Terapis'),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Builder(
                          builder: (context) {
                            final isPro = _userProfile?['subscription_tier'] == 'pro';
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPro ? const Color(0xFF334155) : AppColors.accentLemon,
                                  foregroundColor: isPro ? Colors.white : Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                                  elevation: 0,
                                ),
                                onPressed: isPro
                                    ? null
                                    : () async {
                                        HapticFeedback.heavyImpact();
                                        final ok = await SupabaseService.updateCurrentUserProfile(subscriptionTier: 'pro');
                                        if (ok && mounted) {
                                          await _loadUserProfile();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Selamat! Akun Anda kini aktif sebagai Ali Pro ⭐'),
                                              backgroundColor: Color(0xFF15803D),
                                            ),
                                          );
                                        }
                                      },
                                child: Text(
                                  isPro ? 'Status: Akun Pro Aktif ✓' : 'Aktifkan Ali Pro Sekarang (Rp 99k/bln)',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // ================= TAB 1: SUARA & SENSORIK =================
            if (_activeTab == 1) ...[
              // Audio & Sensoric Configuration Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.s8),
                              decoration: const BoxDecoration(
                                color: AppColors.surfacePill,
                                shape: BoxShape.circle,
                              ),
                              child: const AliIcon(Iconsax.voice_cricle, size: 18, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: AppSpacing.s10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pengaturan Suara & Bot Pelafalan', style: AppTypography.titleMedium()),
                                Text(
                                  'Pilihan suara pembaca teks dan prioritas suara keluarga',
                                  style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s14),
                        const Divider(color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: AppSpacing.s14),

                        // Pilihan Bahasa Pembaca / Bot Suara
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 460;
                            final selector = Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfacePill,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(color: AppColors.borderCard),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: AudioEngineService.currentLanguage,
                                  icon: const Icon(Iconsax.arrow_down_1, size: 14, color: AppColors.textPrimary),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  items: const [
                                    DropdownMenuItem(value: 'id-ID', child: Text('🇮🇩 Bahasa Indonesia')),
                                    DropdownMenuItem(value: 'en-US', child: Text('🇺🇸 English (US)')),
                                    DropdownMenuItem(value: 'ar-SA', child: Text('🇸🇦 Bahasa Arab')),
                                  ],
                                  onChanged: (val) async {
                                    if (val != null) {
                                      HapticFeedback.selectionClick();
                                      await AudioEngineService.setLanguage(val);
                                      if (mounted) setState(() {});
                                      await AudioEngineService.speakWord(
                                        text: val == 'id-ID'
                                            ? 'Halo ${UserProfileService.childName}, bahasa Indonesia aktif'
                                            : val == 'en-US'
                                                ? 'Hello ${UserProfileService.childName}, English language is active'
                                                : 'مرحبا يا ${UserProfileService.childName}',
                                      );
                                    }
                                  },
                                ),
                              ),
                            );

                            if (isCompact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      AliIcon(Iconsax.translate, size: 20, color: AppColors.textPrimary),
                                      SizedBox(width: AppSpacing.s10),
                                      Text(
                                        'Bahasa Suara Pembaca',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pilih bahasa standar untuk pelafalan',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 8),
                                  selector,
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Row(
                                    children: [
                                      AliIcon(Iconsax.translate, size: 20, color: AppColors.textPrimary),
                                      SizedBox(width: AppSpacing.s10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Bahasa Suara Pembaca',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                            ),
                                            Text(
                                              'Pilih bahasa standar untuk pelafalan',
                                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                selector,
                              ],
                            );
                          },
                        ),

                        // Model Bot Suara jika tersedia di perangkat
                        if (AudioEngineService.availableVoices.isNotEmpty) ...[
                          const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isCompact = constraints.maxWidth < 460;
                              final targetPrefix = AudioEngineService.currentLanguage.toLowerCase().split('-').first;
                              final filteredVoices = AudioEngineService.availableVoices.where((v) {
                                final loc = (v['locale'] ?? '').toLowerCase().replaceAll('_', '-');
                                final name = (v['name'] ?? '').toLowerCase();
                                return loc.contains(targetPrefix) || name.contains(targetPrefix);
                              }).toList();

                              final displayVoices = filteredVoices.isNotEmpty ? filteredVoices : AudioEngineService.availableVoices;
                              final currentValue = displayVoices.any((v) => v['name'] == AudioEngineService.selectedVoiceName)
                                  ? AudioEngineService.selectedVoiceName
                                  : (displayVoices.isNotEmpty ? displayVoices.first['name'] : null);

                              final selector = Container(
                                constraints: BoxConstraints(maxWidth: isCompact ? double.infinity : 200),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfacePill,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  border: Border.all(color: AppColors.borderCard),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: currentValue,
                                    isExpanded: true,
                                    icon: const Icon(Iconsax.arrow_down_1, size: 14, color: AppColors.textPrimary),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    items: displayVoices.map((v) {
                                      final name = v['name']!;
                                      final loc = v['locale'] ?? '';
                                      return DropdownMenuItem<String>(
                                        value: name,
                                        child: Text(
                                          '$name ($loc)',
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (voice) async {
                                      if (voice != null) {
                                        HapticFeedback.selectionClick();
                                        await AudioEngineService.setVoiceBot(voice);
                                        if (mounted) setState(() {});
                                        await AudioEngineService.speakWord(
                                          text: 'Suara bot berhasil diubah',
                                        );
                                      }
                                    },
                                  ),
                                ),
                              );

                              if (isCompact) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        AliIcon(Iconsax.voice_square, size: 20, color: AppColors.textPrimary),
                                        SizedBox(width: AppSpacing.s10),
                                        Text(
                                          'Model Karakter Bot',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Karakter suara TTS dari sistem perangkat',
                                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 8),
                                    selector,
                                  ],
                                );
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Row(
                                      children: [
                                        AliIcon(Iconsax.voice_square, size: 20, color: AppColors.textPrimary),
                                        SizedBox(width: AppSpacing.s10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Model Karakter Bot',
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                              ),
                                              Text(
                                                'Karakter suara TTS dari sistem perangkat',
                                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  selector,
                                ],
                              );
                            },
                          ),
                        ],

                        const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),

                        // Pemandu Suara Asli (Abi & Umma)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 460;
                            final selector = Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfacePill,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(color: AppColors.borderCard),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      AudioEngineService.setVoiceSource(ActiveVoiceSource.abi);
                                      if (mounted) setState(() {});
                                      AudioEngineService.speakWord(text: 'Pemandu Suara ${UserProfileService.fatherCall} aktif');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AudioEngineService.activeVoiceSource == ActiveVoiceSource.abi
                                            ? AppColors.surfacePillDark
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(AppRadius.pill),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const AliIcon(Iconsax.voice_square, size: 14, color: AppColors.accentLemon),
                                          const SizedBox(width: 4),
                                          Text(
                                            UserProfileService.fatherCall,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AudioEngineService.activeVoiceSource == ActiveVoiceSource.abi
                                                  ? AppColors.textOnDark
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      AudioEngineService.setVoiceSource(ActiveVoiceSource.umma);
                                      if (mounted) setState(() {});
                                      AudioEngineService.speakWord(text: 'Pemandu Suara ${UserProfileService.motherCall} aktif');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AudioEngineService.activeVoiceSource == ActiveVoiceSource.umma
                                            ? AppColors.surfacePillDark
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(AppRadius.pill),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const AliIcon(Iconsax.heart, size: 14, color: AppColors.accentCoral),
                                          const SizedBox(width: 4),
                                          Text(
                                            UserProfileService.motherCall,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AudioEngineService.activeVoiceSource == ActiveVoiceSource.umma
                                                  ? AppColors.textOnDark
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (isCompact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      AliIcon(Iconsax.profile_2user, size: 20, color: AppColors.textPrimary),
                                      SizedBox(width: AppSpacing.s10),
                                      Text(
                                        'Prioritas Suara Asli',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Gunakan rekaman suara ${UserProfileService.fatherCall} atau ${UserProfileService.motherCall}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 8),
                                  selector,
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const AliIcon(Iconsax.profile_2user, size: 20, color: AppColors.textPrimary),
                                      const SizedBox(width: AppSpacing.s10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Prioritas Suara Asli',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                            ),
                                            Text(
                                              'Gunakan rekaman suara ${UserProfileService.fatherCall} atau ${UserProfileService.motherCall}',
                                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                selector,
                              ],
                            );
                          },
                        ),

                        const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),

                        // Kecepatan Suara
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 460;
                            final selector = Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfacePill,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(color: AppColors.borderCard),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  value: const [0.46, 0.55, 0.65, 0.75].contains(AudioEngineService.speechRate)
                                      ? AudioEngineService.speechRate
                                      : 0.46,
                                  icon: const Icon(Iconsax.arrow_down_1, size: 14, color: AppColors.textPrimary),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  items: const [
                                    DropdownMenuItem(value: 0.46, child: Text('Santai (0.75x)')),
                                    DropdownMenuItem(value: 0.55, child: Text('Normal (1.0x)')),
                                    DropdownMenuItem(value: 0.65, child: Text('Cepat (1.15x)')),
                                    DropdownMenuItem(value: 0.75, child: Text('Sangat Cepat (1.3x)')),
                                  ],
                                  onChanged: (newRate) async {
                                    if (newRate != null) {
                                      HapticFeedback.selectionClick();
                                      await AudioEngineService.setSpeechRate(newRate);
                                      if (mounted) setState(() {});
                                      await AudioEngineService.speakWord(
                                        text: 'Kecepatan suara sudah diperbarui',
                                      );
                                    }
                                  },
                                ),
                              ),
                            );

                            if (isCompact) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      AliIcon(Iconsax.timer_1, size: 20, color: AppColors.textPrimary),
                                      SizedBox(width: AppSpacing.s10),
                                      Text(
                                        'Kecepatan Suara Bot',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Atur tempo pelafalan kata untuk artikulasi jelas',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 8),
                                  selector,
                                ],
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Row(
                                    children: [
                                      AliIcon(Iconsax.timer_1, size: 20, color: AppColors.textPrimary),
                                      SizedBox(width: AppSpacing.s10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Kecepatan Suara Bot',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                            ),
                                            Text(
                                              'Atur tempo pelafalan kata untuk artikulasi jelas',
                                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                selector,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)),

              // Sensoric & Accessibility Switches
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sensori & Aksesibilitas', style: AppTypography.titleMedium()),
                        const SizedBox(height: AppSpacing.s12),
                        _SettingsSwitchTile(
                          icon: Iconsax.finger_cricle,
                          title: 'Getaran Haptic Ramah Anak',
                          subtitle: 'Feedback getar lembut saat anak menekan kartu AAC',
                          value: _hapticFeedback,
                          onChanged: (val) => setState(() => _hapticFeedback = val),
                        ),
                        const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),
                        _SettingsSwitchTile(
                          icon: Iconsax.eye,
                          title: 'Kontras Tinggi & Font Airbnb Cereal',
                          subtitle: 'Membantu fokus penglihatan dengan teks kontras tebal',
                          value: _highContrastMode,
                          onChanged: (val) => setState(() => _highContrastMode = val),
                        ),
                        const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),
                        _SettingsSwitchTile(
                          icon: Iconsax.volume_high,
                          title: 'Pengeras Suara Audio Pemandu',
                          subtitle: 'Optimalisasi volume suara keluarga agar terdengar jelas',
                          value: _voiceVolumeBoost,
                          onChanged: (val) => setState(() => _voiceVolumeBoost = val),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // ================= TAB 2: JURNAL & CLOUD TELEMETRI =================
            if (_activeTab == 2) ...[
              // 1. Live Activity Telemetry Logs from Supabase
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: SupabaseService.getChildActivityLogs(limit: 6),
                      builder: (context, snapshot) {
                        final logs = snapshot.data ?? [];
                        final isLoading = snapshot.connectionState == ConnectionState.waiting;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(AppSpacing.s8),
                                      decoration: const BoxDecoration(
                                        color: AppColors.surfacePill,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const AliIcon(Iconsax.chart_2, size: 18, color: AppColors.accentSky),
                                    ),
                                    const SizedBox(width: AppSpacing.s10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jurnal Aktivitas ${UserProfileService.childName}', style: AppTypography.titleMedium()),
                                        Text(
                                          'Telemetri komunikasi AAC, jadwal, & latihan',
                                          style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfacePill,
                                    borderRadius: BorderRadius.circular(AppRadius.pill),
                                  ),
                                  child: Text(
                                    logs.isNotEmpty ? '${logs.length} Tercatat' : 'Live Sync',
                                    style: AppTypography.bodySmall(color: AppColors.accentSky),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s14),
                            const Divider(color: AppColors.borderSubtle, height: 1),
                            const SizedBox(height: AppSpacing.s12),

                            if (isLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                                  ),
                                ),
                              )
                            else if (logs.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.s16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceCardSubtle,
                                  borderRadius: BorderRadius.circular(AppRadius.r16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Iconsax.info_circle, size: 20, color: AppColors.textMuted),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Belum ada riwayat aktivitas. Riwayat komunikasi anak di papan AAC, jadwal, dan kuis tebak kata akan muncul otomatis di sini.',
                                        style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: logs.length,
                                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s6),
                                itemBuilder: (context, idx) {
                                  final item = logs[idx];
                                  final actType = item['activity_type']?.toString() ?? 'aac_speech';
                                  final metadata = item['metadata'] is Map ? item['metadata'] as Map : {};
                                  final text = item['target_label']?.toString() ??
                                      metadata['text']?.toString() ??
                                      metadata['label']?.toString() ??
                                      metadata['chosen_item']?.toString() ??
                                      metadata['schedule_label']?.toString() ??
                                      'Aktivitas ${UserProfileService.childName}';
                                  final createdAt = item['created_at']?.toString() ?? '';
                                  String timeStr = 'Baru saja';
                                  if (createdAt.isNotEmpty) {
                                    try {
                                      final dt = DateTime.parse(createdAt).toLocal();
                                      timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                                    } catch (_) {}
                                  }

                                  String category = 'AAC';
                                  if (actType == 'choice_made') category = 'Pilihan';
                                  if (actType == 'schedule_completed') category = 'Jadwal';
                                  if (actType == 'guess_game_speech') category = 'Tebak Gambar';
                                  if (actType == 'writing_tracing') category = 'Menulis';

                                  return _ActivityHistoryRow(
                                    time: timeStr,
                                    sentence: text,
                                    category: category,
                                    voiceSource: category,
                                  );
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)),

            ],

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _ProFeatureRow extends StatelessWidget {
  final String title;
  const _ProFeatureRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentLemon),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12.5, color: Colors.white, height: 1.3),
          ),
        ),
      ],
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s8),
          decoration: const BoxDecoration(
            color: AppColors.surfacePill,
            shape: BoxShape.circle,
          ),
          child: AliIcon(icon, size: 16, color: AppColors.textPrimary),
        ),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleSmall()),
              const SizedBox(height: AppSpacing.s2),
              Text(subtitle, style: AppTypography.bodySmall()),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeTrackColor: AppColors.surfacePillDark,
          activeColor: AppColors.accentLemon,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ProfileTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final String initialValue;
  final ValueChanged<String> onSaved;

  const _ProfileTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.initialValue,
    required this.onSaved,
  });

  @override
  State<_ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<_ProfileTextField> {
  late TextEditingController _ctrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _ProfileTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.initialValue != _ctrl.text) {
      _ctrl.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
      decoration: BoxDecoration(
        color: AppColors.surfacePill,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(
          color: _isEditing ? AppColors.accentSky : AppColors.borderCard,
          width: _isEditing ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          AliIcon(widget.icon, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                TextField(
                  controller: _ctrl,
                  onTap: () => setState(() => _isEditing = true),
                  onSubmitted: (val) {
                    setState(() => _isEditing = false);
                    widget.onSaved(val);
                  },
                  onEditingComplete: () {
                    setState(() => _isEditing = false);
                    widget.onSaved(_ctrl.text);
                  },
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (_isEditing)
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() => _isEditing = false);
                widget.onSaved(_ctrl.text);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentLemon,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.pureBlack),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityHistoryRow extends StatelessWidget {
  final String time;
  final String sentence;
  final String category;
  final String voiceSource;

  const _ActivityHistoryRow({
    required this.time,
    required this.sentence,
    required this.category,
    required this.voiceSource,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardSubtle,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.borderSubtle, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfacePill,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Text(
              sentence,
              style: AppTypography.titleSmall(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.surfacePill,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              voiceSource,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

