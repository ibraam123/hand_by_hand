// lib/features/role_models/data/models/role_model.dart
import '../../domain/entities/role_model_entity.dart';

class RoleModel extends RoleModelEntity {
  const RoleModel({
    required super.id,
    required super.name,
    required super.story,
    required super.imageUrl,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json, String docId) {
    return RoleModel(
      id: docId,
      name: json['name'] ?? '',
      story: json['story'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'story': story,
      'image_url': imageUrl,
    };
  }
}
