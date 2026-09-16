class CatalogCategoryModel {
  final String id;
  final String nameId;
  final String? nameEn;
  final String? iconName;
  final String? colorHex;
  final int sortOrder;

  const CatalogCategoryModel({
    required this.id,
    required this.nameId,
    this.nameEn,
    this.iconName,
    this.colorHex,
    this.sortOrder = 0,
  });

  factory CatalogCategoryModel.fromJson(Map<String, dynamic> json) {
    return CatalogCategoryModel(
      id: json['id'] as String,
      nameId: json['name_id'] as String? ?? json['name'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_id': nameId,
      'name_en': nameEn,
      'icon_name': iconName,
      'color_hex': colorHex,
      'sort_order': sortOrder,
    };
  }
}
