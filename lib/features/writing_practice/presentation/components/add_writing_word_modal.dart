import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_modal.dart';
import '../../../../core/components/ali_smart_input.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/user_profile_service.dart';

class AddWritingWordModal {
  static void show({
    required BuildContext context,
    int defaultLevelType = 4,
    VoidCallback? onWordAdded,
  }) {
    AliModal.showDeckModal(
      context: context,
      title: 'Tambah Kata Baru',
      subtitle: 'Tambahkan kosa kata latihan menulis baru untuk ${UserProfileService.childName}',
      body: _AddWritingWordContent(
        defaultLevelType: defaultLevelType,
        onWordAdded: onWordAdded,
      ),
    );
  }
}

class _AddWritingWordContent extends StatefulWidget {
  final int defaultLevelType;
  final VoidCallback? onWordAdded;

  const _AddWritingWordContent({
    required this.defaultLevelType,
    this.onWordAdded,
  });

  @override
  State<_AddWritingWordContent> createState() => _AddWritingWordContentState();
}

class _AddWritingWordContentState extends State<_AddWritingWordContent> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  late int _selectedLevel;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.defaultLevelType == 5 ? 5 : 4;
  }

  @override
  void dispose() {
    _wordController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final word = _wordController.text.trim();
    if (word.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan masukkan kata yang ingin dipelajari ${UserProfileService.childName}!'),
          backgroundColor: AppColors.accentCoral,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await SupabaseService.insertWritingItem(
      levelType: _selectedLevel,
      targetText: word.toUpperCase(),
      hintLabel: _hintController.text.trim().isEmpty ? null : _hintController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        widget.onWordAdded?.call();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kata "$word" berhasil ditambahkan untuk ${UserProfileService.childName}!'),
            backgroundColor: AppColors.pureBlack,
          ),
        );
      } else {
        widget.onWordAdded?.call();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tingkat Pembelajaran:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: [
            Expanded(
              child: _LevelOptionCard(
                title: 'Level 4: Kata Pendek',
                subtitle: '2 - 3 Huruf (${UserProfileService.fatherCall.toUpperCase()}, ${UserProfileService.motherCall.toUpperCase()}, dll)',
                isSelected: _selectedLevel == 4,
                onTap: () => setState(() => _selectedLevel = 4),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _LevelOptionCard(
                title: 'Level 5: Kosa Kata',
                subtitle: 'Kata Panjang (MAKAN, dll)',
                isSelected: _selectedLevel == 5,
                onTap: () => setState(() => _selectedLevel = 5),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),

        AliSmartInput(
          controller: _wordController,
          hintText: 'Tuliskan kata (misal: BOLA / ${UserProfileService.motherCall.toUpperCase()})',
          prefixIcon: Iconsax.text,
        ),
        const SizedBox(height: AppSpacing.s12),

        AliSmartInput(
          controller: _hintController,
          hintText: 'Petunjuk singkat (misal: Main Bola)',
          prefixIcon: Iconsax.info_circle,
        ),
        const SizedBox(height: AppSpacing.s12),

        Container(
          padding: const EdgeInsets.all(AppSpacing.s10),
          decoration: BoxDecoration(
            color: AppColors.surfacePill,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: const Row(
            children: [
              Icon(Iconsax.lamp_on, size: 18, color: AppColors.accentLemon),
              SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  'Kata ini otomatis dilengkapi panduan guratan huruf berurutan untuk Ali.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s16),

        Row(
          children: [
            Expanded(
              child: AliButton(
                label: 'Batal',
                variant: AliButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: AliButton(
                label: _isSaving ? 'Menyimpan...' : 'Simpan Kata',
                variant: AliButtonVariant.primaryHighContrast,
                onPressed: _isSaving ? null : _handleSave,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LevelOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelOptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10, vertical: AppSpacing.s12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pureBlack : AppColors.surfacePill,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(
            color: isSelected ? AppColors.accentLemon : AppColors.borderCard,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.pureWhite.withOpacity(0.7) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
