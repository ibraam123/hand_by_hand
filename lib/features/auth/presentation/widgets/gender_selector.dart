import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GenderSelector extends StatefulWidget {
  final Function(String gender) onChanged;

  const GenderSelector({super.key, required this.onChanged});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender', // Consider localizing this string
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            _buildOption("Female", Icons.female, Colors.pinkAccent),
            SizedBox(width: 15.w),
            _buildOption("Male", Icons.male, Colors.blue),
          ],
        ),
      ],
    );
  }

  Expanded _buildOption(String gender, IconData icon, Color color) {
    final isSelected = _selectedGender == gender;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedGender = gender);
          widget.onChanged(gender);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? color : theme.colorScheme.onSurfaceVariant),
              SizedBox(width: 8.w),
              Text(
                gender,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
