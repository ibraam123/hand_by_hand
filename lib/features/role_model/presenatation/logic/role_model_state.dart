part of 'role_model_cubit.dart';

@immutable
sealed class RoleModelState {}

final class RoleModelInitial extends RoleModelState {}

final class RoleModelLoading extends RoleModelState {}

final class RoleModelLoaded extends RoleModelState {
  final List<RoleModelEntity> roleModels;
  RoleModelLoaded(this.roleModels);
}

final class RoleModelError extends RoleModelState {
  final String message;
  RoleModelError(this.message);
}
