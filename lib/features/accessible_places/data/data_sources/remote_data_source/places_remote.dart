import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/core/errors/error.dart';
import '../../models/place_model.dart';

abstract class PlacesRemote {
  Future<List<PlaceModel>> getPlaces({
    required String langCode,
    required int limit,
    DocumentSnapshot? lastDocument,
  });
  Future<void> addPlace(PlaceModel place);
}

class PlacesRemoteImpl implements PlacesRemote {
  final FirebaseFirestore firestore;
  PlacesRemoteImpl(this.firestore);

  @override
  Future<void> addPlace(PlaceModel place) async {
    final querySnapshot = await firestore
        .collection("accessible_location")
        .where('name', isEqualTo: place.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      throw ServerFailure.fromFirestoreError("Place already exists");
    }

    await firestore.collection("accessible_location").add(place.toFirestore());
  }

  @override
  Future<List<PlaceModel>> getPlaces({
    required String langCode,
    required int limit,
    DocumentSnapshot<Object?>? lastDocument,
  }) async {
    Query query = firestore.collection("accessible_location").limit(limit);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs
        .map(
          (doc) => PlaceModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            snapshot: doc,
          ),
        )
        .toList();
  }
}
