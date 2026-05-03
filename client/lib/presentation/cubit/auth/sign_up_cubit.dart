/// PersonaPath — Sign Up Cubit
///
/// Handles email/password registration via the server API.
/// No longer uses Firebase Auth for registration.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/api_service.dart';
import 'sign_up_state.dart';

export 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({ApiService? api})
      : _api = api ?? ApiService(),
        super(SignUpInitial());

  final ApiService _api;

  Future<void> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    emit(SignUpLoading());
    try {
      final data = await _api.signup(
        username: displayName.isNotEmpty ? displayName : email.split('@').first,
        email: email,
        password: password,
      );
      final user = data['user'] as Map<String, dynamic>;
      emit(SignUpSuccess(
        uid: user['uid'] as int,
        username: user['username'] as String,
        email: user['email'] as String,
      ));
    } on ApiException catch (e) {
      emit(SignUpFailure(e.message));
    } catch (e) {
      emit(SignUpFailure('An error occurred: $e'));
    }
  }
}
