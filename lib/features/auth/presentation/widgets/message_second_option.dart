import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageSecondOption extends StatelessWidget {
  const MessageSecondOption({super.key, required this.message, required this.buttonText, required this.onTap});
  final String message;
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: theme.textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: 12.sp,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            buttonText,
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
