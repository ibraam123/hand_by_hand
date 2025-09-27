import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/widgets/custom_button.dart';

import '../../../../../core/config/app_colors.dart';

class CustomFeaturesContainer extends StatelessWidget {
  const CustomFeaturesContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText, this.onPress,
  });

  final String title;
  final String subtitle;
  final String? image;
  final String buttonText;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image takes full width
          if (image != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                image!,
                width: double.infinity,
                height: size.height * 0.25, // Higher image
                fit: BoxFit.cover,
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge!.color),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: 16),

                // Button aligned to right
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: CustomButton(
                        onTap: onPress,
                        text: buttonText,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
