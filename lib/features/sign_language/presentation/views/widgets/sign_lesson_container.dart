import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/auth/presentation/logic/auth_cubit.dart';
import 'package:hand_by_hand/features/sign_language/presentation/views/widgets/custom_sign_language_button.dart';

import '../../../../../core/config/routes.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../auth/data/models/user_progress.dart';
import '../../../domain/entities/sign_lesson_entitiy.dart';
import '../../logic/sign_language_cubit.dart';


class SignLessonCustomContainer extends StatelessWidget {
  const SignLessonCustomContainer({
    super.key,
    required this.signLessonModel,
  });

  final SignLessonEntitiy signLessonModel;


  void _onWatchVideoPressed(BuildContext context) {
    final authState = context
        .read<AuthCubit>()
        .state;
    if (authState is AuthError) {
      CustomSnackBar.show(
        context,
        message: authState.errorMessage,
        backgroundColor: Colors.red,
        icon: Icons.error,
        duration: Duration(seconds: 2),
      );
      return;
    }
    final user = (authState as AuthSuccess).user;
    final progress = user?.progress ?? UserProgress(
      totalLessons: 0,
      completedLessons: 0,
      streakDays: 0,
      contributedPlaces: 0,
    );
    context.read<SignLanguageCubit>().completeLesson(user!.id, progress);
    GoRouter.of(context).push(
        AppRoutes.kSignLanguageLessonVideo, extra: signLessonModel);
  }


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
                  SizedBox(height: 4.h),
                  _buildProgressIndicator(context),
                ],
              ),
            ),

            SizedBox(width: 12.w),


            CustomSignLanguageButton(
              text: SignLanguage.watchVideo.tr(),
              color: AppColors.primary,
              onTap: () => _onWatchVideoPressed(context),
              width: 100.w,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    // You can add a small progress indicator here if you track individual lesson completion
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'New',
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}