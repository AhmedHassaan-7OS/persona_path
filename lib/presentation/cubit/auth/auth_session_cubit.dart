import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_session_state.dart';

export 'auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(const AuthSessionState()) {
    _sub = _auth.authStateChanges().listen((user) {
      emit(state.copyWith(user: user));
    });
  }

  final FirebaseAuth _auth;
  StreamSubscription<User?>? _sub;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
