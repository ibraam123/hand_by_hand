import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthDateSelector extends StatefulWidget {
  final Function(int? day, String? month, int? year) onChanged;

  const BirthDateSelector({super.key, required this.onChanged});

  @override
  State<BirthDateSelector> createState() => _BirthDateSelectorState();
}

class _BirthDateSelectorState extends State<BirthDateSelector> {
  int? _selectedDay;
  String? _selectedMonth;
  int? _selectedYear;

  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            // Day
            Expanded(
              child: _buildDropdown<int>(
                hint: "Day",
                value: _selectedDay,
                items: List.generate(31, (index) => index + 1),
                onChanged: (val) {
                  setState(() => _selectedDay = val);
                  widget.onChanged(_selectedDay, _selectedMonth, _selectedYear);
                },
              ),
            ),
            SizedBox(width: 10.w),

            // Month
            Expanded(
              child: _buildDropdown<String>(
                hint: "Month",
                value: _selectedMonth,
                items: _months,
                onChanged: (val) {
                  setState(() => _selectedMonth = val);
                  widget.onChanged(_selectedDay, _selectedMonth, _selectedYear);
                },
              ),
            ),
            SizedBox(width: 10.w),

            // Year
            Expanded(
              child: _buildDropdown<int>(
                hint: "Year",
                value: _selectedYear,
                items: List.generate(
                  100,
                      (index) => DateTime.now().year - index,
                ),
                onChanged: (val) {
                  setState(() => _selectedYear = val);
                  widget.onChanged(_selectedDay, _selectedMonth, _selectedYear);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          style: theme.textTheme.bodyMedium,
          dropdownColor: theme.colorScheme.surfaceContainerHighest,
          isExpanded: true,
          value: value,
          hint: Text(hint, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
          items: items.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString(),
                  style: theme.textTheme.bodyMedium),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
