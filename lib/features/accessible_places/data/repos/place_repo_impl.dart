// repositories/place_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/features/accessible_places/domain/entities/place_entitiy.dart';
import '../../domain/repos/place_repo.dart';
import '../models/place_model.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore firestore;

  PlaceRepositoryImpl(this.firestore);

  @override
  Future<List<PlaceEntitiy>> getPlaces() async {
    final snapshot = await firestore.collection("accessible_location").get();
    return snapshot.docs.map((doc) => PlaceModel.fromFirestore(doc.data())).toList();
  }
  Future<void> addPlace(PlaceModel place) async {
    await firestore.collection("accessible_location").add(place.toFirestore());
  }
}
