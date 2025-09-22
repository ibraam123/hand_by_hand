import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    required this.value,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF2C2C3E),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Category",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2C2C3E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: categories
          .map(
            (cat) => DropdownMenuItem(
          value: cat,
          child: Text(
            cat.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}
