import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_styles.dart';


class CustomMessageContainer extends StatelessWidget {
  const CustomMessageContainer({
    super.key,
    required this.width,
    required this.height, required this.message,
  });

  final double width;
  final double height;
  final String message ;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.01,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(width * 0.05),
              topRight: Radius.circular(width * 0.05),
            ),
          ),
          child: Text(
            message,
            style: AppTextStyles.semiBold20.copyWith(
              fontSize: width * 0.045, // still responsive
            ),
          ),
        ),
      ),
    );
  }
}
