import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  SignInSuccess(this.user);

  final User user;
}

class SignInFailure extends SignInState {
  SignInFailure(this.message);

  final String message;
}
