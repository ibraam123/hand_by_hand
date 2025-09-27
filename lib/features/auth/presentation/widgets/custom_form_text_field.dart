import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold ,           color: isDarkMode ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2.w,
          ),
        ),
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        suffixIcon: suffixIconButton,
        prefixIcon: prefixIcon == null ? null : Icon(
          prefixIcon,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
// suffex icon false null != null