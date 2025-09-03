import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_styles.dart';



class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.width,
    required this.color,
  });
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: width == null ? 1 : null, // Occupy full width if no specific width is provided
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
            width: width,
            height: 50.h, // Adjusted height for better responsiveness
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25.r), // Adjusted border radius
            ),
            child: Center(
                child: isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: CircularProgressIndicator(
                          color: color,
                        ),
                      )
                    : FittedBox( // Makes text responsive
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: AppTextStyles.semiBold20.copyWith(fontSize: 18.sp), // Adjusted font size
                        ),
                      ))),
      ),
    );
  }
}
