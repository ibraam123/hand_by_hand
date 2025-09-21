// lib/features/role_models/domain/repositories/role_model_repository.dart
import '../entities/role_model_entity.dart';

abstract class RoleModelRepository {
  Future<List<RoleModelEntity>> getRoleModels();
  Future<void> addRoleModel(RoleModelEntity roleModel);
}
