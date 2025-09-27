part of 'auth_cubit.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  final AuthAction? action;
  const AuthLoading({this.action});
}

final class AuthSuccess extends AuthState {
  final UserModel? user;
  const AuthSuccess({this.user});
}

final class AuthError extends AuthState {
  final String errorMessage;
  const AuthError(this.errorMessage);
}

final class AuthLogout extends AuthState {}


enum AuthAction { email, google, signup, logout, forgotPassword }



final class RememberMe extends AuthState {
  final bool isSelected;
  const RememberMe({required this.isSelected});
}

final class ForgotPasswordLoading extends AuthState {

}

final class ForgotPasswordSuccess extends AuthState {

}

final class ForgotPasswordError extends AuthState {
  final String errorMessage;
  const ForgotPasswordError(this.errorMessage);
}



