// Model Kartu Kosa Kata AAC Ali
class VocabCardModel {
  final String id;
  final String categoryId;
  final String label;
  final String imageUrl;
  final String? audioAbiUrl;
  final String? audioUmmaUrl;
  final bool isFavorite;
  final String createdBy;
  final int sortOrder;
  final DateTime createdAt;
  final String? userId;
  final bool isSystem;
  final String? originalCardId;
  final bool isDeleted;

  const VocabCardModel({
    required this.id,
    required this.categoryId,
    required this.label,
    required this.imageUrl,
    this.audioAbiUrl,
    this.audioUmmaUrl,
    this.isFavorite = false,
    this.createdBy = 'abi',
    this.sortOrder = 0,
    required this.createdAt,
    this.userId,
    this.isSystem = false,
    this.originalCardId,
    this.isDeleted = false,
  });

  // Getter fallback backward compatibility
  String? get audioUrl => audioAbiUrl ?? audioUmmaUrl;

  /// Ambil label sumber suara secara dinamis:
  /// - Ada suara ayah & ibu -> 'Suara [Ayah] & [Ibu]'
  /// - Ada suara ayah saja -> 'Suara [Ayah]'
  /// - Ada suara ibu saja -> 'Suara [Ibu]'
  /// - Tidak ada rekaman -> 'Suara Sistem'
  String getVoiceLabel({required String fatherCall, required String motherCall}) {
    final hasFather = audioAbiUrl != null && audioAbiUrl!.trim().isNotEmpty;
    final hasMother = audioUmmaUrl != null && audioUmmaUrl!.trim().isNotEmpty;

    if (hasFather && hasMother) {
      return 'Suara $fatherCall & $motherCall';
    } else if (hasFather) {
      return 'Suara $fatherCall';
    } else if (hasMother) {
      return 'Suara $motherCall';
    } else {
      return 'Suara Sistem';
    }
  }

  factory VocabCardModel.fromJson(Map<String, dynamic> json) {
    String? origCardId = json['original_card_id']?.toString();
    if (origCardId == null || origCardId.isEmpty) {
      final cb = json['created_by']?.toString() ?? '';
      if (cb.startsWith('override:')) {
        origCardId = cb.substring('override:'.length);
      }
    }

    return VocabCardModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      audioAbiUrl: json['audio_abi_url']?.toString() ?? json['audio_url']?.toString(),
      audioUmmaUrl: json['audio_umma_url']?.toString(),
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
      createdBy: json['created_by']?.toString() ?? 'abi',
      sortOrder: json['sort_order'] is int
          ? json['sort_order'] as int
          : int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      userId: json['user_id']?.toString(),
      isSystem: json['is_system'] == true || json['is_system'] == 1,
      originalCardId: origCardId,
      isDeleted: json['is_deleted'] == true || json['is_deleted'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'label': label,
      'image_url': imageUrl,
      'audio_abi_url': audioAbiUrl,
      'audio_umma_url': audioUmmaUrl,
      'is_favorite': isFavorite,
      'created_by': originalCardId != null && originalCardId!.isNotEmpty
          ? 'override:$originalCardId'
          : createdBy,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      if (userId != null) 'user_id': userId,
      'is_system': isSystem,
      if (originalCardId != null) 'original_card_id': originalCardId,
      'is_deleted': isDeleted,
    };
  }

  VocabCardModel copyWith({
    String? id,
    String? categoryId,
    String? label,
    String? imageUrl,
    String? audioAbiUrl,
    String? audioUmmaUrl,
    bool? isFavorite,
    String? createdBy,
    int? sortOrder,
    DateTime? createdAt,
    String? userId,
    bool? isSystem,
    String? originalCardId,
    bool? isDeleted,
  }) {
    return VocabCardModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      label: label ?? this.label,
      imageUrl: imageUrl ?? this.imageUrl,
      audioAbiUrl: audioAbiUrl ?? this.audioAbiUrl,
      audioUmmaUrl: audioUmmaUrl ?? this.audioUmmaUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      createdBy: createdBy ?? this.createdBy,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      isSystem: isSystem ?? this.isSystem,
      originalCardId: originalCardId ?? this.originalCardId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// 10 Kartu AAC Default Inti Esensial Ramah Anak Indonesia (Foto Nyata CDN R2)
  static List<VocabCardModel> get defaultSystemCards => [
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000001',
      categoryId: 'a0000001-0000-0000-0000-000000000002',
      label: 'Main',
      imageUrl: 'https://ali.medixo.id/default_aac/main.jpg',
      sortOrder: 1,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000002',
      categoryId: 'a0000001-0000-0000-0000-000000000002',
      label: 'Mandi',
      imageUrl: 'https://ali.medixo.id/default_aac/mandi.jpg',
      sortOrder: 2,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000003',
      categoryId: 'a0000001-0000-0000-0000-000000000002',
      label: 'Tidur',
      imageUrl: 'https://ali.medixo.id/default_aac/tidur.jpg',
      sortOrder: 3,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000004',
      categoryId: 'a0000001-0000-0000-0000-000000000002',
      label: 'Belajar',
      imageUrl: 'https://ali.medixo.id/default_aac/belajar.jpg',
      sortOrder: 4,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000005',
      categoryId: 'a0000001-0000-0000-0000-000000000002',
      label: 'Jalan-jalan',
      imageUrl: 'https://ali.medixo.id/default_aac/jalan_jalan.jpg',
      sortOrder: 5,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000006',
      categoryId: 'a0000001-0000-0000-0000-000000000005',
      label: 'Tolong',
      imageUrl: 'https://ali.medixo.id/default_aac/tolong.jpg',
      sortOrder: 6,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000007',
      categoryId: 'a0000001-0000-0000-0000-000000000005',
      label: 'Buka',
      imageUrl: 'https://ali.medixo.id/default_aac/buka.jpg',
      sortOrder: 7,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000008',
      categoryId: 'a0000001-0000-0000-0000-000000000005',
      label: 'Selesai',
      imageUrl: 'https://ali.medixo.id/default_aac/selesai.jpg',
      sortOrder: 8,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000009',
      categoryId: 'a0000001-0000-0000-0000-000000000004',
      label: 'Senang',
      imageUrl: 'https://ali.medixo.id/default_aac/senang.jpg',
      sortOrder: 9,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
    VocabCardModel(
      id: 'b0000001-0000-0000-0000-000000000010',
      categoryId: 'a0000001-0000-0000-0000-000000000004',
      label: 'Takut',
      imageUrl: 'https://ali.medixo.id/default_aac/takut.jpg',
      sortOrder: 10,
      isSystem: true,
      createdBy: 'system',
      createdAt: DateTime(2026, 1, 1),
    ),
  ];
}
