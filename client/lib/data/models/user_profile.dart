/// PersonaPath — User Profile Model
///
/// Represents the authenticated user's profile data from the server.

class UserProfile {
  final int uid;
  final String username;
  final String email;
  final String authProvider;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    required this.authProvider,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as int,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      authProvider: json['auth_provider'] as String? ?? 'email',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  /// Legacy factory for backward compat with existing quiz result screen
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as int? ?? 0,
      username: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      authProvider: map['auth_provider'] as String? ?? 'email',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  String get displayName => username.isNotEmpty ? username : email.split('@').first;
}
