import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/config/routes.dart';
import '../../../domain/entities/role_model_entity.dart';


class RoleModelCustomContainer extends StatelessWidget {
  const RoleModelCustomContainer({
    super.key,
    required this.roleModel,
  });

  final RoleModelEntity roleModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push(
            AppRoutes.kRoleModelDetails,
            extra: roleModel,
          );
        },
        child: Card(
          elevation: 4.0, // Added elevation
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: theme.cardColor,
            ),
            child: Row(
              children: [
                // Left side (text)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roleModel.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        roleModel.story,
                        maxLines: 3, // show only 4 lines
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp, // Adjusted based on screen size if needed
                          color: theme.textTheme.bodyMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Right side (image)
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0.r),
                    child: CachedNetworkImage(
                      imageUrl: roleModel.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover, // Changed to contain to show the whole image
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 80.w, color: theme.colorScheme.error), // Adjusted size with screen util
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
