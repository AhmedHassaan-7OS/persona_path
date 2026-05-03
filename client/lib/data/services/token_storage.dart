/// PersonaPath — Token Storage
///
/// Secure local storage for JWT access/refresh tokens and basic user info
/// using shared_preferences.

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _accessTokenKey = 'pp_access_token';
  static const _refreshTokenKey = 'pp_refresh_token';
  static const _uidKey = 'pp_user_uid';
  static const _usernameKey = 'pp_user_username';
  static const _emailKey = 'pp_user_email';

  // ─── Token Operations ───

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_uidKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
  }

  // ─── User Info Cache ───

  static Future<void> saveUserInfo({
    required int uid,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_uidKey, uid);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
  }

  static Future<int?> getUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_uidKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
