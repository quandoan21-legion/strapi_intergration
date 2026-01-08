class PaginationMeta {
  PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  bool get hasNextPage => page < pageCount;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      pageCount: json['pageCount'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
    );
  }
}

class ApiListResponse<T> {
  ApiListResponse({required this.items, required this.meta});

  final List<T> items;
  final PaginationMeta meta;

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> map) mapItem,
  ) {
    final rawItems = (json['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<dynamic>();
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(mapItem)
        .toList(growable: false);
    final pagination = PaginationMeta.fromJson(
      (json['meta'] as Map<String, dynamic>?)?['pagination']
              as Map<String, dynamic>? ??
          <String, dynamic>{},
    );
    return ApiListResponse<T>(items: items, meta: pagination);
  }
}
