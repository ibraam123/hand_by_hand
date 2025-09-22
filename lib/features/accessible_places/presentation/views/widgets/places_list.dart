import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/place_entitiy.dart';

class PlacesList extends StatelessWidget {
  final List<PlaceEntitiy> places;
  final MapController mapController;

  const PlacesList({
    super.key,
    required this.places,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.place, color: Colors.blue),
            title: Text(place.name),
            subtitle: Text("Type: ${place.type}"),
            onTap: () {
              final latLng = LatLng(place.lat, place.lng);
              mapController.move(latLng, 15);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Centered on ${place.name}" , style: const TextStyle(color: Colors.white)),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.blueAccent,
                  action: SnackBarAction(
                    label: "Close",
                    onPressed: () {},
                    textColor: Colors.white,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),

                ),
              );
            },
          ),
        );
      },
    );
  }
}
