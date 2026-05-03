/// PersonaPath — Auth Session Cubit
///
/// Manages the user's authentication session. On startup, checks
/// for stored JWT tokens. No longer depends on Firebase Auth streams.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/api_service.dart';
import '../../../data/services/token_storage.dart';
import 'auth_session_state.dart';

export 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(const AuthSessionState()) {
    _checkSession();
  }

  final ApiService _api;

  /// Check for existing JWT session on startup
  Future<void> _checkSession() async {
    final hasSession = await TokenStorage.hasValidSession();
    if (!hasSession) return;

    final uid = await TokenStorage.getUserUid();
    final username = await TokenStorage.getUsername();
    final email = await TokenStorage.getEmail();

    if (uid != null) {
      emit(AuthSessionState(
        isAuthenticated: true,
        uid: uid,
        username: username,
        email: email,
      ));
    }
  }

  /// Called after successful login/signup to update session state
  void setAuthenticated({
    required int uid,
    required String username,
    required String email,
  }) {
    emit(AuthSessionState(
      isAuthenticated: true,
      uid: uid,
      username: username,
      email: email,
    ));
  }

  /// Sign out — clears server token + local storage
  Future<void> signOut() async {
    await _api.logout();
    await TokenStorage.clearTokens();
    emit(const AuthSessionState());
  }
}
