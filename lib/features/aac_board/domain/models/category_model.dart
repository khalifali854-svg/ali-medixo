class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String? ?? 'grid_1',
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon_name': iconName,
    'sort_order': sortOrder,
  };
}
