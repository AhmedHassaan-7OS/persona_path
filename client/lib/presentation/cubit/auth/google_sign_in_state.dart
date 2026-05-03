/// PersonaPath — Google Sign In States

abstract class GoogleSignInState {}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  final int uid;
  final String username;
  final String email;
  GoogleSignInSuccess({required this.uid, required this.username, required this.email});
}

class GoogleSignInFailure extends GoogleSignInState {
  final String message;
  GoogleSignInFailure(this.message);
}
