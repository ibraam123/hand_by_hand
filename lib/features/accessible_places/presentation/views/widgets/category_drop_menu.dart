import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/accessible_places/domain/entities/category_entitiy.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final List<CategoryEntity> categories;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({super.key, 
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: theme.colorScheme.surface,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: AccessiblePlaces.category.tr(),
        labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        ),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.key,
          child: Text(category.label),
        );
        }).toList(),
      validator: (v) {
        if (v == null) {
          return AccessiblePlaces.selectCategory.tr();
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
