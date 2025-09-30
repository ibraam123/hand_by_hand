import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/sign_language/presentation/views/widgets/custom_sign_language_button.dart';

import '../../../../../core/config/routes.dart';
import '../../../domain/entities/sign_lesson_entitiy.dart';


class SignLessonCustomContainer extends StatelessWidget {
  const SignLessonCustomContainer({
    super.key,
    required this.signLessonModel,
  });

  final SignLessonEntitiy signLessonModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4.0.r,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0.r),
      ),
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          children: [
            /// --- Left: Text Content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signLessonModel.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            CustomSignLanguageButton(text: SignLanguage.watchVideo.tr(), color: AppColors.primary ,
              onTap: () {
                GoRouter.of(context).push(AppRoutes.kSignLanguageLessonVideo, extra: signLessonModel);
              },
              width: 100.w,
            )
          ],
        ),
      ),
    );
  }
}
/**Flexible(
    child: AspectRatio(
    aspectRatio: 1, // Ensures the image container is a square
    child: ClipRRect(
    borderRadius: BorderRadius.circular(12.0.r),
    child: CachedNetworkImage(
    imageUrl: signLessonModel.imageUrl,
    fit: BoxFit.contain, // Changed to contain to show the whole image
    placeholder: (context, url) => Center(
    child: CircularProgressIndicator(
    color: theme.colorScheme.primary,
    ),
    ),
    errorWidget: (context, url, error) =>
    Icon(Icons.broken_image, size: 80.w, color: theme.colorScheme.error), // Adjusted size with screen util
    ),
    ),
    ),
    )*/