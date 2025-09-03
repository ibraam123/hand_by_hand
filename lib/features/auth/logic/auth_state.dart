part of 'auth_cubit.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel? user;
  const AuthSuccess({this.user});
}

final class AuthError extends AuthState {
  final String errorMessage;
  const AuthError(this.errorMessage);
}
