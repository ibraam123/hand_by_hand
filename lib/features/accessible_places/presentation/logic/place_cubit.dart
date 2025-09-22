import 'package:bloc/bloc.dart';
import 'package:hand_by_hand/features/accessible_places/data/models/place_model.dart';
import 'package:hand_by_hand/features/accessible_places/domain/repos/place_repo.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/place_entitiy.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit(
      this.placeRepository,
      ) : super(PlaceInitial());
  final PlaceRepository placeRepository;

  Future<void> fetchPlaces() async {
    emit(PlacesLoading());
    try {
      final places = await placeRepository.getPlaces();
      emit(PlacesLoaded(places));
    } catch (e) {
      emit(PlacesError(e.toString()));
    }
  }

  Future<void> addPlace(PlaceModel place) async {
    try {
      await placeRepository.addPlace(place);
      fetchPlaces(); // refresh places after adding
    } catch (e) {
      emit(PlacesError("Failed to add place: $e"));
    }
  }
}
