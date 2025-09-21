import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/features/onboarding/models/explanation_screen_model.dart';

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
      title: 'To Everyone Living with a Disability',
      description:
          ' You are not alone💙  There are millions who share your journey, your strength, and your dreams. Check out our role models – people who prove every day that life with a disability can be powerful, inspiring, and full of possibilities. Together, we rise. Together, we thrive. 🌟learners.',
    ),
    ExplanationScreenModel(
      imageAssets: Assets.imagesUpImage,
      title: 'Never Do This',
      description: """
Disability ≠ Disease


Don’t treat someone with a disability like a patient waiting to be cured.
A patient needs treatment.  But a person with a disability needs to learn how to adapt and live fully.
Don’t leave them isolated at home.  Take them out, include them, support them…"""

    ),
    ExplanationScreenModel(
      imageAssets: Assets.imagesUpImage,
      title: 'Thank You for Caring and Wanting to Learn!',
      description:"""
      People with disabilities often have the kindest and strongest souls. ❤️  They want to connect, engage, and share life – just like anyone else.
Treat them with respect.  Give them equal chances.  Include them in laughter, conversations, and experiences – not pity.
Because what they truly want is simple: To be seen as equals. To be treated as humans first. 🌟"
      """
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Choose your experience to get the best recommendations.',
            style: TextStyle(fontSize: 16.sp, color: AppColors.white),
            textAlign: TextAlign.center, // centers the lines
          ),
          SizedBox(height: 24),
          CustomButton(
            text: 'Me 💪 Living with a disability',
            onTap: () {
              GoRouter.of(context).push(AppRoutes.kExplanationView , extra: explanationScreenModels [0]);
            },
            width: double.infinity,
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          CustomButton(
            text: 'I am a Regular User',
            onTap: () {
              GoRouter.of(context).push(AppRoutes.kExplanationView , extra: explanationScreenModels [1]);
            },
            width: double.infinity,
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          CustomButton(
            text: 'I’m fine, just helping someone in my family 💖',
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
