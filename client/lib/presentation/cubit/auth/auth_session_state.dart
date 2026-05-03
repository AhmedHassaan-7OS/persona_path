/// PersonaPath — Auth Session State

class AuthSessionState {
  final bool isAuthenticated;
  final int? uid;
  final String? username;
  final String? email;

  const AuthSessionState({
    this.isAuthenticated = false,
    this.uid,
    this.username,
    this.email,
  });

  AuthSessionState copyWith({
    bool? isAuthenticated,
    int? uid,
    String? username,
    String? email,
  }) {
    return AuthSessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  String get displayName {
    if (username != null && username!.isNotEmpty) return username!;
    if (email != null && email!.isNotEmpty) return email!.split('@').first;
    return 'Traveler';
  }
}
