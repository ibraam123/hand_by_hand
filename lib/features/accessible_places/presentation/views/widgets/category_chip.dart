import 'package:flutter/material.dart';

import '../../../domain/entities/category_entitiy.dart';
class CategoryChips extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedType;
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(cat.label), // Show translated label
              selected: selectedType == cat.key, // Compare using key
              onSelected: (_) => onSelected(cat.key), // Return key
            ),
          );
        }).toList(),
      ),
    );
  }
}