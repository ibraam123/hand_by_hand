// lib/features/role_models/data/datasources/role_model_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/role_model.dart';

abstract class RoleModelRemoteDataSource {
  Future<List<RoleModel>> fetchRoleModels();
  Future<void> createRoleModel(RoleModel roleModel);
}

class RoleModelRemoteDataSourceImpl implements RoleModelRemoteDataSource {
  final FirebaseFirestore firestore;

  RoleModelRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<RoleModel>> fetchRoleModels() async {
    final snapshot = await firestore.collection('role_models').get();
    return snapshot.docs
        .map((doc) => RoleModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> createRoleModel(RoleModel roleModel) async {
    await firestore.collection('role_models').add(roleModel.toJson());
  }
}
