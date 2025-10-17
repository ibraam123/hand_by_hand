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
import '../../../domain/entities/sign_lesson_entitiy.dart';


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

            Expanded(
              flex: 3,
              child: Text(
                signLessonModel.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
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

}