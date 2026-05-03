/// PersonaPath — Google Sign In Cubit
///
/// Uses Firebase Auth ONLY for Google OAuth, then sends the Firebase ID token
/// to the PersonaPath server to create/find the user in PostgreSQL and get
/// a server JWT.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/services/api_service.dart';
import 'google_sign_in_state.dart';

export 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({FirebaseAuth? auth, ApiService? api})
      : _auth = auth ?? FirebaseAuth.instance,
        _api = api ?? ApiService(),
        super(GoogleSignInInitial());

  final FirebaseAuth _auth;
  final ApiService _api;

  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    try {
      // Step 1: Google OAuth via Firebase Auth
      User? firebaseUser;

      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final cred = await _auth.signInWithPopup(provider);
        firebaseUser = cred.user;
      } else {
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
        firebaseUser = cred.user;
      }

      if (firebaseUser == null) {
        emit(GoogleSignInFailure('Google sign-in failed. Please try again.'));
        return;
      }

      // Step 2: Get Firebase ID token
      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null) {
        emit(GoogleSignInFailure('Could not get authentication token.'));
        return;
      }

      // Step 3: Send to PersonaPath server → get server JWT
      final data = await _api.googleSignIn(idToken);
      final user = data['user'] as Map<String, dynamic>;

      // Step 4: Sign out of Firebase (we only used it for the OAuth flow)
      await _auth.signOut();

      emit(GoogleSignInSuccess(
        uid: user['uid'] as int,
        username: user['username'] as String,
        email: user['email'] as String,
      ));
    } on TimeoutException {
      emit(GoogleSignInFailure(
        'Google Sign-In timed out. Check your connection and try again.',
      ));
    } on ApiException catch (e) {
      emit(GoogleSignInFailure(e.message));
    } on FirebaseAuthException catch (e) {
      emit(GoogleSignInFailure(e.message ?? 'An error occurred. Please try again.'));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('DEVELOPER_ERROR') ||
          msg.contains('Unknown calling package name') ||
          msg.contains('com.google.android.gms')) {
        emit(GoogleSignInFailure(
          'Google Sign-In configuration error. Add SHA-1 in Firebase.',
        ));
        return;
      }
      emit(GoogleSignInFailure('An error occurred: $msg'));
    }
  }
}
