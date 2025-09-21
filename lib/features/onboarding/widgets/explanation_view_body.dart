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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    explanationScreenModel.imageAssets,
                    width: size.width,
                    height: size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: size.height * 0.02), // Responsive spacing
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ), // Responsive padding
                    child: Text(
                      explanationScreenModel.title,
                      style: AppTextStyles.bold24.copyWith(
                        fontSize: size.width * 0.06,
                      ), // Responsive font size
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02), // Responsive spacing
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ), // Responsive padding
                    child: Text(
                      explanationScreenModel.description,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle16.copyWith(
                        fontSize: size.width * 0.04,
                      ), // Responsive font size
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.all(
                      size.width * 0.05,
                    ), // Responsive padding
                    child: CustomButton(
                      text: "Get Started",
                      color: AppColors.primary,
                      onTap: () {
                        GoRouter.of(context).go(AppRoutes.kMainScreen);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
