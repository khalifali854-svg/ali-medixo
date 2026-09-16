import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/app_theme_tokens.dart';
import 'ali_icon.dart';

class AliSmartInput extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceRecordTap;
  final bool isVoiceRecording;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;

  const AliSmartInput({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onVoiceRecordTap,
    this.isVoiceRecording = false,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<AliSmartInput> createState() => _AliSmartInputState();
}

class _AliSmartInputState extends State<AliSmartInput> {
  late TextEditingController _effectiveController;
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _hasText = _effectiveController.text.isNotEmpty;
    _effectiveController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final hasText = _effectiveController.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onFocusChanged() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _effectiveController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s4, bottom: AppSpacing.s6),
            child: Text(
              widget.label!,
              style: AppTypography.titleSmall(color: AppColors.textSecondary),
            ),
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isFocused ? AppColors.surfaceLight : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(
              widget.maxLines > 1 ? AppRadius.r20 : AppRadius.pill,
            ),
            border: Border.all(
              color: _isFocused
                  ? AppColors.pureBlack
                  : AppColors.borderSubtle,
              width: _isFocused ? 1.5 : 1.0,
            ),
            boxShadow: _isFocused ? AppShadows.cardShadow : null,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: widget.maxLines > 1 ? AppSpacing.s12 : AppSpacing.zero,
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                AliIcon(
                  widget.prefixIcon!,
                  size: 20,
                  color: _isFocused ? AppColors.pureBlack : AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.s10),
              ],
              Expanded(
                child: TextField(
                  controller: _effectiveController,
                  focusNode: _focusNode,
                  obscureText: widget.isPassword,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.maxLines,
                  style: AppTypography.bodyLarge(),
                  cursorColor: AppColors.pureBlack,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTypography.bodyLarge(color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: widget.maxLines == 1,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: widget.maxLines == 1 ? AppSpacing.s14 : AppSpacing.s4,
                    ),
                  ),
                ),
              ),
              if (_hasText) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _effectiveController.clear();
                    widget.onChanged?.call('');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s4),
                    decoration: const BoxDecoration(
                      color: AppColors.surfacePill,
                      shape: BoxShape.circle,
                    ),
                    child: const AliIcon(
                      Iconsax.close_circle5,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s6),
              ],
              if (widget.onVoiceRecordTap != null) ...[
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    widget.onVoiceRecordTap?.call();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(AppSpacing.s8),
                    decoration: BoxDecoration(
                      color: widget.isVoiceRecording
                          ? AppColors.accentCoral
                          : AppColors.pureBlack,
                      shape: BoxShape.circle,
                    ),
                    child: AliIcon(
                      widget.isVoiceRecording ? Iconsax.microphone_2 : Iconsax.microphone_25,
                      size: 18,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
