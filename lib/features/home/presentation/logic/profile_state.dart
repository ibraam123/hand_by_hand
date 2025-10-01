part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final String firstName;
  final String lastName;
  final String? email;
  ProfileLoaded(this.firstName, this.lastName , this.email);
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

final class ProfileEdit extends ProfileState {
  final String firstName;
  final String lastName;
  ProfileEdit(this.firstName, this.lastName);
}

