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
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Card(
        elevation: 4,
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).push(
              AppRoutes.kRoleModelDetails,
              extra: roleModel,
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6.r,
                  offset: Offset(0, 4.h),
                ),
              ],
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Adjusted based on screen size if needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        roleModel.story,
                        maxLines: 3, // show only 4 lines
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14, // Adjusted based on screen size if needed
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Right side (image)
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      roleModel.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null));
                      }
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
