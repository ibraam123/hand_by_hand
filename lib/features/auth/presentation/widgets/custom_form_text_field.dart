import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/config/app_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.suffixIconButton,
  });

  final String hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconButton? suffixIconButton;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: AppTextStyles.textStyle16,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.greyDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2.w,
            style: BorderStyle.solid,
          ),
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.hintStyle,
        suffixIcon: suffixIconButton,
        prefixIcon: prefixIcon == null ? null : Icon(
          prefixIcon,
          color: AppColors.white,
        ),
      ),
    );
  }
}
// suffex icon false null != null