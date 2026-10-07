import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.width,
    required this.color, this.iconAssets,
    this.textColor,
    this.borderColor,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? width;
  final Color color;
  final String? iconAssets;
  final Color? textColor;
  final Color? borderColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && !widget.isLoading) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r))
          ),
          child: FractionallySizedBox(
            widthFactor: widget.width == null
                ? 1
                : null, // Occupy full width if no specific width is provided
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          width: widget.width,
          height: 50.h, // Adjusted height for better responsiveness
          decoration: BoxDecoration(
            color: widget.onTap == null ? theme.colorScheme.secondaryContainer : widget.color,
            borderRadius: BorderRadius.circular(25.r), // Adjusted border radius
          ),
          child: Center(
            child: widget.isLoading
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
                        if (widget.iconAssets != null)
                        widget.iconAssets == 'icon_location'
                            ? Icon(Icons.location_on_outlined,
                                color: widget.onTap == null ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onPrimary)
                            : SvgPicture.asset(widget.iconAssets!)
                        else
                          const SizedBox.shrink(),
                        SizedBox(width: 8.w),
                        Text(
                          widget.text,
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: widget.onTap == null ? theme.colorScheme.onSecondaryContainer :theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ), // Adjusted font size
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
     ),
    )
    );  }
}
