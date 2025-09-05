import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/config/app_styles.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';
import 'package:hand_by_hand/features/onboarding/models/explanation_screen_model.dart';

import '../../../core/config/routes.dart';

class ExplanationViewBody extends StatelessWidget {
  const ExplanationViewBody({super.key, required this.explanationScreenModel});
  final ExplanationScreenModel explanationScreenModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            explanationScreenModel.imageAssets,
            width: size.width,
            height: size.height * 0.3,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              explanationScreenModel.title,
              style: AppTextStyles.bold24,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              explanationScreenModel.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.textStyle16,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(text: "Get Started", color: AppColors.primary , onTap: (){
              GoRouter.of(context).push(AppRoutes.kOptionsView);
            },),
          ),
        ],
      ),
    );
  }
}
