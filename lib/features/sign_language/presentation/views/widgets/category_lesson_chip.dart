import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/category_lesson_entitiy.dart';


class CategoryLessonChips extends StatelessWidget {
  final List<CategoryLessonEntity> categories;
  final String selectedType;
  final ValueChanged<String> onSelected;

  const CategoryLessonChips({
    required this.categories,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedType == cat.key;

          return ChoiceChip(
            checkmarkColor: Theme.of(context).colorScheme.onPrimary ,
            label: Text(
              cat.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor:
            Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            elevation: isSelected ? 4 : 0,
            pressElevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            onSelected: (_) => onSelected(cat.key),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemCount: categories.length,
      ),
    );
  }
}
