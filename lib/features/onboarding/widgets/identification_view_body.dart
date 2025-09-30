import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/onboarding/models/explanation_screen_model.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../generated/assets.dart';

class IdentificationViewBody extends StatefulWidget {
  const IdentificationViewBody({super.key});

  @override
  State<IdentificationViewBody> createState() => _IdentificationViewBodyState();
}

class _IdentificationViewBodyState extends State<IdentificationViewBody> {
  final List<ExplanationScreenModel> explanationScreenModels = [
     ExplanationScreenModel(
      imageAssets: Assets.imagesUpImage,
      title: OnboardingKeys.toEveryone.tr(),
      description:
         OnboardingKeys.screen1Description.tr()
    ),
     ExplanationScreenModel(
      imageAssets: Assets.imagesUpImage,
      title: OnboardingKeys.screen2Title.tr(),
      description: OnboardingKeys.screen2Description.tr()
    ),
     ExplanationScreenModel(
      imageAssets: Assets.imagesUpImage,
      title: OnboardingKeys.screen3Title.tr(),
      description: OnboardingKeys.screen3Description.tr()
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            OnboardingKeys.chooseExperience.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center, // centers the lines
          ),
          SizedBox(height: 24.h),
          CustomButton(
            text: OnboardingKeys.livingWithDisability.tr(),
            onTap: () {
              GoRouter.of(context).push(AppRoutes.kExplanationView,
                  extra: explanationScreenModels[0]);
            },
            width: double.infinity,
            color: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: OnboardingKeys.regularUser.tr(),
            onTap: () {
              GoRouter.of(context).push(AppRoutes.kExplanationView,
                  extra: explanationScreenModels[1]);
            },
            width: double.infinity,
            color: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: OnboardingKeys.helpingFamily.tr(),
            onTap: () {
              GoRouter.of(context).push(AppRoutes.kExplanationView , extra: explanationScreenModels [2]);
            },
            width: double.infinity,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
