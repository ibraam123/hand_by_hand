import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/error.dart';
import '../../domain/entities/place_entitiy.dart';
import '../../domain/repos/place_repo.dart';
import '../data_sources/remote_data_source/places_remote.dart';
import '../models/place_model.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlacesRemote placesRemote;

  PlaceRepositoryImpl(this.placesRemote);

  @override
  Future<List<PlaceEntitiy>> getPlaces({
    required String langCode,
    required int limit,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final places = await placesRemote.getPlaces(
        langCode: langCode,
        limit: limit,
        lastDocument: lastDocument,
      );
      return places;
    } catch (error) {
      final message = FailureHandler.mapException(error);
      throw ServerFailure(message);
    }
  }

  @override
  Future<void> addPlace(PlaceModel place) async {
    try {
      await placesRemote.addPlace(place);
    } catch (error) {
      final message = FailureHandler.mapException(error);
      throw ServerFailure(message);
    }
  }
}
