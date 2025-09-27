import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final List<String> categories;
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
      value: value,
      dropdownColor: theme.colorScheme.surface,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: "Category",
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
      items: categories
          .map(
            (cat) => DropdownMenuItem(
          value: cat,
          child: Text(cat.toUpperCase(),
              style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}
