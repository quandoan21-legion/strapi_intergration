import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/pagination.dart';

class StrapiApiClient {
  StrapiApiClient({http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  final http.Client _client;
  final int defaultPageSize = 10;

  Future<ApiListResponse<Event>> fetchEvents({
    int page = 1,
    int? categoryId,
    int? pageSize,
  }) async {
    final params = <String, String>{
      'pagination[page]': '$page',
      'pagination[pageSize]': '${pageSize ?? defaultPageSize}',
      'populate[cover]': '*',
      'populate[category]': '*',
      'sort[0]': 'startDate:asc',
    };
    if (categoryId != null) {
      params['filters[category][id][\$eq]'] = '$categoryId';
    }
    final uri = Uri.parse(
      ApiConfig.eventsEndpoint,
    ).replace(queryParameters: params);
    final response = await _client.get(uri);
    _throwIfNecessary(response);
    final decoded = _decode(response);
    return ApiListResponse<Event>.fromJson(
      decoded,
      (item) => Event.fromJson(item),
    );
  }

  Future<List<Category>> fetchCategories() async {
    final params = <String, String>{'sort[0]': 'name:asc'};
    final uri = Uri.parse(
      ApiConfig.categoriesEndpoint,
    ).replace(queryParameters: params);
    final response = await _client.get(uri);
    _throwIfNecessary(response);
    final decoded = _decode(response);
    final data = (decoded['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<dynamic>();
    return data
        .whereType<Map<String, dynamic>>()
        .map(Category.fromJson)
        .toList(growable: false);
  }

  Future<void> submitRegistration({
    required String fullName,
    required String email,
    required String phone,
    String? notes,
    int? eventId,
  }) async {
    final payload = {
      'data': {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'notes': notes,
        if (eventId != null) 'event': eventId,
        'source': 'mobile-app',
      },
    };
    final uri = Uri.parse(ApiConfig.registrationsEndpoint);
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    _throwIfNecessary(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    return (jsonDecode(response.body) as Map<String, dynamic>?) ??
        <String, dynamic>{};
  }

  void _throwIfNecessary(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw StrapiException(
      message: 'Strapi request failed (${response.statusCode})',
      statusCode: response.statusCode,
    );
  }

  void dispose() {
    _client.close();
  }
}

class StrapiException implements Exception {
  StrapiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
