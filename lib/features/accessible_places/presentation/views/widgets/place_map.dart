import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/place_entitiy.dart';

class PlacesMap extends StatelessWidget {
  final MapController mapController;
  final List<PlaceEntitiy> places;
  final LatLng fallback;

  const PlacesMap({
    super.key,
    required this.mapController,
    required this.places,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: places.isNotEmpty
              ? LatLng(places.first.lat, places.first.lng)
              : fallback,
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.hand_by_hand.name',
          ),
          MarkerLayer(
            markers: places.map((place) {
              return Marker(
                point: LatLng(place.lat, place.lng),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 36,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
