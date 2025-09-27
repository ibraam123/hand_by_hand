// models/place_model.dart

import 'package:hand_by_hand/features/accessible_places/domain/entities/place_entitiy.dart';

class PlaceModel extends PlaceEntitiy {
  PlaceModel({
    required super.name,
    required super.lat,
    required super.lng,
    required super.type,
  });

  factory PlaceModel.fromFirestore(Map<String, dynamic> data) {
    return PlaceModel(
      name: data['name'] ?? '',
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      type: data['type'] ?? '',
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
      'type': type,
    };
  }
}
