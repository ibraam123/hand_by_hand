import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/entities/place_entitiy.dart';

class PlacesList extends StatefulWidget {
  final List<PlaceEntitiy> places;
  final MapController mapController;

  const PlacesList({
    super.key,
    required this.places,
    required this.mapController,
  });

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  late final Box<bool> favoritesBox;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box<bool>('favorites');
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
            child: const Text("DISMISS", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // auto dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      messenger.hideCurrentMaterialBanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: favoritesBox.listenable(),
      builder: (context, box, _) {
        return ListView.builder(
          key: ValueKey('places_list_${widget.places.length}_${widget.places.hashCode}'),
          itemCount: widget.places.length,
          itemBuilder: (context, index) {
            final place = widget.places[index];
            final key = _placeKey(place);
            final isFavorite = box.get(key, defaultValue: false) ?? false;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                key: ValueKey('place_${place.name}_${place.lat}_${place.lng}'),
                leading: Icon(Icons.place, color: theme.colorScheme.secondary),
                title: Text(place.name),
                subtitle: Text("Type: ${place.type}"),
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
                      _showTopMessage(context, "Removed from favorites",
                          background: theme.colorScheme.error);
                    } else {
                      favoritesBox.put(key, true);
                      _showTopMessage(context, "Added to favorites",
                          background: theme.colorScheme.primary);
                    }
                  },
                ),
                onTap: () {
                  final latLng = LatLng(place.lat, place.lng);
                  widget.mapController.move(latLng, 15);
                  _showTopMessage(
                    context,
                    "Centered on ${place.name}",
                    background: theme.colorScheme.secondary,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
