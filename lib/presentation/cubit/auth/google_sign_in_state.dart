import 'package:firebase_auth/firebase_auth.dart';

abstract class GoogleSignInState {}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  GoogleSignInSuccess(this.user);

  final User user;
}

class GoogleSignInFailure extends GoogleSignInState {
  GoogleSignInFailure(this.message);

  final String message;
}
