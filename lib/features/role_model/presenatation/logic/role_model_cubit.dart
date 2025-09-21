import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/role_model_entity.dart';
import '../../domain/repos/role_model_repo.dart';

part 'role_model_state.dart';

class RoleModelCubit extends Cubit<RoleModelState> {
  final RoleModelRepository repository;

  RoleModelCubit(this.repository) : super(RoleModelInitial());

  Future<void> getRoleModels() async {
    try {
      emit(RoleModelLoading());
      final roleModels = await repository.getRoleModels();
      emit(RoleModelLoaded(roleModels));
    } catch (e) {
      emit(RoleModelError("Failed to load role models: $e"));
    }
  }

  Future<void> addRoleModel(RoleModelEntity roleModel) async {
    try {
      await repository.addRoleModel(roleModel);
      await getRoleModels();
    } catch (e) {
      emit(RoleModelError("Failed to add role model: $e"));
    }
  }
}
