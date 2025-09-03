import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_styles.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTextStyles.button16,
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

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedGender = gender);
          widget.onChanged(gender);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : const Color(0xff414141),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey),
              SizedBox(width: 8.w),
              Text(
                gender,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
