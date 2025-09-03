import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.bold24,
        displayMedium: AppTextStyles.semiBold20,
        displaySmall: AppTextStyles.textStyle16,
        bodyMedium: AppTextStyles.caption14,
        bodyLarge: AppTextStyles.button16,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
