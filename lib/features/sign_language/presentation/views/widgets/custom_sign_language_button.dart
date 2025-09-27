import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CustomSignLanguageButton extends StatelessWidget {
  const CustomSignLanguageButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.width,
    required this.color, this.iconAssets,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? width;
  final Color color;
  final String? iconAssets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r))
      ),
      child: FractionallySizedBox(
        widthFactor: width == null
            ? 1
            : null, // Occupy full width if no specific width is provided
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          width: width,
          // height: 50.h, // Adjusted height for better responsiveness
          decoration: BoxDecoration(
            color: onTap == null ? theme.colorScheme.secondaryContainer : color,
            borderRadius: BorderRadius.circular(25.r), // Adjusted border radius
          ),

          child: Center(
            child: isLoading
                ? SizedBox(
              height: 24.h,
              width: 24.w,
              child: CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary),
            )
                : FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconAssets != null)
                    iconAssets == 'icon_location'
                        ? Icon(Icons.location_on_outlined,
                        color: onTap == null ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onPrimary)
                        : SvgPicture.asset(iconAssets!)
                  else
                    const SizedBox.shrink(),
                  SizedBox(width: 8.w),
                  Text(
                    text,
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: onTap == null ? theme.colorScheme.onSecondaryContainer :theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ), // Adjusted font size
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
