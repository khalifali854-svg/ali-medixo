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
}
