import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';
import 'package:hive/hive.dart';

class CustomFavoriteCard extends StatelessWidget {
  final String keyBox;
  final Box box;
  const CustomFavoriteCard({super.key, required this.keyBox, required this.box});

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
          keyBox,
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
            box.delete(
              keyBox,
            );
            CustomSnackBar.show(
              context,
              message: Favorites.removed.tr(),
              icon: Icons.remove_circle_outline,
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            );
          },
        ),
      ),
    );
  }
}
