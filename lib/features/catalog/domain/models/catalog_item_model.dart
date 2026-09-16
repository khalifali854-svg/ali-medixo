import 'dart:convert';

class CatalogItemModel {
  final String id;
  final String categoryId;
  final String name;
  final String imageUrl;
  final String? phonics;
  final List<String> syllables;
  final String? emoji;
  final String? audioUrl;
  final int difficulty;
  final bool isActive;

  const CatalogItemModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imageUrl,
    this.phonics,
    this.syllables = const [],
    this.emoji,
    this.audioUrl,
    this.difficulty = 1,
    this.isActive = true,
  });

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedSyllables = [];
    if (json['syllables'] is List) {
      parsedSyllables = (json['syllables'] as List).map((e) => e.toString()).toList();
    } else if (json['syllables'] is String) {
      try {
        final decoded = jsonDecode(json['syllables'] as String);
        if (decoded is List) {
          parsedSyllables = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }

    return CatalogItemModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      phonics: json['phonics'] as String?,
      syllables: parsedSyllables,
      emoji: json['emoji'] as String?,
      audioUrl: json['audio_url'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'image_url': imageUrl,
      'phonics': phonics,
      'syllables': syllables,
      'emoji': emoji,
      'audio_url': audioUrl,
      'difficulty': difficulty,
      'is_active': isActive ? 1 : 0,
    };
  }

  CatalogItemModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? imageUrl,
    String? phonics,
    List<String>? syllables,
    String? emoji,
    String? audioUrl,
    int? difficulty,
    bool? isActive,
  }) {
    return CatalogItemModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      phonics: phonics ?? this.phonics,
      syllables: syllables ?? this.syllables,
      emoji: emoji ?? this.emoji,
      audioUrl: audioUrl ?? this.audioUrl,
      difficulty: difficulty ?? this.difficulty,
      isActive: isActive ?? this.isActive,
    );
  }
}
