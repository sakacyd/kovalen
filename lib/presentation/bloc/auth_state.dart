abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userName;
  AuthAuthenticated(this.userName);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
