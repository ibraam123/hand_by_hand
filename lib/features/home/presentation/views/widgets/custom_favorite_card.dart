import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';

import '../../logic/favorites_cubit.dart';

class CustomFavoriteCard extends StatelessWidget {
  final String id;
  final String title;

  const CustomFavoriteCard({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: theme.cardColor,
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.place, color: theme.colorScheme.secondary),
        title: Text(
          title,
          style: TextStyle(
            color: theme.textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          Favorites.location.tr(),
          style: TextStyle(
            color: theme.textTheme.bodyMedium!.color,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            context.read<FavoritesCubit>().removeFavorite(id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(Favorites.removed.tr()),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }
}
