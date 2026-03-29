import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  SignUpSuccess(this.user);

  final User user;
}

class SignUpFailure extends SignUpState {
  SignUpFailure(this.message);

  final String message;
}
