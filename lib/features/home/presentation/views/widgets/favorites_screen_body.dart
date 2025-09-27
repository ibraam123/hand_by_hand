import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_favorite_card.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesBox = Hive.box<bool>('favorites');

    return ValueListenableBuilder(
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box box, _) {
          final keys = box.keys.cast<String>().toList();
          if (keys.isEmpty) {
            return Center(
              child: Text(
                "No favorite places yet 🌌",
                style: TextStyle(
                  color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                  fontSize: 16.sp,
                ),
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

              return CustomFavoriteCard(keyBox: key, box: box);
            },
          );
        },
      );
  }
}
