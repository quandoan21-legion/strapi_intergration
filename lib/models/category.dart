class Category {
  const Category({required this.id, required this.name, required this.slug});

  final int id;
  final String name;
  final String slug;

  static const Category allCategory = Category(
    id: -1,
    name: 'Tất cả',
    slug: 'all',
  );

  factory Category.fromJson(Map<String, dynamic> json) {
    final attributes =
        (json['attributes'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return Category(
      id: json['id'] as int? ?? -1,
      name: attributes['name'] as String? ?? '',
      slug: attributes['slug'] as String? ?? '',
    );
  }

  static Category? fromRelation(Map<String, dynamic>? relation) {
    if (relation == null) {
      return null;
    }
    if (relation['data'] != null) {
      return Category.fromJson(relation['data'] as Map<String, dynamic>);
    }
    if (relation['id'] != null) {
      return Category.fromJson(relation);
    }
    return null;
  }
}
