import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/firestore_service.dart';
import 'sign_up_state.dart';

export 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({FirebaseAuth? auth, FirestoreService? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirestoreService(),
        super(SignUpInitial());

  final FirebaseAuth _auth;
  final FirestoreService _firestore;

  Future<void> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    emit(SignUpLoading());
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.getIdToken(true);
      await _firestore.upsertUser(
        uid: cred.user!.uid,
        email: email,
        displayName: displayName.isNotEmpty ? displayName : _fallbackName(email),
      );
      final user = cred.user;
      if (user == null) {
        emit(SignUpFailure('Sign up failed. Please try again.'));
        return;
      }
      emit(SignUpSuccess(user));
    } on FirebaseAuthException catch (e) {
      emit(SignUpFailure(e.message ?? 'An error occurred. Please try again.'));
    } on FirebaseException catch (e) {
      emit(SignUpFailure(e.message ?? 'Could not save user to Firestore.'));
    } catch (e) {
      emit(SignUpFailure('An error occurred: $e'));
    }
  }

  String _fallbackName(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return 'Traveler';
    return email.substring(0, at);
  }
}
