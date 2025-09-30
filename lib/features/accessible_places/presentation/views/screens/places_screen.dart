import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import '../../../domain/entities/category_entitiy.dart';
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
  String selectedType = 'all';

  void _showAddPlaceBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const AddPlaceBottomSheet();
      },
    );
  }

  final List<CategoryEntity> categories = [
    CategoryEntity("all", CategoriesPlaces.all.tr()),
    CategoryEntity("cafe", CategoriesPlaces.cafe.tr()),
    CategoryEntity("restaurant", CategoriesPlaces.restaurant.tr()),
    CategoryEntity("park", CategoriesPlaces.park.tr()),
    CategoryEntity("clinic", CategoriesPlaces.clinic.tr()),
    CategoryEntity("pharmacy", CategoriesPlaces.pharmacy.tr()),
    CategoryEntity("mall", CategoriesPlaces.mall.tr()),
    CategoryEntity("hospital", CategoriesPlaces.hospital.tr()),
  ];

  @override
  void initState() {
    super.initState();
    context.read<PlaceCubit>().fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddPlaceBottomSheet(context);
        },
        label: Text(
          Home.addPlace.tr(),
          style: TextStyle(color: theme.colorScheme.onSecondary),
        ),
        icon: Icon(Icons.add_location_alt,
            color: theme.colorScheme.onSecondary),
        backgroundColor: theme.colorScheme.secondary,
      ),
      appBar: AppBar( // Using theme for AppBar
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          Home.accessiblePlaces.tr(),
          style: theme.appBarTheme.titleTextStyle,
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
                      : const LatLng(30.0444, 31.2357),
                ),

                // Category Chips
                CategoryChips(
                  categories: categories,
                  selectedType: selectedType,
                  onSelected: (key) => setState(() => selectedType = key),
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





