part of 'place_cubit.dart';


@immutable
sealed class PlaceState {}

final class PlaceInitial extends PlaceState {}

final class PlacesLoading extends PlaceState {}

final class PlacesLoaded extends PlaceState {
  final List<PlaceEntitiy> places;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final bool isLoadingMore;
  PlacesLoaded(
  this.places,{
    this.lastDocument,
    this.hasMore = true,
    this.isLoadingMore = false,
  });
  PlacesLoaded copyWith({
    List<PlaceEntitiy>? places,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    bool? isLoadingMore,
  }) {
    return PlacesLoaded(
      places ?? this.places,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: lastDocument ?? this.lastDocument,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class PlacesError extends PlaceState {
  final String error;
  PlacesError(this.error);
}

