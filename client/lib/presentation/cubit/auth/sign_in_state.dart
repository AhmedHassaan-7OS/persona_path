/// PersonaPath — Sign In States

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final int uid;
  final String username;
  final String email;
  SignInSuccess({required this.uid, required this.username, required this.email});
}

class SignInFailure extends SignInState {
  final String message;
  SignInFailure(this.message);
}
