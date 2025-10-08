import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/core/services/progress_service.dart';
import 'package:hand_by_hand/features/accessible_places/data/models/place_model.dart';
import 'package:hand_by_hand/features/accessible_places/domain/repos/place_repo.dart';
import 'package:meta/meta.dart';
import '../../../auth/data/models/user_progress.dart';
import '../../domain/entities/place_entitiy.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit(this.placeRepository , this.progressService) : super(PlaceInitial());
  final PlaceRepository placeRepository;
  final ProgressService progressService;

  Future<void> fetchPlaces({
    int limit = 30,
    String langCode = 'en',
  }) async {
    emit(PlacesLoading());
    try {
      final places = await placeRepository.getPlaces(
        langCode: langCode,
        limit: limit,
        lastDocument: null,
      );
      final hasMore = places.length == limit;
      emit(PlacesLoaded(
        places,
        lastDocument:
            places.isNotEmpty ? (places.last as dynamic).snapshot : null,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(PlacesError(e.toString()));
    }
  }

  Future<void> addPlace(PlaceModel place, String userId, UserProgress currentProgress) async {
    emit(PlacesLoading());
    try {
      await placeRepository.addPlace(place);

      await progressService.addContributedPlace(userId, currentProgress); // Consider moving this to a separate listener/cubit for progress

      await fetchPlaces();

    } catch (e, s) {
      print(s);
      emit(PlacesError("Failed to add place: $e"));
    }
  }

  Future<void> fetchMorePlaces({
    int limit = 30,
    String langCode = 'en',
  }) async {
    final currentState = state;
    if (currentState is! PlacesLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final newPlaces = await placeRepository.getPlaces(
        langCode: langCode,
        limit: limit,
        lastDocument: currentState.lastDocument,
      );

      final allPlaces = List<PlaceEntitiy>.from(currentState.places)
        ..addAll(newPlaces);
      final hasMore = newPlaces.isNotEmpty && newPlaces.length == limit;

      emit(PlacesLoaded(
        allPlaces,
        lastDocument: newPlaces.isNotEmpty ? (newPlaces.last as dynamic).snapshot : currentState.lastDocument,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(PlacesError("Failed to fetch more places: $e"));
    }
  }
}
