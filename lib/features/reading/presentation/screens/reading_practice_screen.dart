import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:khalif_ali/core/theme/app_theme_tokens.dart';
import 'package:khalif_ali/core/components/ali_button.dart';
import 'package:khalif_ali/core/services/audio_engine_service.dart';
import '../../domain/models/reading_models.dart';
import '../widgets/reading_level_quiz_modal.dart';

import 'package:khalif_ali/core/services/subscription_service.dart';
import 'package:khalif_ali/core/components/ali_paywall_dialog.dart';

class ReadingPracticeScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ReadingPracticeScreen({super.key, this.onBack});

  @override
  State<ReadingPracticeScreen> createState() => _ReadingPracticeScreenState();
}

class _ReadingPracticeScreenState extends State<ReadingPracticeScreen> {
  // Mode: true = Level Roadmap Map View, false = Lesson Studio Arena
  bool _isMapMode = true;

  // Track progress: Level 1 (index 0) is unlocked initially.
  // Level N unlocks once Level N-1 is passed in quiz!
  int _highestUnlockedLevelIndex = 0;
  final Set<int> _completedLevelIndexes = {};

  int _selectedLevelIndex = 0;
  int _activeLessonIndex = 0;

  ReadingLevel get _currentLevel => ReadingRepository.levels[_selectedLevelIndex];
  ReadingLessonItem get _currentLesson => _currentLevel.lessons[_activeLessonIndex];

  void _playLessonAudio() {
    try {
      AudioEngineService.speakText(_currentLesson.speechText);
    } catch (_) {}
  }

  void _openLevelFromMap(int index) {
    // FREE GATE: Level 1 (index 0) adalah GRATIS. Level 2 ke atas (index >= 1) butuh Ali Pro
    if (index >= 1 && !SubscriptionService.isPro) {
      HapticFeedback.heavyImpact();
      AliPaywallDialog.show(
        context,
        featureName: 'Belajar Membaca Level ${index + 1}',
        featureDescription:
            'Buka kurikulum lengkap membaca suku kata, kata berakhiran konsonan, kuis bintang, dan cerita interaktif.',
      );
      return;
    }

    if (index > _highestUnlockedLevelIndex) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 Selesaikan & lulus Ujian Level $index dulu ya!',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      try {
        AudioEngineService.speakText('Level ini masih terkunci. Selesaikan level sebelumnya dulu ya!');
      } catch (_) {}
      return;
    }

    HapticFeedback.selectionClick();
    setState(() {
      _selectedLevelIndex = index;
      _activeLessonIndex = 0;
      _isMapMode = false; // Enter study arena
    });
    _playLessonAudio();
  }

  void _returnToMap() {
    HapticFeedback.selectionClick();
    setState(() {
      _isMapMode = true;
    });
  }

  void _selectLesson(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeLessonIndex = index;
    });
    _playLessonAudio();
  }

  void _openLevelQuiz() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ReadingLevelQuizModal(
        level: _currentLevel,
        onQuizPassed: () {
          setState(() {
            _completedLevelIndexes.add(_selectedLevelIndex);
            // Unlock next level if currently completed highest unlocked
            if (_selectedLevelIndex + 1 > _highestUnlockedLevelIndex &&
                _selectedLevelIndex + 1 < ReadingRepository.levels.length) {
              _highestUnlockedLevelIndex = _selectedLevelIndex + 1;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 650;

    return Scaffold(
      backgroundColor: _isMapMode ? const Color(0xFFF8FAFC) : _currentLevel.lightBgColor,
      body: SafeArea(
        child: _isMapMode
            ? _buildRoadmapView(context, isTablet)
            : _buildLessonStudio(context, isTablet),
      ),
    );
  }

  // =========================================================================
  // VIEW 1: ROADMAP JALUR BELAJAR BERTAHAP (Duolingo / Progressive Stepping Stones)
  // =========================================================================

  Widget _buildRoadmapView(BuildContext context, bool isTablet) {
    final totalLevels = ReadingRepository.levels.length;
    final progressPercent = (_completedLevelIndexes.length / totalLevels).clamp(0.0, 1.0);

    return Column(
      children: [
        // Top Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        side: const BorderSide(color: AppColors.borderCard, width: 1.5),
                      ),
                    ),
                    icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peta Belajar Membaca',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Jalur Bertahap (0 ➔ Mahir)',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Progress Bar Banner
        Container(
          margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.r20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.25),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Progress Petualangan Fonik 🚀',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_completedLevelIndexes.length}/$totalLevels Selesai',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${(progressPercent * 100).toInt()}%)',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selesaikan pelajaran dan lulus Ujian untuk membuka level berikutnya!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Stepping-Stones Progression Path (Vertical Winding Track)
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 48 : 16,
              vertical: 16,
            ),
            itemCount: ReadingRepository.levels.length,
            itemBuilder: (ctx, idx) {
              return _buildRoadmapNode(idx, isTablet);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoadmapNode(int index, bool isTablet) {
    final level = ReadingRepository.levels[index];
    final isUnlocked = index <= _highestUnlockedLevelIndex;
    final isPassed = _completedLevelIndexes.contains(index);
    final isCurrent = index == _highestUnlockedLevelIndex && !isPassed;
    final isLast = index == ReadingRepository.levels.length - 1;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 600 : 420),
        child: Column(
          children: [
            // Level Card Item
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.r24),
              onTap: () => _openLevelFromMap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(AppRadius.r24),
                  border: Border.all(
                    color: isCurrent
                        ? level.primaryColor
                        : isPassed
                            ? const Color(0xFF22C55E)
                            : isUnlocked
                                ? AppColors.borderCard
                                : const Color(0xFFCBD5E1),
                    width: isCurrent ? 2.5 : 1.5,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: level.primaryColor.withValues(alpha: 0.22),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    // Node Avatar Icon / Lock Badge
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: isUnlocked ? level.lightBgColor : const Color(0xFFE2E8F0),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnlocked ? level.primaryColor.withValues(alpha: 0.4) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isUnlocked ? level.iconEmoji : '🔒',
                            style: TextStyle(
                              fontSize: isUnlocked ? 28 : 24,
                              color: isUnlocked ? null : Colors.grey,
                            ),
                          ),
                        ),
                        if (isPassed)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 14, color: Colors.white),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Level Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? level.primaryColor.withValues(alpha: 0.12)
                                      : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(AppRadius.r8),
                                ),
                                child: Text(
                                  'LEVEL ${level.levelNumber}',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    color: isUnlocked ? level.primaryColor : const Color(0xFF64748B),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                level.tag,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            level.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isUnlocked ? AppColors.textPrimary : const Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            level.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isUnlocked ? AppColors.textSecondary : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Action CTA button / Lock status
                    if (!isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Text(
                          'Terkunci 🔒',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    else if (isPassed)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Lulus ⭐',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: level.primaryColor,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: [
                            BoxShadow(
                              color: level.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mulai',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Stepping Path Line to next Level
            if (!isLast) ...[
              Container(
                width: 4,
                height: 32,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isPassed ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // VIEW 2: LESSON STUDIO ARENA (Latihan Fonik, Suku Kata, dan Ujian)
  // =========================================================================

  Widget _buildLessonStudio(BuildContext context, bool isTablet) {
    return Column(
      children: [
        // 1. Top Navigation Bar (Back to Map, Level Title, Test CTA)
        _buildStudioTopBar(context),

        // 2. Interactive Reading Arena
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 32 : 16,
              vertical: 8,
            ),
            child: isTablet ? _buildTabletStudioLayout() : _buildMobileStudioLayout(),
          ),
        ),

        // 3. Bottom Navigation & Level Quiz Button
        _buildStudioBottomBar(isTablet),
      ],
    );
  }

  Widget _buildStudioTopBar(BuildContext context) {
    final isLevelPassed = _completedLevelIndexes.contains(_selectedLevelIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _returnToMap,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    side: const BorderSide(color: AppColors.borderCard, width: 1.5),
                  ),
                ),
                icon: const Icon(Iconsax.arrow_left_2, color: AppColors.textPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _currentLevel.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.r8),
                        ),
                        child: Text(
                          'LEVEL ${_currentLevel.levelNumber}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: _currentLevel.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _currentLevel.tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        _currentLevel.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(_currentLevel.iconEmoji, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Return to Map Button
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: _returnToMap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.borderCard, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text('🗺️', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    'Peta Belajar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: isLevelPassed ? const Color(0xFF15803D) : AppColors.textPrimary,
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

  Widget _buildMobileStudioLayout() {
    return Column(
      children: [
        // Horizontal Lesson items within this Level
        _buildLessonPillSelector(),
        const SizedBox(height: 12),

        // Main Stage Card
        Expanded(
          child: _buildMainStageCard(),
        ),
      ],
    );
  }

  Widget _buildTabletStudioLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Column: Lesson Items List within this Level
        SizedBox(
          width: 240,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r24),
              border: Border.all(color: AppColors.borderCard, width: 1.5),
            ),
            child: ListView.separated(
              itemCount: _currentLevel.lessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, idx) {
                final item = _currentLevel.lessons[idx];
                final isSelected = idx == _activeLessonIndex;

                return InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  onTap: () => _selectLesson(idx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? _currentLevel.primaryColor : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                    child: Row(
                      children: [
                        Text(item.illustrationEmoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Right Column: Main Stage Card
        Expanded(
          child: _buildMainStageCard(),
        ),
      ],
    );
  }

  Widget _buildLessonPillSelector() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _currentLevel.lessons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, idx) {
          final item = _currentLevel.lessons[idx];
          final isSelected = idx == _activeLessonIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: () => _selectLesson(idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _currentLevel.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: isSelected ? _currentLevel.primaryColor : AppColors.borderCard,
                ),
              ),
              child: Row(
                children: [
                  Text(item.illustrationEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainStageCard() {
    final lesson = _currentLesson;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r32),
        border: Border.all(color: _currentLevel.primaryColor.withValues(alpha: 0.35), width: 2),
        boxShadow: [
          BoxShadow(
            color: _currentLevel.primaryColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Big Friendly Illustration Emoji with 3D Ring
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: _currentLevel.lightBgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _currentLevel.primaryColor.withValues(alpha: 0.18),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Text(
              lesson.illustrationEmoji,
              style: const TextStyle(fontSize: 68),
            ),
          ),

          const SizedBox(height: 18),

          // 2. Interactive Pronunciation Bubbles / Syllables
          if (lesson.syllables.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: lesson.syllables.map((syl) {
                return InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    try {
                      AudioEngineService.speakText(syl);
                    } catch (_) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: _currentLevel.lightBgColor,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: _currentLevel.primaryColor, width: 2),
                    ),
                    child: Text(
                      syl,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: _currentLevel.primaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ] else ...[
            // Giant Single Letter / Word
            Text(
              lesson.previewText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.w900,
                color: _currentLevel.primaryColor,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // 3. Phonetic Sound Hint
          Text(
            lesson.phoneticSound,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // 4. Tap to Speak Sound Button
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: _playLessonAudio,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _currentLevel.primaryColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: _currentLevel.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.volume_high, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Dengarkan Bunyinya 🔊',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
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

  Widget _buildStudioBottomBar(bool isTablet) {
    final isLevelPassed = _completedLevelIndexes.contains(_selectedLevelIndex);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 16,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderCard, width: 1.5)),
      ),
      child: Row(
        children: [
          // Previous Lesson
          IconButton(
            onPressed: _activeLessonIndex > 0
                ? () => _selectLesson(_activeLessonIndex - 1)
                : null,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          ),

          const SizedBox(width: 8),

          // Center: Take Level Test Button
          Expanded(
            child: AliButton(
              label: isLevelPassed
                  ? 'Ulangi Ujian Level ${_currentLevel.levelNumber} 📝'
                  : 'Ikuti Ujian Level ${_currentLevel.levelNumber} 🎓',
              onPressed: _openLevelQuiz,
              variant: isLevelPassed ? AliButtonVariant.outline : AliButtonVariant.primaryHighContrast,
              size: AliButtonSize.large,
            ),
          ),

          const SizedBox(width: 8),

          // Next Lesson
          IconButton(
            onPressed: _activeLessonIndex < _currentLevel.lessons.length - 1
                ? () => _selectLesson(_activeLessonIndex + 1)
                : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
