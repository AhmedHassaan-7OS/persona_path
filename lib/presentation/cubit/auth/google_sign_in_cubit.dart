import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/services/firestore_service.dart';
import 'google_sign_in_state.dart';

export 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({FirebaseAuth? auth, FirestoreService? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirestoreService(),
        super(GoogleSignInInitial());

  final FirebaseAuth _auth;
  final FirestoreService _firestore;

  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    try {
      await GoogleSignIn.instance.initialize().timeout(
            const Duration(seconds: 15),
          );
      final account = await GoogleSignIn.instance.authenticate().timeout(
            const Duration(seconds: 30),
          );
      final auth = account.authentication;
      final authz = await account.authorizationClient
          .authorizationForScopes(const ['email', 'profile']).timeout(
            const Duration(seconds: 30),
          );

      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: authz?.accessToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      final user = cred.user;
      if (user != null) {
        await user.getIdToken(true);
        await _firestore.upsertUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? _fallbackName(user.email ?? ''),
        );
      }

      if (user == null) {
        emit(GoogleSignInFailure('Sign in failed. Please try again.'));
        return;
      }
      emit(GoogleSignInSuccess(user));
    } on TimeoutException {
      emit(GoogleSignInFailure(
        'Google Sign-In timed out. Make sure you are running on a device/emulator with Google Play Services and that SHA-1 is added in Firebase.',
      ));
    } on FirebaseAuthException catch (e) {
      emit(GoogleSignInFailure(e.message ?? 'An error occurred. Please try again.'));
    } on FirebaseException catch (e) {
      emit(GoogleSignInFailure(e.message ?? 'An error occurred. Please try again.'));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('DEVELOPER_ERROR') ||
          msg.contains('Unknown calling package name') ||
          msg.contains('com.google.android.gms')) {
        emit(GoogleSignInFailure(
          'Google Sign-In failed due to Google Play Services configuration. Add SHA-1 in Firebase for com.example.persona_path and run on a Google Play emulator or a real device.',
        ));
        return;
      }
      emit(GoogleSignInFailure('An error occurred: $msg'));
    }
  }

  String _fallbackName(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return 'Traveler';
    return email.substring(0, at);
  }
}
