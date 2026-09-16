import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_modal.dart';
import '../../../../core/components/ali_smart_input.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/services/r2_storage_service.dart';
import '../../../../core/services/supabase_service.dart';

class StrokePoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  const StrokePoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });

  Map<String, dynamic> toJson() => {
        'x': offset.dx,
        'y': offset.dy,
        'c': color.value,
        'w': strokeWidth,
      };

  factory StrokePoint.fromJson(dynamic json) {
    if (json is! Map) {
      return const StrokePoint(offset: Offset.zero, color: Colors.black, strokeWidth: 5.0);
    }
    final map = Map<String, dynamic>.from(json);
    final dx = (map['x'] as num?)?.toDouble() ?? 0.0;
    final dy = (map['y'] as num?)?.toDouble() ?? 0.0;
    final cInt = (map['c'] as num?)?.toInt() ?? 4279704352; // default black
    final wDouble = (map['w'] as num?)?.toDouble() ?? 5.0;

    return StrokePoint(
      offset: Offset(dx, dy),
      color: Color(cInt),
      strokeWidth: wDouble,
    );
  }
}

class DrawingStroke {
  final int pointerId;
  final List<StrokePoint> points;
  final Color color;
  final double strokeWidth;

  DrawingStroke({
    required this.pointerId,
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  Map<String, dynamic> toJson() => {
        'pid': pointerId,
        'pts': points.map((p) => p.toJson()).toList(),
        'c': color.value,
        'w': strokeWidth,
      };

  factory DrawingStroke.fromJson(dynamic json) {
    if (json is! Map) {
      return DrawingStroke(pointerId: 0, points: [], color: Colors.black, strokeWidth: 5.0);
    }
    final map = Map<String, dynamic>.from(json);
    final pid = (map['pid'] as num?)?.toInt() ?? 0;
    final ptsList = map['pts'] as List<dynamic>? ?? [];
    final points = ptsList.map((p) => StrokePoint.fromJson(p)).toList();
    final cInt = (map['c'] as num?)?.toInt() ?? 4279704352;
    final wDouble = (map['w'] as num?)?.toDouble() ?? 5.0;

    return DrawingStroke(
      pointerId: pid,
      points: points,
      color: Color(cInt),
      strokeWidth: wDouble,
    );
  }
}

class SavedDrawingItem {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<DrawingStroke> strokes;
  final String? previewUrl;

  SavedDrawingItem({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.strokes,
    this.previewUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'strokes': strokes.map((s) => s.toJson()).toList(),
        'previewUrl': previewUrl,
      };

  factory SavedDrawingItem.fromJson(Map<String, dynamic> json) => SavedDrawingItem(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        strokes: (json['strokes'] as List<dynamic>? ?? [])
            .map((s) => DrawingStroke.fromJson(s as Map<String, dynamic>))
            .toList(),
        previewUrl: json['previewUrl'] as String?,
      );
}

class DualCanvasScreen extends StatefulWidget {
  final Function(String label, String imageUrl)? onSaveAsCard;
  final VoidCallback? onBack;

  const DualCanvasScreen({
    super.key,
    this.onSaveAsCard,
    this.onBack,
  });

  @override
  State<DualCanvasScreen> createState() => _DualCanvasScreenState();
}

class _DualCanvasScreenState extends State<DualCanvasScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<DrawingStroke> _completedStrokes = [];
  final Map<int, DrawingStroke> _activeStrokes = {};
  final TransformationController _transformationController = TransformationController();

  Color _selectedColor = AppColors.pureBlack;
  double _strokeWidth = 5.0;
  bool _isExporting = false;
  // Scale & Navigation state
  double _currentScale = 1.0;
  bool _isPanMode = false; // false: mode gambar (pensil), true: mode geser (tangan)
  Offset? _lastPanPosition;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
    _loadDrawingsFromSupabase();
  }

  Future<void> _loadDrawingsFromSupabase({VoidCallback? onDone}) async {
    try {
      final records = await SupabaseService.getSavedDrawings();
      if (records.isNotEmpty && mounted) {
        final items = <SavedDrawingItem>[];
        for (final r in records) {
          try {
            final rawStrokeData = r['stroke_data'] ?? r['strokes'];
            final List strokesData;
            if (rawStrokeData is List) {
              strokesData = rawStrokeData;
            } else if (rawStrokeData is String) {
              strokesData = jsonDecode(rawStrokeData) as List;
            } else {
              strokesData = [];
            }

            final strokes = strokesData
                .map((s) => DrawingStroke.fromJson(s))
                .toList();

            items.add(
              SavedDrawingItem(
                id: r['id']?.toString() ?? '',
                title: (r['label'] ?? r['title'] ?? 'Tanpa Nama') as String,
                createdAt: DateTime.tryParse(r['created_at'] as String? ?? '') ?? DateTime.now(),
                strokes: strokes,
                previewUrl: (r['image_url'] ?? r['preview_url']) as String?,
              ),
            );
          } catch (itemError) {
            debugPrint('Error parsing drawing item: $itemError');
          }
        }
        if (mounted) {
          setState(() {
            _savedDrawings
              ..clear()
              ..addAll(items);
          });
          onDone?.call();
        }
      } else {
        onDone?.call();
      }
    } catch (e) {
      debugPrint('Error loading drawings from Supabase: $e');
      onDone?.call();
    }
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.01) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  void _zoomIn() {
    HapticFeedback.selectionClick();
    final currentMatrix = _transformationController.value;
    final newScale = (_currentScale * 1.25).clamp(0.01, 5.0);
    final factor = newScale / _currentScale;
    
    // Zoom centered
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    
    final translation = Matrix4.translationValues(center.dx, center.dy, 0.0);
    final scaleMatrix = Matrix4.identity()..scale(factor, factor);
    final invTranslation = Matrix4.translationValues(-center.dx, -center.dy, 0.0);
    
    final newMatrix = translation * scaleMatrix * invTranslation * currentMatrix;
    _transformationController.value = newMatrix;
  }

  void _zoomOut() {
    HapticFeedback.selectionClick();
    final currentMatrix = _transformationController.value;
    final newScale = (_currentScale / 1.25).clamp(0.01, 5.0);
    final factor = newScale / _currentScale;
    
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    
    final translation = Matrix4.translationValues(center.dx, center.dy, 0.0);
    final scaleMatrix = Matrix4.identity()..scale(factor, factor);
    final invTranslation = Matrix4.translationValues(-center.dx, -center.dy, 0.0);
    
    final newMatrix = translation * scaleMatrix * invTranslation * currentMatrix;
    _transformationController.value = newMatrix;
  }

  void _resetZoom() {
    HapticFeedback.mediumImpact();
    _transformationController.value = Matrix4.identity();
  }

  Offset _toCanvasCoordinates(Offset globalPosition) {
    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      return renderBox.globalToLocal(globalPosition);
    }
    return globalPosition;
  }

  // 6 Primary customizable color slots (warna utama)
  late List<Color> _palette = [
    const Color(0xFF1E242B), // Hitam Slate
    const Color(0xFFE2F952), // Kuning Neon / Lemon
    const Color(0xFFFF5252), // Merah / Coral
    const Color(0xFF3B82F6), // Biru Cerah
    const Color(0xFF10B981), // Hijau Emerald
    const Color(0xFFA855F7), // Ungu
    const Color(0xFFF97316), // Oranye
  ];

  // Curated spectrum presets grouped by hue family for comprehensive selection
  static const Map<String, List<Color>> _colorSpectrumGroups = {
    'Netral & Monokrom': [
      Color(0xFF000000), Color(0xFF1E242B), Color(0xFF475569), Color(0xFF94A3B8),
      Color(0xFFCBD5E1), Color(0xFFF1F5F9), Color(0xFFFFFFFF), Color(0xFF78350F),
    ],
    'Merah & Pink': [
      Color(0xFF7F1D1D), Color(0xFFB91C1C), Color(0xFFEF4444), Color(0xFFF87171),
      Color(0xFF831843), Color(0xFFDB2777), Color(0xFFEC4899), Color(0xFFF472B6),
    ],
    'Oranye & Cokelat': [
      Color(0xFF7C2D12), Color(0xFFC2410C), Color(0xFFEA580C), Color(0xFFFB923C),
      Color(0xFF451A03), Color(0xFF92400E), Color(0xFFD97706), Color(0xFFFBBF24),
    ],
    'Kuning & Lemon': [
      Color(0xFF713F12), Color(0xFFA16207), Color(0xFFEAB308), Color(0xFFFDE047),
      Color(0xFF3F6212), Color(0xFF65A30D), Color(0xFF84CC16), Color(0xFFE2F952),
    ],
    'Hijau': [
      Color(0xFF14532D), Color(0xFF15803D), Color(0xFF22C55E), Color(0xFF4ADE80),
      Color(0xFF064E3B), Color(0xFF0D9488), Color(0xFF14B8A6), Color(0xFF2DD4BF),
    ],
    'Biru & Cyan': [
      Color(0xFF164E63), Color(0xFF0891B2), Color(0xFF06B6D4), Color(0xFF67E8F9),
      Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF3B82F6), Color(0xFF60A5FA),
    ],
    'Ungu & Violet': [
      Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1), Color(0xFF818CF8),
      Color(0xFF581C87), Color(0xFF7E22CE), Color(0xFFA855F7), Color(0xFFC084FC),
    ],
  };

  void _openFullColorPicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 8),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.r28),
            border: Border.all(color: AppColors.borderCard, width: 1.2),
            boxShadow: AppShadows.floatingDockShadow,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderCard,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Header Modal (Title + Close Button)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.pureBlack, width: 2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Pilih Warna Kuas",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          fontFamily: AppTypography.fontFamily,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.surfacePill,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderCard, width: 0.8),
                          ),
                          child: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: AppColors.borderCard),

                // 8-Color Grid per Line (Responsive)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth = constraints.maxWidth - 40; // 20 left & 20 right padding
                      const double spacing = 8.0;
                      // 8 items per row -> 7 gaps
                      final double itemSize = ((availableWidth - (spacing * 7)) / 8).clamp(32.0, 56.0);

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _colorSpectrumGroups.entries.map((group) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    group.key,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: AppTypography.fontFamily,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: group.value.map((c) {
                                      final isChosen = _selectedColor.value == c.value;
                                      return GestureDetector(
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          setState(() {
                                            _selectedColor = c;
                                          });
                                          Navigator.pop(ctx);
                                        },
                                        child: Container(
                                          width: itemSize,
                                          height: itemSize,
                                          decoration: BoxDecoration(
                                            color: c,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isChosen ? AppColors.pureBlack : AppColors.borderCard,
                                              width: isChosen ? 3.5 : 1.2,
                                            ),
                                            boxShadow: isChosen
                                                ? AppShadows.buttonGlow(c)
                                                : [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.08),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                          ),
                                          child: isChosen
                                              ? Center(
                                                  child: Icon(
                                                    Icons.check_rounded,
                                                    size: itemSize * 0.5,
                                                    color: c.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_isPanMode) {
      _lastPanPosition = event.position;
      return;
    }

    HapticFeedback.selectionClick();
    final canvasLocalPos = _toCanvasCoordinates(event.position);
    setState(() {
      _activeStrokes[event.pointer] = DrawingStroke(
        pointerId: event.pointer,
        points: [
          StrokePoint(
            offset: canvasLocalPos,
            color: _selectedColor,
            strokeWidth: _strokeWidth,
          ),
        ],
        color: _selectedColor,
        strokeWidth: _strokeWidth,
      );
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_isPanMode) {
      if (_lastPanPosition != null) {
        final delta = event.position - _lastPanPosition!;
        _lastPanPosition = event.position;
        final panMatrix = Matrix4.translationValues(delta.dx, delta.dy, 0.0);
        _transformationController.value = panMatrix * _transformationController.value;
      }
      return;
    }

    if (_activeStrokes.containsKey(event.pointer)) {
      final canvasLocalPos = _toCanvasCoordinates(event.position);
      setState(() {
        _activeStrokes[event.pointer]!.points.add(
              StrokePoint(
                offset: canvasLocalPos,
                color: _selectedColor,
                strokeWidth: _strokeWidth,
              ),
            );
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isPanMode) {
      _lastPanPosition = null;
      return;
    }

    if (_activeStrokes.containsKey(event.pointer)) {
      setState(() {
        _completedStrokes.add(_activeStrokes[event.pointer]!);
        _activeStrokes.remove(event.pointer);
      });
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (_isPanMode) {
      _lastPanPosition = null;
      return;
    }

    if (_activeStrokes.containsKey(event.pointer)) {
      setState(() {
        _activeStrokes.remove(event.pointer);
      });
    }
  }

  void _clearCanvas() {
    HapticFeedback.mediumImpact();
    setState(() {
      _completedStrokes.clear();
      _activeStrokes.clear();
    });
  }

  void _undoLastStroke() {
    if (_completedStrokes.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() {
        _completedStrokes.removeLast();
      });
    }
  }

  /// Export multi-touch canvas to real PNG & upload to Cloudflare R2
  Future<String?> _exportCanvasToR2(String label) async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();
      final fileName = 'ali_drawing_${DateTime.now().millisecondsSinceEpoch}.png';

      final uploadedUrl = await R2StorageService.uploadFile(
        bytes: pngBytes,
        path: 'canvas_drawings/$fileName',
        contentType: 'image/png',
      );

      return uploadedUrl;
    } catch (e) {
      debugPrint('Error exporting canvas: $e');
      return null;
    }
  }

  // In-memory & local persistent storage for saved drawings
  static final List<SavedDrawingItem> _savedDrawings = [];

  void _saveCurrentDrawing() {
    if (_completedStrokes.isEmpty && _activeStrokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kanvas masih kosong, yuk gambar dulu!'),
          backgroundColor: AppColors.pureBlack,
        ),
      );
      return;
    }

    final textController = TextEditingController(
      text: 'Gambar Ali #${_savedDrawings.length + 1}',
    );

    AliModal.showDeckModal(
      context: context,
      title: 'Simpan Gambar',
      subtitle: 'Simpan goresan gambar agar bisa dibuka dan dimainkan lagi nanti',
      body: Column(
        children: [
          AliSmartInput(
            controller: textController,
            hintText: 'Nama Gambar (misal: Rumahku, Kucing Ali)',
            prefixIcon: Iconsax.edit,
          ),
        ],
      ),
      actions: [
        AliButton(
          label: 'Batal',
          variant: AliButtonVariant.outline,
          onPressed: () => Navigator.pop(context),
        ),
        AliButton(
          label: 'Simpan',
          variant: AliButtonVariant.primaryHighContrast,
          onPressed: () {
            final title = textController.text.trim();
            if (title.isNotEmpty) {
              Navigator.pop(context);

              // Copy completed strokes instantly
              final clonedStrokes = _completedStrokes
                  .map((s) => DrawingStroke(
                        pointerId: s.pointerId,
                        points: List.from(s.points),
                        color: s.color,
                        strokeWidth: s.strokeWidth,
                      ))
                  .toList();

              final item = SavedDrawingItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                createdAt: DateTime.now(),
                strokes: clonedStrokes,
              );

              setState(() {
                _savedDrawings.insert(0, item);
              });

              // Asynchronously persist to Supabase (ali_canvas_art)
              final strokesList = clonedStrokes.map((s) => s.toJson()).toList();
              SupabaseService.saveDrawing(
                title: item.title,
                strokeData: strokesList,
              ).then((savedId) {
                if (savedId != null && savedId.isNotEmpty) {
                  debugPrint('Drawing "${item.title}" saved to Supabase with ID: $savedId');
                  final idx = _savedDrawings.indexWhere((d) => d.id == item.id);
                  if (idx != -1) {
                    _savedDrawings[idx] = SavedDrawingItem(
                      id: savedId,
                      title: item.title,
                      createdAt: item.createdAt,
                      strokes: item.strokes,
                      previewUrl: item.previewUrl,
                    );
                  }
                }
              });

              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.accentLemon, size: 20),
                      const SizedBox(width: 8),
                      Text('Gambar "$title" berhasil disimpan!'),
                    ],
                  ),
                  backgroundColor: AppColors.pureBlack,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void _openLoadDrawingsModal() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool isRefreshing = _savedDrawings.isEmpty;
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            // If initially empty, trigger a fetch
            if (isRefreshing) {
              _loadDrawingsFromSupabase(onDone: () {
                if (modalCtx.mounted) {
                  setModalState(() {
                    isRefreshing = false;
                  });
                }
              });
            }

            return Container(
              margin: const EdgeInsets.all(AppSpacing.s8),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.r28),
                border: Border.all(color: AppColors.borderCard, width: 1.2),
                boxShadow: AppShadows.floatingDockShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 6),
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.borderCard,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Header Modal
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePill,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderCard, width: 1.0),
                          ),
                          child: const Center(
                            child: Icon(Iconsax.folder_open, size: 20, color: AppColors.textPrimary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Buka Gambar Tersimpan',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: AppTypography.fontFamily,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_savedDrawings.length} gambar tersimpan',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Refresh button
                        IconButton(
                          icon: isRefreshing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
                                )
                              : const Icon(Iconsax.refresh, size: 20, color: AppColors.textPrimary),
                          onPressed: isRefreshing
                              ? null
                              : () {
                                  setModalState(() {
                                    isRefreshing = true;
                                  });
                                  _loadDrawingsFromSupabase(onDone: () {
                                    if (modalCtx.mounted) {
                                      setModalState(() {
                                        isRefreshing = false;
                                      });
                                    }
                                  });
                                },
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: AppColors.borderCard),

                  // List of Saved Drawings
                  Flexible(
                    child: isRefreshing && _savedDrawings.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(color: AppColors.pureBlack),
                            ),
                          )
                        : _savedDrawings.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(32),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfacePill,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.borderCard, width: 1.0),
                                      ),
                                      child: const Center(
                                        child: Icon(Iconsax.brush, size: 28, color: AppColors.textSecondary),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Belum ada gambar tersimpan',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Gambar di kanvas lalu tekan tombol "Simpan" di bawah.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            itemCount: _savedDrawings.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final drawing = _savedDrawings[index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCanvas,
                                  borderRadius: BorderRadius.circular(AppRadius.r16),
                                  border: Border.all(color: AppColors.borderCard, width: 1.0),
                                ),
                                child: Row(
                                  children: [
                                    // Thumbnail Vector Preview
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(AppRadius.r12),
                                        border: Border.all(color: AppColors.borderCard, width: 1.2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: drawing.previewUrl != null && drawing.previewUrl!.isNotEmpty
                                          ? Image.network(
                                              drawing.previewUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => _DrawingThumbnailWidget(strokes: drawing.strokes),
                                            )
                                          : _DrawingThumbnailWidget(strokes: drawing.strokes),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            drawing.title,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${drawing.strokes.length} goresan • ${drawing.createdAt.day}/${drawing.createdAt.month}/${drawing.createdAt.year}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Load Button
                                    AliButton(
                                      label: 'Buka',
                                      size: AliButtonSize.small,
                                      variant: AliButtonVariant.primaryHighContrast,
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        setState(() {
                                          _completedStrokes.clear();
                                          _activeStrokes.clear();
                                          _completedStrokes.addAll(
                                            drawing.strokes.map(
                                              (s) => DrawingStroke(
                                                pointerId: s.pointerId,
                                                points: List.from(s.points),
                                                color: s.color,
                                                strokeWidth: s.strokeWidth,
                                              ),
                                            ),
                                          );
                                        });
                                        HapticFeedback.mediumImpact();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Gambar "${drawing.title}" berhasil dimuat!'),
                                            backgroundColor: AppColors.pureBlack,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    // Delete Button
                                    GestureDetector(
                                      onTap: () {
                                        final deletedItem = _savedDrawings[index];
                                        setModalState(() {
                                          _savedDrawings.removeAt(index);
                                        });
                                        setState(() {});
                                        SupabaseService.deleteSavedDrawing(deletedItem.id);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Iconsax.trash, size: 18, color: AppColors.accentCoral),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          // Multi-Touch Dual Canvas Drawing Surface with Custom Direct Transformation
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: _onPointerDown,
              onPointerMove: _onPointerMove,
              onPointerUp: _onPointerUp,
              onPointerCancel: _onPointerCancel,
              child: AnimatedBuilder(
                animation: _transformationController,
                builder: (context, child) {
                  return Transform(
                    transform: _transformationController.value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.bgCanvas,
                  child: RepaintBoundary(
                    key: _canvasKey,
                    child: CustomPaint(
                      painter: _DualCanvasPainter(
                        completedStrokes: _completedStrokes,
                        activeStrokes: _activeStrokes.values.toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top Header & Sub-Header (Undo & Remove / Clear)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: AliHeaderSection(
                title: 'Kanvas Gambar Ali',
                subtitle: 'Gambar bebas dengan dua tangan & simpan hasilnya',
                onBackTap: widget.onBack,
                // Tombol Galeri di Kanan Header
                actionWidget: GestureDetector(
                  onTap: _openLoadDrawingsModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(color: AppColors.borderCard, width: 1.2),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AliIcon(Iconsax.folder_open, size: 18, color: AppColors.textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          _savedDrawings.isEmpty ? 'Galeri' : 'Galeri (${_savedDrawings.length})',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppTypography.fontFamily,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Sub-Header: Tombol Zoom In/Out, Undo & Remove / Clear Kanvas (Icon-Only Murni Tanpa Teks)
                bottomWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard, width: 1.0),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Row(
                    children: [
                      // Sleek Zoom Segmented Control Pill (- / scale% / +)
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePill,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.borderCard, width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Zoom Out
                            GestureDetector(
                              onTap: _zoomOut,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: const Center(
                                  child: Icon(Icons.remove_rounded, size: 18, color: AppColors.textPrimary),
                                ),
                              ),
                            ),
                            // Current Zoom Scale Indicator / Reset
                            GestureDetector(
                              onTap: _resetZoom,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (_currentScale - 1.0).abs() > 0.05
                                      ? AppColors.surfaceCard
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  border: (_currentScale - 1.0).abs() > 0.05
                                      ? Border.all(color: AppColors.borderCard, width: 0.8)
                                      : null,
                                ),
                                child: Text(
                                  '${(_currentScale * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTypography.fontFamily,
                                    color: (_currentScale - 1.0).abs() > 0.05
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            // Zoom In
                            GestureDetector(
                              onTap: _zoomIn,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add_rounded, size: 18, color: AppColors.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Kid-Friendly Mode Toggle: Gambar (Pensil) vs Geser (Tangan)
                      Container(
                        height: 40,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePill,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.borderCard, width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Mode Gambar (Pensil)
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _isPanMode = false;
                                  _lastPanPosition = null;
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: !_isPanMode ? AppColors.pureBlack : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  boxShadow: !_isPanMode
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 17,
                                    color: !_isPanMode ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            // Mode Geser Kanvas (Tangan / Pan)
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _isPanMode = true;
                                  _activeStrokes.clear();
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: _isPanMode ? AppColors.accentYellow : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                  boxShadow: _isPanMode
                                      ? [
                                          BoxShadow(
                                            color: AppColors.accentYellow.withValues(alpha: 0.4),
                                            blurRadius: 6,
                                            offset: const Offset(0, 1),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.pan_tool_rounded,
                                    size: 17,
                                    color: _isPanMode ? Colors.black : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Undo Button (Icon Only)
                      GestureDetector(
                        onTap: _undoLastStroke,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePill,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(color: AppColors.borderCard, width: 1.0),
                          ),
                          child: const Center(
                            child: AliIcon(Iconsax.undo, size: 18, color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Remove / Clear Canvas Button (Icon Only)
                      GestureDetector(
                        onTap: _clearCanvas,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePill,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(color: AppColors.accentCoral.withValues(alpha: 0.35), width: 1.0),
                          ),
                          child: const Center(
                            child: AliIcon(Iconsax.trash, size: 18, color: AppColors.accentCoral),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Controls Dock: Warna (Swatch saja), Ukuran Kuas (Dot saja tanpa teks), Simpan
          Positioned(
            bottom: 24,
            left: AppSpacing.screenMargin,
            right: AppSpacing.screenMargin,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.borderCard, width: 1.2),
                  boxShadow: AppShadows.floatingDockShadow,
                ),
                child: Row(
                  children: [
                    // 1. Pilih Warna (Swatch saja murni tanpa teks)
                    GestureDetector(
                      onTap: _openFullColorPicker,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePill,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.borderCard, width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _selectedColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.pureBlack, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: _selectedColor.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.colorize_rounded,
                                  size: 15,
                                  color: _selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // 2. Ukuran Kuas (Dot trigger saja murni tanpa teks)
                    GestureDetector(
                      onTap: _openBrushSizeModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePill,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.borderCard, width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: _strokeWidth.clamp(4.0, 16.0),
                                  height: _strokeWidth.clamp(4.0, 16.0),
                                  decoration: const BoxDecoration(
                                    color: AppColors.textPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 3. Tombol Simpan Gambar
                    AliButton(
                      label: _isExporting ? 'Menyimpan...' : 'Simpan',
                      size: AliButtonSize.medium,
                      isLoading: _isExporting,
                      variant: AliButtonVariant.primaryHighContrast,
                      prefixIcon: const AliIcon(Iconsax.document_download, size: 18, color: AppColors.accentLemon),
                      onPressed: _saveCurrentDrawing,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBrushSizeModal() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final sizes = [
              {'label': 'Halus', 'val': 3.0, 'dot': 6.0},
              {'label': 'Sedang', 'val': 6.0, 'dot': 12.0},
              {'label': 'Tebal', 'val': 11.0, 'dot': 18.0},
              {'label': 'Sangat Tebal', 'val': 18.0, 'dot': 26.0},
            ];

            return Container(
              margin: const EdgeInsets.all(AppSpacing.s8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.r28),
                border: Border.all(color: AppColors.borderCard, width: 1.2),
                boxShadow: AppShadows.floatingDockShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.borderCard,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Ukuran Kuas Gambar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppTypography.fontFamily,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: sizes.map((s) {
                      final val = s['val'] as double;
                      final isSel = _strokeWidth == val;
                      final dot = s['dot'] as double;
                      final label = s['label'] as String;

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _strokeWidth = val);
                          Navigator.pop(ctx);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.pureBlack : AppColors.surfacePill,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSel ? AppColors.pureBlack : AppColors.borderCard,
                                  width: 1.2,
                                ),
                                boxShadow: isSel ? [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 3))] : null,
                              ),
                              child: Center(
                                child: Container(
                                  width: dot,
                                  height: dot,
                                  decoration: BoxDecoration(
                                    color: isSel ? AppColors.accentLemon : AppColors.textPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getBrushSizeLabel(double width) {
    if (width <= 3.0) return 'Halus';
    if (width <= 6.0) return 'Sedang';
    if (width <= 11.0) return 'Tebal';
    return 'Besar';
  }
}

class _DualCanvasPainter extends CustomPainter {
  final List<DrawingStroke> completedStrokes;
  final List<DrawingStroke> activeStrokes;

  _DualCanvasPainter({
    required this.completedStrokes,
    required this.activeStrokes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final allStrokes = [...completedStrokes, ...activeStrokes];

    for (final stroke in allStrokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.strokeWidth
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first.offset,
          stroke.strokeWidth / 2,
          Paint()..color = stroke.color,
        );
      } else {
        final path = Path();
        path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);

        for (int i = 1; i < stroke.points.length; i++) {
          final p0 = stroke.points[i - 1].offset;
          final p1 = stroke.points[i].offset;
          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            (p0.dx + p1.dx) / 2,
            (p0.dy + p1.dy) / 2,
          );
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DualCanvasPainter oldDelegate) => true;
}

class _DrawingThumbnailWidget extends StatelessWidget {
  final List<DrawingStroke> strokes;

  const _DrawingThumbnailWidget({required this.strokes});

  @override
  Widget build(BuildContext context) {
    if (strokes.isEmpty) {
      return const Center(
        child: Icon(Iconsax.brush_2, color: AppColors.textSecondary, size: 20),
      );
    }

    return CustomPaint(
      painter: _ThumbnailPainter(strokes: strokes),
      size: Size.infinite,
    );
  }
}

class _ThumbnailPainter extends CustomPainter {
  final List<DrawingStroke> strokes;

  _ThumbnailPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;

    // Calculate bounding box of all points
    double minX = double.infinity;
    double maxX = -double.infinity;
    double minY = double.infinity;
    double maxY = -double.infinity;

    for (final s in strokes) {
      for (final p in s.points) {
        if (p.offset.dx < minX) minX = p.offset.dx;
        if (p.offset.dx > maxX) maxX = p.offset.dx;
        if (p.offset.dy < minY) minY = p.offset.dy;
        if (p.offset.dy > maxY) maxY = p.offset.dy;
      }
    }

    if (minX == double.infinity || maxX == -double.infinity) return;

    final boundsWidth = (maxX - minX).clamp(10.0, double.infinity);
    final boundsHeight = (maxY - minY).clamp(10.0, double.infinity);

    // Padding inside thumbnail
    const double pad = 4.0;
    final drawW = size.width - pad * 2;
    final drawH = size.height - pad * 2;

    final scale = (drawW / boundsWidth < drawH / boundsHeight
            ? drawW / boundsWidth
            : drawH / boundsHeight)
        .clamp(0.01, 10.0);

    canvas.save();
    canvas.translate(
      pad + (drawW - boundsWidth * scale) / 2 - minX * scale,
      pad + (drawH - boundsHeight * scale) / 2 - minY * scale,
    );
    canvas.scale(scale, scale);

    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = (stroke.strokeWidth).clamp(2.0, 10.0)
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first.offset,
          stroke.strokeWidth / 2,
          Paint()..color = stroke.color,
        );
      } else {
        final path = Path();
        path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);

        for (int i = 1; i < stroke.points.length; i++) {
          final p0 = stroke.points[i - 1].offset;
          final p1 = stroke.points[i].offset;
          path.quadraticBezierTo(
            p0.dx,
            p0.dy,
            (p0.dx + p1.dx) / 2,
            (p0.dy + p1.dy) / 2,
          );
        }

        canvas.drawPath(path, paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ThumbnailPainter oldDelegate) => false;
}
