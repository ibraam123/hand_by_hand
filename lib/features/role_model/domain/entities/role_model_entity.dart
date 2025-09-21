// lib/features/role_models/domain/entities/role_model_entity.dart
import 'package:equatable/equatable.dart';

class RoleModelEntity extends Equatable {
  final String id;
  final String name;
  final String story;
  final String imageUrl;

  const RoleModelEntity({
    required this.id,
    required this.name,
    required this.story,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, story, imageUrl];
}
