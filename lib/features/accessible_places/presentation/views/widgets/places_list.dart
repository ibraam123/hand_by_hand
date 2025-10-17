import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:latlong2/latlong.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/entities/place_entitiy.dart';
import '../../logic/place_cubit.dart';

class PlacesList extends StatefulWidget {
  final List<PlaceEntitiy> places;
  final MapController mapController;
  final bool isLoadingMore;
  final PlacesLoaded placesLoaded;



  const PlacesList({
    super.key,
    required this.places,
    required this.mapController,
    this.isLoadingMore = false,
    required this.placesLoaded,
  });

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  late final Box<bool> favoritesBox;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }


  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box<bool>('favorites');
    _scrollController.addListener(() {
      _onScroll();
    });
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        0.7 * _scrollController.position.maxScrollExtent) {
      final langCode = context.locale.languageCode;
      context.read<PlaceCubit>().fetchMorePlaces(langCode: langCode);
    }
  }


  String _placeKey(PlaceEntitiy place) {
    return (place.name.toString().trim().isNotEmpty == true)
        ? place.name
        : place.name;
  }

  void _showTopMessage(BuildContext context, String message,
      {Color background = Colors.blue}) {
    final messenger = ScaffoldMessenger.of(context);

    // remove old banner if exists
    messenger.hideCurrentMaterialBanner();

    messenger.showMaterialBanner(
      MaterialBanner(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.info, color: Colors.white),
        backgroundColor: background,
        actions: [
          TextButton(
            onPressed: () => messenger.hideCurrentMaterialBanner(),
            child: Text(General.dismiss.tr() , style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // auto dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      messenger.hideCurrentMaterialBanner();
    });
  }

  String _getTranslatedType(String type) {
    switch (type) {
      case 'cafe':
        return CategoriesPlaces.cafe.tr();
      case 'restaurant':
        return CategoriesPlaces.restaurant.tr();
      case 'park':
        return CategoriesPlaces.park.tr();
      case 'clinic':
        return CategoriesPlaces.clinic.tr();
      case 'pharmacy':
        return CategoriesPlaces.pharmacy.tr();
      case 'mall':
        return CategoriesPlaces.mall.tr();
      case 'hospital':
        return CategoriesPlaces.hospital.tr();
      case 'all':
        return CategoriesPlaces.all.tr();
      default:
        return type; // fallback if unknown
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: favoritesBox.listenable(),
      builder: (context, box, _) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: widget.placesLoaded.hasMore ? widget.places.length + 1 : widget.places.length,
          itemBuilder: (context, index) {

            if(index < widget.places.length){
              final place = widget.places[index];
              final key = _placeKey(place);
              final isFavorite = box.get(key, defaultValue: false) ?? false;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(Icons.place, color: theme.colorScheme.secondary),
                  title: Text(place.name),
                  subtitle: Text("${General.type.tr()}: ${_getTranslatedType(place.type)}"),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : theme.iconTheme.color,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        favoritesBox.delete(key);
                        _showTopMessage(context, "${place.name} ${General.removeFromFavorites.tr()}",
                            background: theme.colorScheme.error);
                      } else {
                        favoritesBox.put(key, true);
                        _showTopMessage(context, "${place.name} ${General.addToFavorites.tr()}",
                            background: theme.colorScheme.primary);
                      }
                    },
                  ),
                  onTap: () {
                    final latLng = LatLng(place.lat, place.lng);
                    widget.mapController.move(latLng, 15);
                    _showTopMessage(
                      context,
                      "${General.center.tr()} ${place.name}",
                      background: Colors.green,
                    );
                  },
                ),
              );
            }else{
              final hasMore = widget.placesLoaded.hasMore;
              return hasMore ?
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
                  : const SizedBox.shrink();
            }

          },
        );
      },
    );
  }
}
