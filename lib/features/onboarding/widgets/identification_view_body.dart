import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';

import '../../../core/widgets/custom_button.dart';

class IdentificationViewBody extends StatelessWidget {
  const IdentificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Choose your experience to get the best recommendations.' , style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.white,
          ),
            textAlign: TextAlign.center, // centers the lines
          ),
          SizedBox(height: 18.h,),
          CustomButton(
            text: 'Me 💪 Living with a disability',
            onTap: () {},
            width: double.infinity,
            color: AppColors.primary,
          ),
          SizedBox(height: 10.h,),
          CustomButton(
            text: 'I am a Regular User',
            onTap: () {},
            width: double.infinity,
            color: AppColors.primary,

          ),
          SizedBox(height: 10.h,),
          CustomButton(
            text: 'I’m fine, just helping someone in my family 💖',
            onTap: () {},
            width: double.infinity,
            color: AppColors.primary,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: 'Back',
                onTap: () {},
                width: 100.w,
                color: AppColors.backButton,
              ),
              CustomButton(
                text: 'Continue',
                onTap: () {},
                width: 100.w,
                color: AppColors.primary,
              ),
            ],
          )
        ],
      ),
    );
  }
}
