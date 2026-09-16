import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_modal.dart';
import '../../../../core/components/ali_network_image.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../aac_board/domain/models/vocab_card_model.dart';

class VisualScheduleItem {
  final String id;
  String title;
  String time;
  String imageUrl;
  bool isCompleted;

  VisualScheduleItem({
    required this.id,
    required this.title,
    required this.time,
    required this.imageUrl,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time,
        'imageUrl': imageUrl,
        'isCompleted': isCompleted,
      };

  factory VisualScheduleItem.fromJson(Map<String, dynamic> json) =>
      VisualScheduleItem(
        id: json['id'] as String? ?? UniqueKey().toString(),
        title: json['title'] as String? ?? '',
        time: json['time'] as String? ?? '08:00',
        imageUrl: json['imageUrl'] as String? ?? '',
        isCompleted: json['isCompleted'] == true,
      );

  VisualScheduleItem copyWith({
    String? id,
    String? title,
    String? time,
    String? imageUrl,
    bool? isCompleted,
  }) {
    return VisualScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class VisualScheduleScreen extends StatefulWidget {
  final List<VocabCardModel>? availableCards;
  final VoidCallback? onBack;

  const VisualScheduleScreen({
    super.key,
    this.availableCards,
    this.onBack,
  });

  @override
  State<VisualScheduleScreen> createState() => _VisualScheduleScreenState();
}

class _VisualScheduleScreenState extends State<VisualScheduleScreen> {
  int _activeTab = 0; // 0: Pertama - Lalu (First-Then), 1: Rutinitas Harian
  bool _isLoading = true;

  static const String _prefDailyKey = 'ali_visual_schedule_daily_v2';
  static const String _prefFirstKey = 'ali_visual_schedule_first_v2';
  static const String _prefThenKey = 'ali_visual_schedule_then_v2';

  late VisualScheduleItem _firstItem;
  late VisualScheduleItem _thenItem;
  List<VisualScheduleItem> _dailyRoutine = [];

  List<VocabCardModel> get _cards => widget.availableCards ?? [];

  @override
  void initState() {
    super.initState();
    _initDefaultItems();
    _loadScheduleData();
  }

  @override
  void didUpdateWidget(covariant VisualScheduleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.availableCards ?? []).isEmpty && _cards.isNotEmpty) {
      _applyCardFallbacks();
    }
  }

  void _applyCardFallbacks() {
    if (_cards.isEmpty) return;
    bool changed = false;
    if (_firstItem.imageUrl.isEmpty) {
      _firstItem.imageUrl = _cards.first.imageUrl;
      _firstItem.title = _cards.first.label;
      changed = true;
    }
    if (_thenItem.imageUrl.isEmpty && _cards.length > 1) {
      _thenItem.imageUrl = _cards[1].imageUrl;
      _thenItem.title = _cards[1].label;
      changed = true;
    }
    if (_dailyRoutine.isEmpty || _dailyRoutine.any((item) => item.imageUrl.isEmpty)) {
      final times = ['07:00', '07:30', '09:00', '11:30', '13:00', '16:00', '19:00'];
      final count = _cards.length < 7 ? _cards.length : 7;
      _dailyRoutine = [];
      for (int i = 0; i < count; i++) {
        final c = _cards[i];
        _dailyRoutine.add(
          VisualScheduleItem(
            id: 'routine_${c.id}_$i',
            title: c.label,
            time: i < times.length ? times[i] : '08:00',
            imageUrl: c.imageUrl,
            isCompleted: false,
          ),
        );
      }
      changed = true;
      _saveRoutine();
    }
    if (changed && mounted) {
      setState(() {});
    }
  }

  void _initDefaultItems() {
    VocabCardModel? card1;
    VocabCardModel? card2;
    if (_cards.isNotEmpty) {
      card1 = _cards.first;
      if (_cards.length > 1) card2 = _cards[1];
    }

    _firstItem = VisualScheduleItem(
      id: 'ft_1',
      title: card1?.label ?? 'Mandi',
      time: 'Langkah 1',
      imageUrl: card1?.imageUrl ?? '',
      isCompleted: false,
    );
    _thenItem = VisualScheduleItem(
      id: 'ft_2',
      title: card2?.label ?? 'Makan',
      time: 'Langkah 2',
      imageUrl: card2?.imageUrl ?? '',
      isCompleted: false,
    );
  }

  Future<void> _loadScheduleData() async {
    // 1. Coba load dari Cloud Supabase per user_id
    try {
      final firstThenCloud = await SupabaseService.getUserSchedule('first_then');
      if (firstThenCloud != null) {
        if (firstThenCloud['first_item'] != null) {
          _firstItem = VisualScheduleItem.fromJson(Map<String, dynamic>.from(firstThenCloud['first_item'] as Map));
        }
        if (firstThenCloud['then_item'] != null) {
          _thenItem = VisualScheduleItem.fromJson(Map<String, dynamic>.from(firstThenCloud['then_item'] as Map));
        }
      }

      final dailyCloud = await SupabaseService.getUserSchedule('daily_routine');
      if (dailyCloud != null && dailyCloud['routine_items'] is List && (dailyCloud['routine_items'] as List).isNotEmpty) {
        _dailyRoutine = (dailyCloud['routine_items'] as List)
            .map((e) => VisualScheduleItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (e) {
      debugPrint('Supabase schedule fetch note: $e');
    }

    // 2. Fallback / Local Cache SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final firstRaw = prefs.getString(_prefFirstKey);
      if (firstRaw != null && _firstItem.imageUrl.isEmpty) {
        _firstItem = VisualScheduleItem.fromJson(jsonDecode(firstRaw));
      }
      final thenRaw = prefs.getString(_prefThenKey);
      if (thenRaw != null && _thenItem.imageUrl.isEmpty) {
        _thenItem = VisualScheduleItem.fromJson(jsonDecode(thenRaw));
      }
      final dailyRaw = prefs.getString(_prefDailyKey);
      if (dailyRaw != null && _dailyRoutine.isEmpty) {
        final decoded = jsonDecode(dailyRaw) as List;
        _dailyRoutine = decoded.map((e) => VisualScheduleItem.fromJson(e)).toList();
      } else if (_dailyRoutine.isEmpty) {
        _dailyRoutine = [];
        final times = ['07:00', '07:30', '09:00', '11:30', '13:00', '16:00', '19:00'];
        final count = _cards.length < 7 ? _cards.length : 7;
        for (int i = 0; i < count; i++) {
          final c = _cards[i];
          _dailyRoutine.add(
            VisualScheduleItem(
              id: 'routine_${c.id}_$i',
              title: c.label,
              time: i < times.length ? times[i] : '08:00',
              imageUrl: c.imageUrl,
              isCompleted: false,
            ),
          );
        }
      }
      _applyCardFallbacks();
    } catch (_) {}

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveRoutine() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefDailyKey, jsonEncode(_dailyRoutine.map((e) => e.toJson()).toList()));
    } catch (_) {}

    // Cloud sync per akun
    try {
      await SupabaseService.saveUserSchedule(
        scheduleType: 'daily_routine',
        routineItems: _dailyRoutine.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      debugPrint('Cloud save daily routine error: $e');
    }
  }

  Future<void> _saveFirstThen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefFirstKey, jsonEncode(_firstItem.toJson()));
      await prefs.setString(_prefThenKey, jsonEncode(_thenItem.toJson()));
    } catch (_) {}

    // Cloud sync per akun
    try {
      await SupabaseService.saveUserSchedule(
        scheduleType: 'first_then',
        firstItem: _firstItem.toJson(),
        thenItem: _thenItem.toJson(),
      );
    } catch (e) {
      debugPrint('Cloud save first-then error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 600;

    final completedCount = _dailyRoutine.where((i) => i.isCompleted).length;
    final totalCount = _dailyRoutine.length;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
              child: AliHeaderSection(
                title: 'Jadwal Visual $completedCount/$totalCount',
                subtitle: 'Rutinitas Terstruktur Ramah Anak',
                onBackTap: widget.onBack ?? () => Navigator.pop(context),
                tabs: const ['Pertama - Lalu', 'Jadwal Harian'],
                activeTabIndex: _activeTab,
                onTabChanged: (idx) => setState(() => _activeTab = idx),
                actionWidget: _activeTab == 1
                    ? AliButton(
                        label: 'Tambah',
                        prefixIcon: const AliIcon(Iconsax.add, size: 16, color: AppColors.pureWhite),
                        size: AliButtonSize.small,
                        onPressed: () => _openCardPickerForRoutine(null),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: AppSpacing.cardGap),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : (_activeTab == 0
                      ? _buildFirstThenView(isTablet)
                      : _buildDailyRoutineView(isTablet)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstThenView(bool isTablet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.r20),
              border: Border.all(color: AppColors.borderCard, width: 1.0),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s8),
                  decoration: const BoxDecoration(
                    color: AppColors.accentLemon,
                    shape: BoxShape.circle,
                  ),
                  child: const AliIcon(Iconsax.star_1, size: 20, color: AppColors.textPrimary),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Terapi: Pertama - Lalu (First - Then)',
                        style: AppTypography.titleSmall(),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sentuh ikon pensil pada kartu untuk mengganti langkah dari kartu AAC Ali.',
                        style: AppTypography.bodySmall(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          isTablet
              ? Row(
                  children: [
                    Expanded(child: _buildBigStageCard(item: _firstItem, isFirst: true)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.surfacePillDark,
                        child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
                      ),
                    ),
                    Expanded(child: _buildBigStageCard(item: _thenItem, isFirst: false)),
                  ],
                )
              : Column(
                  children: [
                    _buildBigStageCard(item: _firstItem, isFirst: true),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.surfacePillDark,
                        child: Icon(Icons.arrow_downward_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    _buildBigStageCard(item: _thenItem, isFirst: false),
                  ],
                ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AliButton(
                  label: 'Ulangi Tahap',
                  prefixIcon: const AliIcon(Iconsax.refresh, size: 16, color: AppColors.textPrimary),
                  variant: AliButtonVariant.outline,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _firstItem.isCompleted = false;
                      _thenItem.isCompleted = false;
                    });
                    _saveFirstThen();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AliButton(
                  label: 'Suarakan Langkah',
                  prefixIcon: const AliIcon(Iconsax.volume_high, size: 16, color: AppColors.pureWhite),
                  variant: AliButtonVariant.primaryHighContrast,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    final childName = UserProfileService.childName;
                    AudioEngineService.speakWord(
                      text: 'Pertama, ${_firstItem.title}. Lalu, ${_thenItem.title}. Semangat $childName!',
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBigStageCard({required VisualScheduleItem item, required bool isFirst}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() {
          item.isCompleted = !item.isCompleted;
        });
        _saveFirstThen();
        if (item.isCompleted) {
          AudioEngineService.speakWord(text: 'Hebat! ${item.title} selesai!');
        } else {
          AudioEngineService.speakWord(text: item.title);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isCompleted ? const Color(0xFFF0FDF4) : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.r28),
          border: Border.all(
            color: item.isCompleted ? AppColors.accentGreen : AppColors.borderCard,
            width: item.isCompleted ? 2.5 : 1.2,
          ),
          boxShadow: AppShadows.floatingDockShadow,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isFirst ? AppColors.pureBlack : AppColors.accentLemon,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    isFirst ? '1. PERTAMA' : '2. LALU',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppTypography.fontFamily,
                      color: isFirst ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openCardPickerForFirstThen(isFirst),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.surfacePill,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Iconsax.edit_2, size: 16, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.isCompleted ? AppColors.accentGreen : AppColors.surfacePill,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: item.isCompleted ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Card Image from AAC - Large Balanced Square (190x190)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r24),
              child: Container(
                height: 190,
                width: 190,
                color: AppColors.surfaceCardSubtle,
                child: AliNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: const Center(
                    child: Icon(Iconsax.image, size: 54, color: AppColors.textMuted),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFamily: AppTypography.fontFamily,
                color: item.isCompleted ? const Color(0xFF15803D) : AppColors.textPrimary,
                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.isCompleted ? 'Sudah Selesai ✓' : 'Sentuh jika sudah selesai',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: item.isCompleted ? const Color(0xFF16A34A) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRoutineView(bool isTablet) {
    if (_dailyRoutine.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.surfacePill,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.calendar_1, size: 40, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada langkah rutinitas',
              style: AppTypography.titleMedium(),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol tambah di atas untuk membuat jadwal visual',
              style: AppTypography.bodySmall(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _dailyRoutine.length,
      itemBuilder: (context, index) {
        final item = _dailyRoutine[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.r20),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                item.isCompleted = !item.isCompleted;
              });
              _saveRoutine();
              if (item.isCompleted) {
                AudioEngineService.speakWord(text: '${item.title} selesai!');
                SupabaseService.logChildActivity(
                  activityType: 'schedule_completed',
                  targetLabel: item.title,
                  category: 'Jadwal Visual',
                  success: true,
                );
              } else {
                AudioEngineService.speakWord(text: item.title);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: item.isCompleted ? const Color(0xFFF0FDF4) : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.r20),
                border: Border.all(
                  color: item.isCompleted ? AppColors.accentGreen : AppColors.borderCard,
                  width: item.isCompleted ? 1.8 : 1.0,
                ),
                boxShadow: AppShadows.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfacePill,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 58,
                      height: 58,
                      color: AppColors.surfaceCardSubtle,
                      child: AliNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: const Icon(Iconsax.image, size: 24, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        fontFamily: AppTypography.fontFamily,
                        color: item.isCompleted ? const Color(0xFF15803D) : AppColors.textPrimary,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.edit_2, size: 16, color: AppColors.textMuted),
                    onPressed: () => _openCardPickerForRoutine(item),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: item.isCompleted ? AppColors.accentGreen : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: item.isCompleted ? AppColors.accentGreen : AppColors.borderCard,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: item.isCompleted ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= AAC CARD PICKER (MODAL) =================
  void _openCardPickerForFirstThen(bool isFirst) {
    String search = '';

    AliModal.showDeckModal(
      context: context,
      isFullHeight: true,
      title: isFirst ? 'Pilih Kartu Langkah 1 (Pertama)' : 'Pilih Kartu Langkah 2 (Lalu)',
      subtitle: 'Pilih kartu kosa kata nyata dari AAC Ali',
      body: StatefulBuilder(
        builder: (ctx, setModalState) {
          final filtered = _cards.where((c) {
            if (search.isEmpty) return true;
            return c.label.toLowerCase().contains(search.toLowerCase());
          }).toList();

          return Column(
            children: [
              TextField(
                onChanged: (val) => setModalState(() => search = val),
                decoration: InputDecoration(
                  hintText: 'Cari kartu AAC...',
                  prefixIcon: const Icon(Iconsax.search_normal_1, size: 18),
                  filled: true,
                  fillColor: AppColors.surfaceCardSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Tidak ada kartu yang cocok'))
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final card = filtered[i];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isFirst) {
                                  _firstItem = _firstItem.copyWith(
                                    title: card.label,
                                    imageUrl: card.imageUrl,
                                    isCompleted: false,
                                  );
                                } else {
                                  _thenItem = _thenItem.copyWith(
                                    title: card.label,
                                    imageUrl: card.imageUrl,
                                    isCompleted: false,
                                  );
                                }
                              });
                              _saveFirstThen();
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(AppRadius.r20),
                                border: Border.all(color: AppColors.borderCard),
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
                                      child: AliNetworkImage(
                                        imageUrl: card.imageUrl,
                                        fit: BoxFit.cover,
                                        errorWidget: const Center(
                                          child: Icon(Iconsax.image, color: AppColors.textMuted),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                    child: Text(
                                      card.label,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: AppTypography.fontFamily,
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
            ],
          );
        },
      ),
    );
  }

  void _openCardPickerForRoutine(VisualScheduleItem? existing) {
    final timeCtrl = TextEditingController(text: existing?.time ?? '08:00');
    String search = '';

    AliModal.showDeckModal(
      context: context,
      isFullHeight: true,
      title: existing == null ? 'Pilih Kartu untuk Jadwal Baru' : 'Ubah Kartu Jadwal Harian',
      subtitle: 'Tentukan jam dan pilih kartu dari AAC Ali',
      body: StatefulBuilder(
        builder: (ctx, setModalState) {
          final filtered = _cards.where((c) {
            if (search.isEmpty) return true;
            return c.label.toLowerCase().contains(search.toLowerCase());
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Waktu Pelaksanaan (Jam)', style: AppTypography.titleSmall()),
              const SizedBox(height: 6),
              TextField(
                controller: timeCtrl,
                decoration: InputDecoration(
                  hintText: 'Misal: 08:30',
                  prefixIcon: const Icon(Iconsax.clock, size: 18),
                  filled: true,
                  fillColor: AppColors.surfaceCardSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: (val) => setModalState(() => search = val),
                decoration: InputDecoration(
                  hintText: 'Cari kartu AAC Ali...',
                  prefixIcon: const Icon(Iconsax.search_normal_1, size: 18),
                  filled: true,
                  fillColor: AppColors.surfaceCardSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    borderSide: const BorderSide(color: AppColors.borderCard),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('Tidak ada kartu yang cocok'))
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final card = filtered[i];
                          return GestureDetector(
                            onTap: () {
                              final time = timeCtrl.text.trim();
                              setState(() {
                                if (existing == null) {
                                  _dailyRoutine.add(
                                    VisualScheduleItem(
                                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                                      title: card.label,
                                      time: time.isNotEmpty ? time : '08:00',
                                      imageUrl: card.imageUrl,
                                      isCompleted: false,
                                    ),
                                  );
                                } else {
                                  existing.title = card.label;
                                  existing.imageUrl = card.imageUrl;
                                  existing.time = time.isNotEmpty ? time : '08:00';
                                }
                              });
                              _saveRoutine();
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(AppRadius.r20),
                                border: Border.all(color: AppColors.borderCard),
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
                                      child: AliNetworkImage(
                                        imageUrl: card.imageUrl,
                                        fit: BoxFit.cover,
                                        errorWidget: const Center(
                                          child: Icon(Iconsax.image, color: AppColors.textMuted),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                    child: Text(
                                      card.label,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: AppTypography.fontFamily,
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
            ],
          );
        },
      ),
    );
  }
}
