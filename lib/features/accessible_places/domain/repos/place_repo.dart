// repositories/place_repository.dart
import 'package:hand_by_hand/features/accessible_places/data/models/place_model.dart';
import 'package:hand_by_hand/features/accessible_places/domain/entities/place_entitiy.dart';

abstract class PlaceRepository {
  Future<List<PlaceEntitiy>> getPlaces();
  Future<void> addPlace(PlaceModel place);
}
