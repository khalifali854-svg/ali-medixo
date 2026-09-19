import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/user_profile_service.dart';
import 'package:khalif_ali/features/writing_practice/presentation/screens/writing_practice_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  final VoidCallback onAddNewVocab;

  const ParentDashboardScreen({
    super.key,
    required this.onAddNewVocab,
  });

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _activeTab = 0;
  bool _offlineMode = false;
  bool _voiceFeedback = true;
  bool _autoBackgroundRemoval = true;
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = SupabaseService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Portal Abi (Margin 4px)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin), // Exactly 4.0
                child: AliHeaderSection(
                  title: 'Portal Abi & Umma',
                  onAddTap: widget.onAddNewVocab,
                  tabs: const ['Ringkasan Ali', 'Aktivitas Kosa Kata'],
                  activeTabIndex: _activeTab,
                  onTabChanged: (idx) => setState(() => _activeTab = idx),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // 0. Akun & Langganan (Google Auth Status) Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppRadius.r24),
                    border: Border.all(color: AppColors.borderCard, width: 1.0),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: currentUser == null
                      ? Row(
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
                                  Text('Akun Keluarga Ali', style: AppTypography.titleMedium()),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Masuk untuk simpan data cloud & langganan publik',
                                    style: AppTypography.bodySmall(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            AliButton(
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
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
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
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          currentUser.userMetadata?['full_name'] as String? ??
                                              currentUser.email ??
                                              'Orang Tua Ali',
                                          style: AppTypography.titleMedium(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentLime,
                                          borderRadius: BorderRadius.circular(AppRadius.pill),
                                        ),
                                        child: const Text(
                                          'TRIAL 7 HARI',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
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
                            IconButton(
                              tooltip: 'Keluar',
                              icon: const Icon(Iconsax.logout, size: 20, color: AppColors.accentCoral),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r20)),
                                    title: const Text('Keluar Akun?'),
                                    content: const Text('Karya dan data cloud akan tetap aman di akun Google Anda.'),
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
                                  if (mounted) setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // 1. Metric Insight Card Section (Margin 4px)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin), // Exactly 4.0
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s14),
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
                                padding: const EdgeInsets.all(AppSpacing.s6),
                                decoration: const BoxDecoration(
                                  color: AppColors.surfacePill,
                                  shape: BoxShape.circle,
                                ),
                                child: const AliIcon(Iconsax.chart_2, size: 16, color: AppColors.accentSky),
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              Text('Frekuensi Bicara Ali', style: AppTypography.titleMedium()),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                            decoration: BoxDecoration(
                              color: AppColors.surfacePill,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text('Hari Ini', style: AppTypography.bodySmall(color: AppColors.textPrimary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatMetricBox(
                              title: 'Total Kata Disusun',
                              value: '24 Kata',
                              accentColor: AppColors.accentLemon,
                              textColor: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s6),
                          Expanded(
                            child: _StatMetricBox(
                              title: 'Kosa Kata Terbanyak',
                              value: 'Makan (8x)',
                              accentColor: AppColors.surfacePillDark,
                              textColor: AppColors.textOnDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // 2. Quick Action Card Section: Tambah Kosa Kata Baru (Margin 4px)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin), // Exactly 4.0
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onAddNewVocab();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s14),
                    decoration: BoxDecoration(
                      color: AppColors.surfacePillDark,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      boxShadow: AppShadows.floatingDockShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.accentLemon,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: AliIcon(Iconsax.camera, size: 22, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Foto & Rekam Suara Baru', style: AppTypography.titleMedium(color: AppColors.textOnDark)),
                              const SizedBox(height: AppSpacing.s2),
                              Text('Auto AI Cutout + Suara ${UserProfileService.fatherCall} & ${UserProfileService.motherCall}', style: AppTypography.bodySmall(color: Colors.white70)),
                            ],
                          ),
                        ),
                        const AliIcon(Iconsax.arrow_right_3, size: 18, color: AppColors.accentLemon),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // 2b. Quick Action: Belajar Menulis Huruf, Angka & Kata (Level 1-5)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => WritingPracticeScreen(
                          onBack: () => Navigator.pop(ctx),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(color: AppColors.borderCard, width: 1.0),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.accentLime,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: AliIcon(Iconsax.edit, size: 22, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Modul Belajar Menulis Ali', style: AppTypography.titleMedium()),
                              const SizedBox(height: AppSpacing.s2),
                              Text('Angka, Huruf A-Z, & Tambah Kata Baru (Level 1-5)', style: AppTypography.bodySmall()),
                            ],
                          ),
                        ),
                        const AliIcon(Iconsax.arrow_right_3, size: 18, color: AppColors.textPrimary),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // 3. AI & Sync Configuration Card Section (Margin 4px)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin), // Exactly 4.0
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppRadius.r24),
                    border: Border.all(color: AppColors.borderCard, width: 1.0),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengaturan AI & Sinkronisasi', style: AppTypography.titleMedium()),
                      const SizedBox(height: AppSpacing.s12),
                      _SettingsSwitchTile(
                        icon: Iconsax.magicpen,
                        title: 'Auto Background Removal (AI)',
                        subtitle: 'Otomatis membuat foto objek cutout transparan',
                        value: _autoBackgroundRemoval,
                        onChanged: (val) => setState(() => _autoBackgroundRemoval = val),
                      ),
                      const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),
                      _SettingsSwitchTile(
                        icon: Iconsax.volume_high,
                        title: 'Suara Pemandu Otomatis',
                        subtitle: 'Bunyikan audio saat Ali menyentuh kartu kosa kata',
                        value: _voiceFeedback,
                        onChanged: (val) => setState(() => _voiceFeedback = val),
                      ),
                      const Divider(color: AppColors.borderSubtle, height: AppSpacing.s16),
                      _SettingsSwitchTile(
                        icon: Iconsax.cloud_cross,
                        title: 'Mode Offline Prioritas',
                        subtitle: 'Gunakan SQLite lokal tanpa menunggu koneksi internet',
                        value: _offlineMode,
                        onChanged: (val) => setState(() => _offlineMode = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.cardGap)), // Exactly 4.0

            // 4. Log Aktivitas Komunikasi Ali Hari Ini (Margin 4px)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin), // Exactly 4.0
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s14),
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
                          Text('Riwayat Suara Ali Terakhir', style: AppTypography.titleMedium()),
                          Text('Realtime', style: AppTypography.bodySmall(color: AppColors.accentSky)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s10),
                      _ActivityHistoryRow(
                        time: '07:15',
                        sentence: 'Ali ingin Makan Roti',
                        category: 'Aktivitas',
                        voiceSource: 'Suara ${UserProfileService.fatherCall}',
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _ActivityHistoryRow(
                        time: '06:45',
                        sentence: 'Ali melihat Moli (Kucing)',
                        category: 'Hewan',
                        voiceSource: 'Suara ${UserProfileService.motherCall}',
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _ActivityHistoryRow(
                        time: '06:10',
                        sentence: 'Ali panggil ${UserProfileService.motherCall}',
                        category: 'Keluarga',
                        voiceSource: 'Suara ${UserProfileService.motherCall}',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _StatMetricBox extends StatelessWidget {
  final String title;
  final String value;
  final Color accentColor;
  final Color textColor;

  const _StatMetricBox({
    required this.title,
    required this.value,
    required this.accentColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodySmall(color: textColor.withValues(alpha: 0.8))),
          const SizedBox(height: AppSpacing.s4),
          Text(value, style: AppTypography.titleMedium(color: textColor)),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10, vertical: AppSpacing.s8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardSubtle,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.borderSubtle, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(time, style: AppTypography.bodySmall()),
              const SizedBox(width: AppSpacing.s8),
              Text(sentence, style: AppTypography.titleSmall()),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6, vertical: AppSpacing.s2),
            decoration: BoxDecoration(
              color: AppColors.surfacePill,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(voiceSource, style: AppTypography.bodySmall(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
