// lib/features/role_models/data/repositories/role_model_repository_impl.dart
import '../../domain/entities/role_model_entity.dart';
import '../../domain/repos/role_model_repo.dart';
import '../data_sources/role_model_remote_data_source.dart';
import '../models/role_model.dart';

class RoleModelRepositoryImpl implements RoleModelRepository {
  final RoleModelRemoteDataSource remoteDataSource;

  RoleModelRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RoleModelEntity>> getRoleModels() async {
    final models = await remoteDataSource.fetchRoleModels();
    return models;
  }

  @override
  Future<void> addRoleModel(RoleModelEntity roleModel) async {
    final model = RoleModel(
      id: roleModel.id,
      name: roleModel.name,
      story: roleModel.story,
      imageUrl: roleModel.imageUrl,
    );
    await remoteDataSource.createRoleModel(model);
  }
}
