import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../accessible_places/domain/entities/place_entitiy.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  String _placeKey(PlaceEntitiy place) {
    return (place.name.toString().trim().isNotEmpty == true) ? place.name : place.name;
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box<bool>('favorites');

    return ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box box, _) {
          final keys = box.keys.cast<String>().toList();
          if (keys.isEmpty) {
            return Center(
              child: Text(
                "No favorite places yet 🌌",
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final isFavorite = box.get(key, defaultValue: false) ?? false;

              if (!isFavorite) return const SizedBox.shrink();

              // Normally you’d fetch place details from Firestore/local DB.
              // For demo: we only show the key as name.
              return Card(
                margin: EdgeInsets.only(bottom: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                color: const Color(0xFF1E1E2C),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.place, color: Colors.blueAccent),
                  title: Text(
                    key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Favorite Location",
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      box.delete(key);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("❌ Removed from favorites", style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          elevation: 6,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      );
  }
}
