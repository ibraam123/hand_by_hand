import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';

class OptionsViewBody extends StatelessWidget {
  const OptionsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomButton(iconAssets: "icon_location", text: 'Accessible Places', color: AppColors.primary),
          const SizedBox(height: 20),
          CustomButton(iconAssets: "assets/images/3.svg", text: 'Learn Sign Language', color: AppColors.primary),
          const SizedBox(height: 20),
          CustomButton(iconAssets: "assets/images/2.svg" , text: 'role model', color: AppColors.primary),
          const SizedBox(height: 20),
          CustomButton(iconAssets: "assets/images/1.svg", text: 'Know about us', color: AppColors.primary),
        ],
      ),
    );
  }
}
