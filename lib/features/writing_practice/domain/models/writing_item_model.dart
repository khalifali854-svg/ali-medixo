class WritingItemModel {
  final String id;
  final int levelType; // 1: Angka, 2: Huruf Besar, 3: Huruf Kecil, 4: Kata Pendek, 5: Kosa Kata AAC
  final String targetText;
  final String? hintLabel;
  final String? imageUrl;
  final String? audioUrl;
  final bool isCustom;
  final String createdBy;
  final int sortOrder;
  final DateTime createdAt;

  const WritingItemModel({
    required this.id,
    required this.levelType,
    required this.targetText,
    this.hintLabel,
    this.imageUrl,
    this.audioUrl,
    this.isCustom = false,
    this.createdBy = 'abi',
    this.sortOrder = 0,
    required this.createdAt,
  });

  factory WritingItemModel.fromJson(Map<String, dynamic> json) {
    return WritingItemModel(
      id: json['id']?.toString() ?? '',
      levelType: json['level_type'] is int ? json['level_type'] : int.tryParse(json['level_type']?.toString() ?? '1') ?? 1,
      targetText: json['target_text']?.toString() ?? '',
      hintLabel: json['hint_label']?.toString(),
      imageUrl: json['image_url']?.toString(),
      audioUrl: json['audio_url']?.toString(),
      isCustom: json['is_custom'] == true || json['is_custom'] == 1,
      createdBy: json['created_by']?.toString() ?? 'abi',
      sortOrder: json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level_type': levelType,
      'target_text': targetText,
      'hint_label': hintLabel,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'is_custom': isCustom,
      'created_by': createdBy,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }

  WritingItemModel copyWith({
    String? id,
    int? levelType,
    String? targetText,
    String? hintLabel,
    String? imageUrl,
    String? audioUrl,
    bool? isCustom,
    String? createdBy,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return WritingItemModel(
      id: id ?? this.id,
      levelType: levelType ?? this.levelType,
      targetText: targetText ?? this.targetText,
      hintLabel: hintLabel ?? this.hintLabel,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isCustom: isCustom ?? this.isCustom,
      createdBy: createdBy ?? this.createdBy,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
