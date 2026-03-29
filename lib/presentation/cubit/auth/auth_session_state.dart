import 'package:firebase_auth/firebase_auth.dart';

class AuthSessionState {
  final User? user;

  const AuthSessionState({this.user});

  AuthSessionState copyWith({User? user}) {
    return AuthSessionState(user: user ?? this.user);
  }
}
