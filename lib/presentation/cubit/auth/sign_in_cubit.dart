import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/firestore_service.dart';
import 'sign_in_state.dart';

export 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({FirebaseAuth? auth, FirestoreService? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirestoreService(),
        super(SignInInitial());

  final FirebaseAuth _auth;
  final FirestoreService _firestore;

  Future<void> signInWithEmail(String email, String password) async {
    emit(SignInLoading());
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await user.getIdToken(true);
        await _firestore.upsertUser(
          uid: user.uid,
          email: user.email ?? email,
          displayName: user.displayName ?? _fallbackName(user.email ?? email),
        );
      }
      if (user == null) {
        emit(SignInFailure('Sign in failed. Please try again.'));
        return;
      }
      emit(SignInSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(SignInFailure(e.message ?? 'An error occurred. Please try again.'));
    } on FirebaseException catch (e) {
      emit(SignInFailure(e.message ?? 'An error occurred. Please try again.'));
    } catch (e) {
      emit(SignInFailure('An error occurred: $e'));
    }
  }

  String _fallbackName(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return 'Traveler';
    return email.substring(0, at);
  }
}
