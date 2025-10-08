// repositories/place_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/features/accessible_places/data/models/place_model.dart';
import 'package:hand_by_hand/features/accessible_places/domain/entities/place_entitiy.dart';

abstract class PlaceRepository {
  Future<List<PlaceEntitiy>> getPlaces(
      {required String langCode, required int limit, DocumentSnapshot? lastDocument}
      );
  Future<void> addPlace(PlaceModel place);
}
