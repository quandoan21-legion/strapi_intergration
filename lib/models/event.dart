import 'category.dart';

class Event {
  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.location,
    this.coverUrl,
    this.category,
  });

  final int id;
  final String title;
  final String description;
  final DateTime? startDate;
  final String? location;
  final String? coverUrl;
  final Category? category;

  factory Event.fromJson(Map<String, dynamic> json) {
    final attributes =
        (json['attributes'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final coverData =
        (attributes['cover'] as Map<String, dynamic>?)?['data']
            as Map<String, dynamic>? ??
        <String, dynamic>{};
    final coverAttributes =
        (coverData['attributes'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final category = Category.fromRelation(
      attributes['category'] as Map<String, dynamic>?,
    );

    return Event(
      id: json['id'] as int? ?? -1,
      title: attributes['title'] as String? ?? 'Unnamed Event',
      description: attributes['description'] as String? ?? '',
      startDate: attributes['startDate'] != null
          ? DateTime.tryParse(attributes['startDate'] as String)
          : null,
      location: attributes['location'] as String?,
      coverUrl: coverAttributes['url'] as String?,
      category: category,
    );
  }
}
