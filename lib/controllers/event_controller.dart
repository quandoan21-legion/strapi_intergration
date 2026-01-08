import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../models/category.dart';
import '../models/event.dart';
import '../services/strapi_api_client.dart';

class EventController extends ChangeNotifier {
  EventController(this._apiClient);

  final StrapiApiClient _apiClient;

  final List<Event> _events = <Event>[];
  final List<Category> _categories = <Category>[];
  bool _isInitialLoading = false;
  bool _isRefreshing = false;
  bool _isPaginating = false;
  bool _hasMore = true;
  int _currentPage = 1;
  int? _selectedCategoryId;
  String? _errorMessage;
  bool _initialized = false;

  List<Event> get events => List.unmodifiable(_events);
  List<Category> get categories => List.unmodifiable(_categories);
  bool get isInitialLoading => _isInitialLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isPaginating => _isPaginating;
  bool get hasMore => _hasMore;
  int? get selectedCategoryId => _selectedCategoryId;
  String? get errorMessage => _errorMessage;
  bool get isEmpty =>
      !_isInitialLoading &&
      !_isRefreshing &&
      _events.isEmpty &&
      _errorMessage == null;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isInitialLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _fetchCategories();
      await _fetchEvents(reset: true);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _fetchEvents(reset: true);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isInitialLoading || _isPaginating || !_hasMore) return;
    await _fetchEvents(reset: false);
  }

  Future<void> selectCategory(int? categoryId) async {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _isRefreshing = true;
    notifyListeners();
    try {
      await _fetchEvents(reset: true);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final fetched = await _apiClient.fetchCategories();
      _categories
        ..clear()
        ..addAll(fetched);
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    }
  }

  Future<void> _fetchEvents({required bool reset}) async {
    if (!reset) {
      if (_isPaginating || !_hasMore) return;
      _isPaginating = true;
      notifyListeners();
    } else {
      _currentPage = 1;
      _hasMore = true;
    }

    try {
      final response = await _apiClient.fetchEvents(
        page: _currentPage,
        categoryId: _selectedCategoryId,
      );
      if (reset) {
        _events
          ..clear()
          ..addAll(response.items);
      } else {
        _events.addAll(response.items);
      }
      _hasMore = response.meta.hasNextPage;
      _currentPage = response.meta.page + (_hasMore ? 1 : 0);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
      if (reset) {
        rethrow;
      }
    } finally {
      if (!reset) {
        _isPaginating = false;
        notifyListeners();
      }
    }

    if (reset) {
      notifyListeners();
    }
  }
}
