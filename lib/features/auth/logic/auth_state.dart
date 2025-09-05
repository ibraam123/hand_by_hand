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

class RememberMe extends AuthState {
  final bool isSelected;
  const RememberMe({required this.isSelected});
}

class ForgotPasswordLoading extends AuthState {

}

class ForgotPasswordSuccess extends AuthState {

}

class ForgotPasswordError extends AuthState {
  final String errorMessage;
  const ForgotPasswordError(this.errorMessage);
}

