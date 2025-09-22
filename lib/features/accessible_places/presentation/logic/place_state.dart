part of 'place_cubit.dart';


@immutable
sealed class PlaceState {}

final class PlaceInitial extends PlaceState {}

final class PlacesLoading extends PlaceState {}

final class PlacesLoaded extends PlaceState {
  final List<PlaceEntitiy> places;
  PlacesLoaded(this.places);
}

final class PlacesError extends PlaceState {
  final String error;
  PlacesError(this.error);
}

