/// PersonaPath — Sign In Cubit
///
/// Handles email/password login via the server API.
/// No longer uses Firebase Auth for email sign-in.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/api_service.dart';
import 'sign_in_state.dart';

export 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(SignInInitial());

  final ApiService _api;

  Future<void> signInWithEmail(String email, String password) async {
    emit(SignInLoading());
    try {
      final data = await _api.login(email: email, password: password);
      final user = data['user'] as Map<String, dynamic>;
      emit(SignInSuccess(
        uid: user['uid'] as int,
        username: user['username'] as String,
        email: user['email'] as String,
      ));
    } on ApiException catch (e) {
      emit(SignInFailure(e.message));
    } catch (e) {
      emit(SignInFailure('An error occurred: $e'));
    }
  }
}
