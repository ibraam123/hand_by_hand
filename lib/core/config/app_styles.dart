import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle bold24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle semiBold20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle textStyle16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.greyLight,
  );

  static final TextStyle caption14 = TextStyle(
    fontSize: 14.sp,
    color: AppColors.greyDark,
  );
  static final TextStyle hintStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xff9db7a7),
  );

  static final TextStyle button16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle regular12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bold16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );
}
