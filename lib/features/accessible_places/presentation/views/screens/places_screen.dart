import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/place_cubit.dart';
import '../widgets/add_bottom_sheet.dart';
import '../widgets/category_chip.dart';
import '../widgets/place_map.dart';
import '../widgets/places_list.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class AccessibleLocationScreen extends StatefulWidget {
  const AccessibleLocationScreen({super.key});

  @override
  State<AccessibleLocationScreen> createState() =>
      _AccessibleLocationScreenState();
}

class _AccessibleLocationScreenState extends State<AccessibleLocationScreen> {
  final MapController _mapController = MapController();
  String selectedType = "all";

  void _showAddPlaceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black, // Dark background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const AddPlaceBottomSheet();
      },
    );
  }

  final List<String> categories = [
    "all",
    "cafe",
    "restaurant",
    "hospital",
    "pharmacy",
    "park",
    "clinic",
    "mall"
  ];

  @override
  void initState() {
    super.initState();
    context.read<PlaceCubit>().fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddPlaceBottomSheet(context);
        },
        label: Text("Add Place", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add_location_alt),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Accessible Locations",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<PlaceCubit, PlaceState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlacesError) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is PlacesLoaded) {
            final allPlaces = state.places;
            final filteredPlaces = selectedType == "all"
                ? allPlaces
                : allPlaces.where((p) => p.type == selectedType).toList();

            return Column(
              children: [
                // Map Widget
                PlacesMap(
                  mapController: _mapController,
                  places: filteredPlaces,
                  fallback: allPlaces.isNotEmpty
                      ? LatLng(allPlaces.first.lat, allPlaces.first.lng)
                      : LatLng(30.0444, 31.2357),
                ),

                // Category Chips
                CategoryChips(
                  categories: categories,
                  selectedType: selectedType,
                  onSelected: (cat) => setState(() => selectedType = cat),
                ),

                // Places List
                Expanded(
                  child: PlacesList(
                    places: filteredPlaces,
                    mapController: _mapController,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("No places found"));
        },
      ),
    );
  }
}





