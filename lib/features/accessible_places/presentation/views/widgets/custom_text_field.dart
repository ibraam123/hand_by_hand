import 'package:flutter/material.dart';

class CustomTextFieldPlaces extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFieldPlaces({super.key, 
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold ,           color: isDarkMode ? Colors.white : Colors.black,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          filled: true,
          fillColor: isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
