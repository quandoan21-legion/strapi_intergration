class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'STRAPI_BASE_URL',
    defaultValue: 'http://localhost:1337',
  );

  static String get apiBaseUrl => '$baseUrl/api';
  static String get eventsEndpoint => '$apiBaseUrl/events';
  static String get categoriesEndpoint => '$apiBaseUrl/categories';
  static String get registrationsEndpoint => '$apiBaseUrl/registrations';

  static String resolveMediaUrl(String? url) {
    if (url == null || url.isEmpty) {
      return '';
    }
    if (url.startsWith('http')) {
      return url;
    }
    return '$baseUrl$url';
  }
}
