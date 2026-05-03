/// PersonaPath — Sign Up States

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final int uid;
  final String username;
  final String email;
  SignUpSuccess({required this.uid, required this.username, required this.email});
}

class SignUpFailure extends SignUpState {
  final String message;
  SignUpFailure(this.message);
}
