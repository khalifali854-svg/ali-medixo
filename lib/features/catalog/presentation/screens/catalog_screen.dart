import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme_tokens.dart';
import '../../../../core/components/ali_icon.dart';
import '../../../../core/components/ali_button.dart';
import '../../../../core/components/ali_modal.dart';
import '../../../../core/components/ali_camera_helper.dart';
import '../../../../core/components/ali_grid_card_section.dart';
import '../../../../core/components/ali_header_section.dart';
import '../../../../core/components/ali_network_image.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/audio_engine_service.dart';
import '../../../../core/services/r2_storage_service.dart';
import '../../../../core/services/audio_recorder_service.dart';
import '../../../../core/services/local_cache_service.dart';
import '../../../../core/components/ali_smart_image_search_modal.dart';
import '../../domain/models/catalog_category_model.dart';
import '../../domain/models/catalog_item_model.dart';
import '../../domain/models/catalog_defaults.dart';
import 'guess_image_game_screen.dart';

class CatalogScreen extends StatefulWidget {
  final Function(String word)? onPracticeWriting;

  const CatalogScreen({
    super.key,
    this.onPracticeWriting,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<CatalogCategoryModel> _categories = [];
  List<CatalogItemModel> _items = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    setState(() => _isLoading = true);
    var cats = await SupabaseService.getCatalogCategories();
    var items = await SupabaseService.getCatalogItems();

    // Pastikan kategori Hijaiyah & Huruf/Angka selalu ada
    for (final defaultCat in CatalogDefaults.defaultCategories) {
      if (!cats.any((c) => c.id == defaultCat.id)) {
        cats.add(defaultCat);
      }
    }

    // Pastikan kartu Hijaiyah ada dalam koleksi kosa kata
    if (!items.any((i) => i.categoryId == 'hijaiyah')) {
      items = [...items, ...CatalogDefaults.hijaiyahItems];
    }

    // Pastikan angka & alfabet ada dalam kategori alfabet_angka
    if (!items.any((i) => i.categoryId == 'alfabet_angka')) {
      items = [...items, ...CatalogDefaults.alphaNumItems];
    }

    if (mounted) {
      setState(() {
        _categories = cats;
        _items = items;
        _isLoading = false;
      });
    }
  }

  List<CatalogItemModel> get _filteredItems {
    var list = _items;
    if (_selectedCategoryId != 'all') {
      list = list.where((i) => i.categoryId == _selectedCategoryId).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((i) => i.name.toLowerCase().contains(q) || (i.phonics?.toLowerCase().contains(q) ?? false)).toList();
    }
    return CatalogDefaults.sortCatalogItems(list);
  }

  void _speak(CatalogItemModel item) {
    if (item.categoryId == 'hijaiyah') {
      final phonetic = AudioEngineService.getArabicPhoneticFallback(item.name);
      AudioEngineService.speakWord(
        text: item.name,
        phoneticFallback: phonetic,
        audioUrl: item.audioUrl,
      );
    } else {
      AudioEngineService.speakWord(
        text: item.name,
        audioUrl: item.audioUrl,
      );
    }
  }

  String _getCategoryLabel(String categoryId) {
    for (final c in _categories) {
      if (c.id == categoryId) return c.nameId;
    }
    switch (categoryId) {
      case 'hewan':
        return 'Hewan';
      case 'buah_makanan':
        return 'Makanan';
      case 'benda':
        return 'Benda';
      case 'aksi_aac':
        return 'Aksi';
      case 'kendaraan':
        return 'Kendaraan';
      case 'tubuh':
        return 'Tubuh';
      case 'alam':
        return 'Alam';
      case 'hijaiyah':
        return 'Hijaiyah';
      case 'alfabet_angka':
        return 'Huruf & Angka';
      default:
        return categoryId;
    }
  }

  String _getCategoryEmoji(String id) {
    switch (id) {
      case 'hewan':
        return '🐱';
      case 'buah_makanan':
        return '🍎';
      case 'benda':
        return '🪑';
      case 'aksi_aac':
        return '🗣️';
      case 'kendaraan':
        return '🚗';
      case 'tubuh':
        return '👁️';
      case 'alam':
        return '☀️';
      case 'hijaiyah':
        return '🕌';
      case 'alfabet_angka':
        return '🔤';
      default:
        return '📦';
    }
  }

  String _mapToAacCategoryId(String catId) {
    switch (catId) {
      case 'hewan':
        return 'a0000001-0000-0000-0000-000000000003';
      default:
        return 'a0000001-0000-0000-0000-000000000002';
    }
  }

  void _openGuessImageGame({CatalogItemModel? initialItem}) {
    final targetList = _filteredItems.isNotEmpty ? _filteredItems : _items;
    if (targetList.isEmpty) return;

    int initialIndex = 0;
    if (initialItem != null) {
      final found = targetList.indexWhere((i) => i.id == initialItem.id);
      if (found != -1) initialIndex = found;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GuessImageGameScreen(
          items: targetList,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _showItemActions(CatalogItemModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: AliNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTypography.displayMedium(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.phonics ?? item.syllables.join(' • '),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AliButton(
                      label: 'Dengarkan Suara',
                      prefixIcon: const AliIcon(Iconsax.volume_high, size: 18),
                      variant: AliButtonVariant.primaryHighContrast,
                      onPressed: () {
                        _speak(item);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  if (widget.onPracticeWriting != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: AliButton(
                        label: 'Latihan Tulis',
                        prefixIcon: const AliIcon(Iconsax.edit_2, size: 18),
                        variant: AliButtonVariant.electricLemon,
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                          widget.onPracticeWriting!(item.name);
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AliButton(
                  label: 'Salin ke Papan Bicara AAC',
                  prefixIcon: const AliIcon(Iconsax.add_square, size: 18),
                  variant: AliButtonVariant.outline,
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final success = await SupabaseService.insertVocabCard(
                      categoryId: _mapToAacCategoryId(item.categoryId),
                      label: item.name,
                      imageUrl: item.imageUrl,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Berhasil menambahkan "${item.name}" ke Papan Bicara AAC!'
                                : 'Gagal menambahkan ke Papan Bicara AAC',
                          ),
                          backgroundColor: success ? AppColors.pureBlack : Colors.red.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AliButton(
                  label: 'Main Tebak Gambar Ini 🎤',
                  prefixIcon: const AliIcon(Iconsax.microphone_2, size: 18, color: AppColors.pureBlack),
                  variant: AliButtonVariant.electricLemon,
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openGuessImageGame(initialItem: item);
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AliButton(
                  label: 'Edit Kosa Kata & Foto ✏️',
                  prefixIcon: const AliIcon(Iconsax.edit, size: 18),
                  variant: AliButtonVariant.outline,
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openEditCatalogItemModal(item);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openEditCatalogItemModal(CatalogItemModel item) {
    Uint8List? selectedImageBytes;
    String? customUrl;
    Uint8List? recordedAudioBytes;
    String? currentAudioUrl = item.audioUrl;
    bool isRecording = false;
    bool isSaving = false;
    String selectedCategory = item.categoryId;
    final nameCtrl = TextEditingController(text: item.name);
    final phonicsCtrl = TextEditingController(text: item.phonics ?? item.syllables.join('-'));
    final urlCtrl = TextEditingController();

    AliModal.showDeckModal(
      context: context,
      title: 'Edit Kosa Kata "${item.name}"',
      subtitle: 'Ubah nama, kategori, suara, ejaan suku kata, atau foto',
      isFullHeight: true,
      body: StatefulBuilder(
        builder: (modalContext, setModalState) {
          final hasImage = selectedImageBytes != null || (customUrl != null && customUrl!.trim().isNotEmpty) || item.imageUrl.isNotEmpty;
          final hasVisual = hasImage || selectedCategory == 'hijaiyah' || (item.emoji != null && item.emoji!.isNotEmpty);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Nama Kosa Kata
                const Text(
                  'Nama Benda / Kata',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: TextField(
                    controller: nameCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: 'Nama benda / kata...',
                      hintStyle: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                    onChanged: (v) => setModalState(() {}),
                  ),
                ),

                const SizedBox(height: 14),

                // 2. Kategori
                const Text(
                  'Kategori Katalog',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _categories.any((c) => c.id == selectedCategory)
                          ? selectedCategory
                          : (_categories.isNotEmpty ? _categories.first.id : null),
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      items: _categories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.id,
                          child: Text(
                            '${_getCategoryEmoji(c.id)}  ${c.nameId}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Ejaan / Suku Kata
                const Text(
                  'Ejaan / Suku Kata',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: TextField(
                    controller: phonicsCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                    decoration: const InputDecoration(
                      hintText: 'Contoh: bu-a-ya atau mo-bil',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 4. Suara / Audio Kosa Kata (Rekam 1 Detik)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCategory == 'hijaiyah' ? 'Suara Makhraj / Lafal Huruf' : 'Suara Kosa Kata',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (currentAudioUrl != null || recordedAudioBytes != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
                            SizedBox(width: 4),
                            Text('Ada Suara', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Rekam suara pelafalan selama 1 detik atau dengarkan suara saat ini.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),

                // Container box untuk rekaman audio
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: isRecording ? Colors.red.shade300 : AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(
                            isRecording ? Icons.stop_rounded : Iconsax.microphone_2,
                            size: 18,
                            color: isRecording ? Colors.white : AppColors.pureBlack,
                          ),
                          label: Text(
                            isRecording
                                ? 'Sedang Merekam... (Ketuk Selesai)'
                                : (currentAudioUrl != null ? 'Ganti Suara Rekaman' : 'Rekam Suara Baru'),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: isRecording ? Colors.white : AppColors.pureBlack,
                              fontSize: 13,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRecording ? Colors.red.shade600 : AppColors.accentLemon,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (isRecording) {
                              // Ketuk untuk langsung menyelesaikan rekaman
                              final bytes = await AudioRecorderService.stopRecording();
                              setModalState(() {
                                isRecording = false;
                                if (bytes != null && bytes.isNotEmpty) {
                                  recordedAudioBytes = bytes;
                                  currentAudioUrl = 'data:audio/mp4;base64,${base64Encode(bytes)}';
                                }
                              });
                              if (bytes != null && bytes.isNotEmpty) {
                                AudioEngineService.speakWord(
                                  text: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : item.name,
                                  audioUrl: currentAudioUrl,
                                );
                              }
                            } else {
                              // Ketuk untuk mulai merekam
                              final started = await AudioRecorderService.startRecording();
                              if (started) {
                                setModalState(() => isRecording = true);
                                // Beri durasi leluasa hingga 4 detik jika tidak dihentikan manual
                                Future.delayed(const Duration(seconds: 4), () async {
                                  if (isRecording) {
                                    final bytes = await AudioRecorderService.stopRecording();
                                    setModalState(() {
                                      isRecording = false;
                                      if (bytes != null && bytes.isNotEmpty) {
                                        recordedAudioBytes = bytes;
                                        currentAudioUrl = 'data:audio/mp4;base64,${base64Encode(bytes)}';
                                      }
                                    });
                                    if (bytes != null && bytes.isNotEmpty) {
                                      AudioEngineService.speakWord(
                                        text: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : item.name,
                                        audioUrl: currentAudioUrl,
                                      );
                                    }
                                  }
                                });
                              }
                            }
                          },
                        ),
                      ),

                      if (currentAudioUrl != null || recordedAudioBytes != null) ...[
                        const SizedBox(width: 8),
                        // Tombol Play / Tes Dengar
                        IconButton(
                          tooltip: 'Dengarkan Suara',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.pureBlack,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                          ),
                          icon: const Icon(Iconsax.volume_high, size: 18),
                          onPressed: () {
                            AudioEngineService.speakWord(
                              text: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : item.name,
                              audioUrl: currentAudioUrl,
                            );
                          },
                        ),
                        // Tombol Hapus / Reset Suara
                        IconButton(
                          tooltip: 'Hapus Rekaman',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                          ),
                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                          onPressed: () {
                            setModalState(() {
                              recordedAudioBytes = null;
                              currentAudioUrl = null;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 5. Foto Objek
                const Text(
                  'Foto Objek',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceInput,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(
                        color: hasImage ? const Color(0xFF22C55E) : AppColors.borderCard,
                        width: 1.5,
                      ),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      child: selectedImageBytes != null
                          ? Image.memory(selectedImageBytes!, fit: BoxFit.cover)
                          : (customUrl != null && customUrl!.isNotEmpty
                              ? Image.network(
                                  customUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image_rounded, size: 36, color: Colors.grey),
                                  ),
                                )
                              : AliNetworkImage(
                                  imageUrl: item.imageUrl,
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Pilihan Kamera, Galeri, Smart Search
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt_rounded, size: 17, color: AppColors.textPrimary),
                        label: const Text('Kamera', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          side: const BorderSide(color: AppColors.borderCard),
                        ),
                        onPressed: () async {
                          final bytes = await AliCameraHelper.capturePhoto(context);
                          if (bytes != null) {
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customUrl = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.photo_library_rounded, size: 17, color: AppColors.textPrimary),
                        label: const Text('Galeri', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          side: const BorderSide(color: AppColors.borderCard),
                        ),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (picked != null) {
                            final bytes = await picked.readAsBytes();
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customUrl = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Text('🔍', style: TextStyle(fontSize: 14)),
                        label: const Text('Cari Web', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.pureBlack, fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentLemon,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          _openSmartImageSearchModal(
                            initialQuery: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : item.name,
                            onImageSelected: (url) {
                              setModalState(() {
                                customUrl = url;
                                selectedImageBytes = null;
                                urlCtrl.text = url;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Tempel Link URL Foto
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.link_rounded, size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: urlCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Atau tempel link gambar (URL)...',
                            hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (v) {
                            if (v.trim().isNotEmpty) {
                              setModalState(() {
                                customUrl = v.trim();
                                selectedImageBytes = null;
                              });
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (urlCtrl.text.trim().isNotEmpty) {
                            setModalState(() {
                              customUrl = urlCtrl.text.trim();
                              selectedImageBytes = null;
                            });
                          }
                        },
                        child: const Text('Lihat', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12.5)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Simpan Perubahan
                SizedBox(
                  width: double.infinity,
                  child: AliButton(
                    label: isSaving ? 'Menyimpan Perubahan...' : 'Simpan Perubahan',
                    prefixIcon: const AliIcon(Iconsax.tick_circle, size: 20),
                    variant: AliButtonVariant.electricLemon,
                    isLoading: isSaving,
                    onPressed: (nameCtrl.text.trim().isEmpty || !hasVisual || isSaving)
                        ? null
                        : () async {
                            setModalState(() => isSaving = true);

                            String finalImageUrl = item.imageUrl;

                            if (selectedImageBytes != null) {
                              final filename = 'catalog_${item.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              final uploadedUrl = await SupabaseService.uploadImage(
                                bytes: selectedImageBytes!,
                                fileName: filename,
                              );
                              if (uploadedUrl != null) {
                                finalImageUrl = uploadedUrl;
                              }
                            } else if (customUrl != null && customUrl!.trim().isNotEmpty) {
                              final filename = 'photos/catalog_${item.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              final r2Url = await R2StorageService.uploadFileFromRemoteUrl(
                                remoteUrl: customUrl!.trim(),
                                path: filename,
                              );
                              finalImageUrl = r2Url ?? customUrl!.trim();
                            }

                            // Simpan atau upload rekaman audio baru jika ada
                            String? finalAudioUrl = currentAudioUrl;
                            if (recordedAudioBytes != null) {
                              final audioFilename = 'catalog_${item.id}_${DateTime.now().millisecondsSinceEpoch}.m4a';
                              final uploadedAudio = await SupabaseService.uploadAudio(
                                bytes: recordedAudioBytes!,
                                fileName: audioFilename,
                              );
                              finalAudioUrl = uploadedAudio ?? 'data:audio/mp4;base64,${base64Encode(recordedAudioBytes!)}';
                            }

                            final word = nameCtrl.text.trim();
                            final rawPhonics = phonicsCtrl.text.trim();
                            final syllablesList = rawPhonics.isNotEmpty
                                ? rawPhonics.split(RegExp(r'[-•\s]+')).where((s) => s.isNotEmpty).toList()
                                : [word];

                            final updatedItem = item.copyWith(
                              categoryId: selectedCategory,
                              name: word,
                              imageUrl: finalImageUrl,
                              audioUrl: finalAudioUrl,
                              phonics: rawPhonics.isNotEmpty ? rawPhonics : null,
                              syllables: syllablesList,
                            );

                            final success = await SupabaseService.updateCatalogItem(updatedItem);

                            // Perbarui daftar lokal & cache agar langsung aktif tanpa restart
                            final itemIndex = _items.indexWhere((i) => i.id == item.id);
                            if (itemIndex != -1) {
                              setState(() {
                                _items[itemIndex] = updatedItem;
                              });
                            }
                            await LocalCacheService.cacheCatalogItems(_items);

                            if (mounted) {
                              Navigator.pop(modalContext);
                              await _loadCatalog();

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success ? 'Kosa kata "$word" dan suara berhasil disimpan!' : 'Kosa kata dan suara disimpan secara lokal!'),
                                    backgroundColor: AppColors.pureBlack,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              }
                            }
                          },
                  ),
                ),

                const SizedBox(height: 12),

                // Tombol Hapus Kosa Kata
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                    label: const Text('Hapus Kosa Kata Ini', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                      side: BorderSide(color: Colors.red.shade300),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: modalContext,
                        builder: (dCtx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r20)),
                          title: const Text('Hapus Kosa Kata?', style: TextStyle(fontWeight: FontWeight.w800)),
                          content: Text('Apakah Anda yakin ingin menghapus "${item.name}" dari katalog?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, true),
                              child: const Text('Hapus', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        setModalState(() => isSaving = true);
                        await SupabaseService.deleteCatalogItem(item.id);
                        if (mounted) {
                          Navigator.pop(modalContext);
                          await _loadCatalog();
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openSmartImageSearchModal({
    required String initialQuery,
    required Function(String imageUrl) onImageSelected,
  }) {
    AliSmartImageSearchModal.show(
      context: context,
      initialQuery: initialQuery,
      onImageSelected: onImageSelected,
    );
  }

  void _openAddCatalogItemModal() {
    Uint8List? selectedImageBytes;
    String? customUrl;
    bool isSaving = false;
    String selectedCategory = _selectedCategoryId != 'all' ? _selectedCategoryId : (_categories.isNotEmpty ? _categories.first.id : 'benda');
    final nameCtrl = TextEditingController();
    final phonicsCtrl = TextEditingController();
    final urlCtrl = TextEditingController();

    AliModal.showDeckModal(
      context: context,
      title: 'Tambah Kosa Kata Baru',
      subtitle: 'Foto asli objek dan nama kata untuk katalog & tebak gambar',
      isFullHeight: true,
      body: StatefulBuilder(
        builder: (modalContext, setModalState) {
          final hasImage = selectedImageBytes != null || (customUrl != null && customUrl!.trim().isNotEmpty);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Nama Kosa Kata
                const Text(
                  'Nama Benda / Kata',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: TextField(
                    controller: nameCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Pisang, Mobil, Kucing',
                      hintStyle: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setModalState(() {});
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // 2. Kategori
                const Text(
                  'Kategori Katalog',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      items: _categories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.id,
                          child: Text(
                            '${_getCategoryEmoji(c.id)}  ${c.nameId}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Ejaan / Suku Kata (Opsional)
                const Text(
                  'Ejaan / Pemisahan Suku Kata (Opsional)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: TextField(
                    controller: phonicsCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                    decoration: const InputDecoration(
                      hintText: 'Contoh: pi-sang atau mo-bil',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 4. Foto Preview & Sumber Foto
                const Text(
                  'Foto Asli Objek',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceInput,
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      border: Border.all(
                        color: hasImage ? const Color(0xFF22C55E) : AppColors.borderCard,
                        width: 1.5,
                      ),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r24),
                      child: selectedImageBytes != null
                          ? Image.memory(selectedImageBytes!, fit: BoxFit.cover)
                          : (customUrl != null && customUrl!.isNotEmpty
                              ? Image.network(
                                  customUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.broken_image_rounded, size: 36, color: Colors.grey),
                                  ),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_rounded, size: 38, color: AppColors.textMuted),
                                      SizedBox(height: 6),
                                      Text(
                                        'Belum Ada Foto',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                )),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Opsi Kamera & Galeri & Smart Search
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt_rounded, size: 17, color: AppColors.textPrimary),
                        label: const Text('Kamera', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          side: const BorderSide(color: AppColors.borderCard),
                        ),
                        onPressed: () async {
                          final bytes = await AliCameraHelper.capturePhoto(context);
                          if (bytes != null) {
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customUrl = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.photo_library_rounded, size: 17, color: AppColors.textPrimary),
                        label: const Text('Galeri', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          side: const BorderSide(color: AppColors.borderCard),
                        ),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (picked != null) {
                            final bytes = await picked.readAsBytes();
                            setModalState(() {
                              selectedImageBytes = bytes;
                              customUrl = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Text('🔍', style: TextStyle(fontSize: 14)),
                        label: const Text('Cari Web', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.pureBlack, fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentLemon,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          _openSmartImageSearchModal(
                            initialQuery: nameCtrl.text.trim(),
                            onImageSelected: (url) {
                              setModalState(() {
                                customUrl = url;
                                selectedImageBytes = null;
                                urlCtrl.text = url;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Input URL Foto Alternatif
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInput,
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.link_rounded, size: 18, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: urlCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Atau tempel link gambar (URL)...',
                            hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (v) {
                            if (v.trim().isNotEmpty) {
                              setModalState(() {
                                customUrl = v.trim();
                                selectedImageBytes = null;
                              });
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (urlCtrl.text.trim().isNotEmpty) {
                            setModalState(() {
                              customUrl = urlCtrl.text.trim();
                              selectedImageBytes = null;
                            });
                          }
                        },
                        child: const Text('Lihat', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12.5)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: AliButton(
                    label: isSaving ? 'Menyimpan & Mengunggah ke R2...' : 'Simpan ke Katalog',
                    prefixIcon: const AliIcon(Iconsax.tick_circle, size: 20),
                    variant: AliButtonVariant.electricLemon,
                    isLoading: isSaving,
                    onPressed: (nameCtrl.text.trim().isEmpty || !hasImage || isSaving)
                        ? null
                        : () async {
                            setModalState(() => isSaving = true);

                            String? finalImageUrl;

                            if (selectedImageBytes != null) {
                              final filename = 'photos/catalog_custom_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              final uploadedUrl = await R2StorageService.uploadFile(
                                bytes: selectedImageBytes!,
                                path: filename,
                                contentType: 'image/jpeg',
                              );
                              if (uploadedUrl != null) {
                                finalImageUrl = uploadedUrl;
                              }
                            } else if (customUrl != null && customUrl!.trim().isNotEmpty) {
                              // Selalu download image dari Unsplash/Web dan simpan ke Cloudflare R2 bucket terlebih dahulu!
                              final filename = 'photos/catalog_custom_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              final r2Url = await R2StorageService.uploadFileFromRemoteUrl(
                                remoteUrl: customUrl!.trim(),
                                path: filename,
                              );
                              // Jika upload berhasil simpan URL R2 permanen, fallback ke customUrl jika network R2 timeout
                              finalImageUrl = r2Url ?? customUrl!.trim();
                            }

                            if (finalImageUrl != null) {
                              final word = nameCtrl.text.trim();
                              final rawPhonics = phonicsCtrl.text.trim();
                              final syllablesList = rawPhonics.isNotEmpty
                                  ? rawPhonics.split(RegExp(r'[-•\s]+')).where((s) => s.isNotEmpty).toList()
                                  : [word];

                              final success = await SupabaseService.insertCatalogItem(
                                categoryId: selectedCategory,
                                name: word,
                                imageUrl: finalImageUrl,
                                phonics: rawPhonics.isNotEmpty ? rawPhonics : null,
                                syllables: syllablesList,
                              );

                              if (mounted) {
                                Navigator.pop(modalContext);
                                await _loadCatalog();

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success ? 'Berhasil menambahkan "$word" ke Katalog!' : 'Gagal menyimpan ke Katalog'),
                                      backgroundColor: success ? AppColors.pureBlack : Colors.red.shade700,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                }
                              }
                            } else {
                              setModalState(() => isSaving = false);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Gagal mengunggah foto. Periksa koneksi internet Anda.'),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                );
                              }
                            }
                          },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1100;
    final crossAxisCount = isDesktop ? 5 : (isTablet ? 4 : 2);
    final aspectRatio = isTablet ? 0.95 : 0.82;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.pureBlack),
                    SizedBox(height: 16),
                    Text('Memuat katalog kosa kata...'),
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Sticky Compact Header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: AliStickyHeaderDelegate(
                      height: 68.0,
                      child: AliHeaderSection(
                        title: 'Katalog Kosa Kata',
                        subtitle: '${_items.length} foto nyata benda & hewan',
                        onBackTap: () => Navigator.of(context).pop(),
                        onAddTap: _openAddCatalogItemModal,
                      ),
                    ),
                  ),

                  // 2. Sticky Search & Category Bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: AliStickyHeaderDelegate(
                      height: 98.0,
                      child: Container(
                        color: AppColors.bgCanvas,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Column(
                          children: [
                            // Search Bar
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(color: AppColors.borderCard, width: 1.0),
                                boxShadow: AppShadows.cardShadow,
                              ),
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Cari benda, hewan, makanan...',
                                  hintStyle: AppTypography.bodyMedium(color: AppColors.textMuted).copyWith(fontSize: 12.5),
                                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 18),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.close_rounded, size: 16),
                                          onPressed: () {
                                            setState(() {
                                              _searchQuery = '';
                                            });
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Category Chips Selector
                            SizedBox(
                              height: 38,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  _buildCategoryPill('all', 'Semua', '✨', count: _items.length),
                                  ..._categories.map((cat) {
                                    final count = _items.where((it) => it.categoryId == cat.id).length;
                                    return _buildCategoryPill(cat.id, cat.nameId, _getCategoryEmoji(cat.id), count: count);
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 4)),

                  // 3. Grid of Vocabulary Cards
                  _filteredItems.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 56, color: AppColors.textMuted),
                                const SizedBox(height: 12),
                                const Text(
                                  'Tidak ada kosa kata ditemukan',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            top: 4,
                            bottom: 28,
                          ),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: aspectRatio,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, idx) {
                                final item = _filteredItems[idx];
                                return AliGridCardSection(
                                  key: ValueKey('catalog_${item.id}'),
                                  title: item.name,
                                  categoryTag: _getCategoryLabel(item.categoryId),
                                  imageUrl: item.imageUrl,
                                  emoji: item.emoji,
                                  subtitle: item.phonics ?? item.syllables.join(' • '),
                                  subtitleIcon: Iconsax.volume_high,
                                  onTap: () => _speak(item),
                                  onPlaySound: () => _speak(item),
                                  onEdit: () => _openEditCatalogItemModal(item),
                                  onLongPress: () => _showItemActions(item),
                                );
                              },
                              childCount: _filteredItems.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryPill(String id, String label, String emoji, {required int count}) {
    final isSelected = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedCategoryId = id),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.pureBlack : AppColors.surfacePill,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isSelected ? AppColors.pureBlack : AppColors.borderCard,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.borderCard.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
