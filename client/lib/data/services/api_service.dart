/// PersonaPath — API Service
///
/// HTTP client that replaces FirestoreService. All data operations
/// go through the FastAPI backend with JWT auth headers.

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/env.dart';
import '../models/itinerary.dart';
import '../models/user_profile.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  String get _baseUrl => AppEnv.apiBaseUrl;

  // ─── HTTP Helpers ───

  Future<Map<String, String>> _authHeaders() async {
    final token = await TokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 401) {
      // Try refresh
      final refreshed = await refreshToken();
      if (!refreshed) {
        await TokenStorage.clearTokens();
        throw const ApiException(401, 'Session expired. Please login again.');
      }
      // Caller should retry
      throw const ApiException(401, 'Token refreshed — please retry.');
    }

    if (response.statusCode >= 400) {
      final detail = body['detail'] ?? 'Unknown error';
      throw ApiException(response.statusCode, detail.toString());
    }

    return body;
  }

  // ─── Auth ───

  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    final data = await _handleResponse(response);
    await _saveAuthData(data);
    return data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    final data = await _handleResponse(response);
    await _saveAuthData(data);
    return data;
  }

  Future<Map<String, dynamic>> googleSignIn(String firebaseIdToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': firebaseIdToken}),
    );
    final data = await _handleResponse(response);
    await _saveAuthData(data);
    return data;
  }

  Future<UserProfile> getMe() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: await _authHeaders(),
    );
    final data = await _handleResponse(response);
    return UserProfile.fromJson(data);
  }

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: await _authHeaders(),
      );
      // Ignore errors — clear local tokens regardless
      if (response.statusCode < 400) {
        await _handleResponse(response);
      }
    } catch (_) {
      // Ignore network errors on logout
    }
    await TokenStorage.clearTokens();
  }

  Future<bool> refreshToken() async {
    final refresh = await TokenStorage.getRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refresh',
        },
      );

      if (response.statusCode >= 400) return false;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccess = data['access_token'] as String?;
      if (newAccess == null) return false;

      await TokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: refresh,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<UserProfile> updateProfile(String username) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/auth/profile'),
      headers: await _authHeaders(),
      body: jsonEncode({'username': username}),
    );
    final data = await _handleResponse(response);
    return UserProfile.fromJson(data);
  }

  Future<void> deleteAccount() async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/auth/account'),
      headers: await _authHeaders(),
    );
    await _handleResponse(response);
    await TokenStorage.clearTokens();
  }

  // ─── Quiz ───

  Future<Map<String, dynamic>> saveQuiz(Map<String, dynamic> quizData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/quiz/'),
      headers: await _authHeaders(),
      body: jsonEncode(quizData),
    );
    return _handleResponse(response);
  }

  Future<List<Map<String, dynamic>>> getMyQuizzes() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/quiz/'),
      headers: await _authHeaders(),
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> deleteQuiz(int qid) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/quiz/$qid'),
      headers: await _authHeaders(),
    );
    await _handleResponse(response);
  }

  // ─── Itinerary ───

  Future<Map<String, dynamic>> saveItinerary({
    required String name,
    required String description,
    required String itineraryContent,
    int? qid,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/itinerary/'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'name': name,
        'description': description,
        'itinerary_content': itineraryContent,
        if (qid != null) 'qid': qid,
      }),
    );
    return _handleResponse(response);
  }

  Future<List<Itinerary>> getMyItineraries() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/itinerary/'),
      headers: await _authHeaders(),
    );

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, 'Failed to load itineraries');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Itinerary.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Itinerary> getItinerary(int tid) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/itinerary/$tid'),
      headers: await _authHeaders(),
    );
    final data = await _handleResponse(response);
    return Itinerary.fromJson(data);
  }

  Future<void> updateItineraryName(int tid, String name) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/itinerary/$tid'),
      headers: await _authHeaders(),
      body: jsonEncode({'name': name}),
    );
    await _handleResponse(response);
  }

  Future<void> deleteItinerary(int tid) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/itinerary/$tid'),
      headers: await _authHeaders(),
    );
    await _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/itinerary/dashboard'),
      headers: await _authHeaders(),
    );
    return _handleResponse(response);
  }

  Future<List<Map<String, dynamic>>> getAllActivity() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/itinerary/activity'),
      headers: await _authHeaders(),
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  }

  // ─── AI ───

  Future<Itinerary> generateItinerary({
    required Map<String, dynamic> answers,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/generate'),
      headers: await _authHeaders(),
      body: jsonEncode({'answers': answers}),
    );
    final data = await _handleResponse(response);

    return Itinerary(
      id: '',
      userlocalId: userId,
      title: data['title'] ?? 'My Journey',
      description: data['description'] ?? '',
      days: List<String>.from(data['days'] ?? const []),
      activities: (data['activities'] as List<dynamic>? ?? const [])
          .map((e) => ActivityItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.now(),
      quizAnswers: answers,
    );
  }

  // ─── Private Helpers ───

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await TokenStorage.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
    final user = data['user'] as Map<String, dynamic>;
    await TokenStorage.saveUserInfo(
      uid: user['uid'] as int,
      username: user['username'] as String,
      email: user['email'] as String,
    );
  }
}
