import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  /// Base URL of the PersonaPath API server
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api/v1';

  /// AI endpoint — kept for backward compat but AI now runs server-side
  static String get aiEndpoint => dotenv.env['AI_ENDPOINT'] ?? '';
  static String get aiApiKey => dotenv.env['AI_API_KEY'] ?? '';
  static String get aiAuthToken => dotenv.env['AI_AUTH_TOKEN'] ?? '';

  static Uri? get aiUri {
    final endpoint = aiEndpoint.trim();
    if (endpoint.isEmpty) return null;

    final base = Uri.parse(endpoint);
    final key = aiApiKey.trim();
    if (key.isEmpty) return base;

    if (base.queryParameters.containsKey('key')) {
      return base;
    }

    return base.replace(
      queryParameters: <String, String>{
        ...base.queryParameters,
        'key': key,
      },
    );
  }
}
