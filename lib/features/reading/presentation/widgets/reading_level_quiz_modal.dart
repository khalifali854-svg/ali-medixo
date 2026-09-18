import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import 'package:khalif_ali/core/components/ali_button.dart';
import 'package:khalif_ali/core/services/audio_engine_service.dart';
import '../../domain/models/reading_models.dart';

class ReadingLevelQuizModal extends StatefulWidget {
  final ReadingLevel level;
  final VoidCallback onQuizPassed;

  const ReadingLevelQuizModal({
    super.key,
    required this.level,
    required this.onQuizPassed,
  });

  @override
  State<ReadingLevelQuizModal> createState() => _ReadingLevelQuizModalState();
}

class _ReadingLevelQuizModalState extends State<ReadingLevelQuizModal> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;
  int _correctCount = 0;
  bool _isQuizCompleted = false;

  List<ReadingQuizQuestion> get _questions => widget.level.testQuestions;
  ReadingQuizQuestion get _currentQuestion => _questions[_currentQuestionIndex];

  @override
  void initState() {
    super.initState();
    _playQuestionAudio();
  }

  void _playQuestionAudio() {
    try {
      AudioEngineService.speakText(_currentQuestion.speechAudio);
    } catch (_) {}
  }

  void _selectOption(int index) {
    if (_isAnswerChecked) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _checkAnswer() {
    if (_selectedOptionIndex == null || _isAnswerChecked) return;

    final isCorrect = _selectedOptionIndex == _currentQuestion.correctOptionIndex;
    setState(() {
      _isAnswerChecked = true;
      _isCorrect = isCorrect;
      if (isCorrect) _correctCount++;
    });

    if (isCorrect) {
      HapticFeedback.heavyImpact();
      try {
        AudioEngineService.speakText('Hebat! Jawabanmu benar!');
      } catch (_) {}
    } else {
      HapticFeedback.mediumImpact();
      try {
        AudioEngineService.speakText('Hampir benar! ${_currentQuestion.hintExplanation}');
      } catch (_) {}
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _isAnswerChecked = false;
        _isCorrect = false;
      });
      _playQuestionAudio();
    } else {
      setState(() {
        _isQuizCompleted = true;
      });
      final hasPassed = _correctCount >= (_questions.length / 2).ceil();
      if (hasPassed) {
        widget.onQuizPassed();
        try {
          AudioEngineService.speakText('Luar biasa! Kamu lulus Ujian Level ${widget.level.levelNumber}!');
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 16,
        vertical: 24,
      ),
      child: Center(
        child: Container(
          width: isTablet ? 560 : double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: _isQuizCompleted ? _buildCompletedView() : _buildQuizBody(isTablet),
        ),
      ),
    );
  }

  Widget _buildQuizBody(bool isTablet) {
    final q = _currentQuestion;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Header with Progress Indicator & Close
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.level.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'UJIAN LEVEL ${widget.level.levelNumber}',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: widget.level.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Soal ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 2. Question Card with Audio Speaker
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.level.lightBgColor,
            borderRadius: BorderRadius.circular(AppRadius.r20),
            border: Border.all(color: widget.level.primaryColor.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.questionText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    if (q.targetWordOrLetter != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          border: Border.all(color: widget.level.primaryColor.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          q.targetWordOrLetter!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: widget.level.primaryColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _playQuestionAudio,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    side: BorderSide(color: widget.level.primaryColor.withValues(alpha: 0.3)),
                  ),
                ),
                icon: Icon(Iconsax.volume_high, color: widget.level.primaryColor, size: 22),
              ),
            ],
          ),
        ),

        // 3. Central Illustration Emoji if any
        if (q.illustrationEmoji != null) ...[
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                q.illustrationEmoji!,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
        ],

        const SizedBox(height: 18),

        // 4. Options List
        ...List.generate(q.options.length, (idx) {
          final optionText = q.options[idx];
          final isSelected = _selectedOptionIndex == idx;

          Color borderColor = AppColors.borderCard;
          Color bgColor = Colors.white;
          Color textColor = AppColors.textPrimary;

          if (_isAnswerChecked) {
            if (idx == q.correctOptionIndex) {
              borderColor = const Color(0xFF16A34A);
              bgColor = const Color(0xFFDCFCE7);
              textColor = const Color(0xFF14532D);
            } else if (isSelected) {
              borderColor = const Color(0xFFEF4444);
              bgColor = const Color(0xFFFEE2E2);
              textColor = const Color(0xFF991B1B);
            }
          } else if (isSelected) {
            borderColor = widget.level.primaryColor;
            bgColor = widget.level.primaryColor.withValues(alpha: 0.08);
            textColor = widget.level.primaryColor;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.r16),
              onTap: () => _selectOption(idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  border: Border.all(color: borderColor, width: 2.0),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected ? widget.level.primaryColor : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + idx), // A, B, C
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        optionText,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (_isAnswerChecked && idx == q.correctOptionIndex)
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 24),
                    if (_isAnswerChecked && isSelected && idx != q.correctOptionIndex)
                      const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 24),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 10),

        // 5. Action Check / Next Button
        if (!_isAnswerChecked)
          AliButton(
            label: 'Periksa Jawaban ➜',
            onPressed: _selectedOptionIndex != null ? _checkAnswer : null,
            variant: AliButtonVariant.primaryHighContrast,
            size: AliButtonSize.large,
          )
        else
          AliButton(
            label: _currentQuestionIndex < _questions.length - 1 ? 'Soal Berikutnya ➜' : 'Lihat Hasil Ujian 🎉',
            onPressed: _nextQuestion,
            variant: _isCorrect ? AliButtonVariant.primaryHighContrast : AliButtonVariant.outline,
            size: AliButtonSize.large,
          ),
      ],
    );
  }

  Widget _buildCompletedView() {
    final isPassed = _correctCount >= (_questions.length / 2).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isPassed ? '🏆' : '💪',
          style: const TextStyle(fontSize: 64),
        ),
        const SizedBox(height: 12),
        Text(
          isPassed ? 'Selamat, Kamu Lulus!' : 'Ayo Latihan Lagi!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Benar $_correctCount dari ${_questions.length} soal pada Ujian Level ${widget.level.levelNumber}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AliButton(
                label: 'Tutup',
                onPressed: () => Navigator.of(context).pop(),
                variant: AliButtonVariant.outline,
                size: AliButtonSize.large,
              ),
            ),
            if (!isPassed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: AliButton(
                  label: 'Ulangi Ujian',
                  onPressed: () {
                    setState(() {
                      _currentQuestionIndex = 0;
                      _selectedOptionIndex = null;
                      _isAnswerChecked = false;
                      _isCorrect = false;
                      _correctCount = 0;
                      _isQuizCompleted = false;
                    });
                    _playQuestionAudio();
                  },
                  variant: AliButtonVariant.primaryHighContrast,
                  size: AliButtonSize.large,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
