import 'package:flutter/material.dart';

class FaqHelpItem extends StatelessWidget {
  const FaqHelpItem({super.key, required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? theme.colorScheme.surface : theme.cardColor,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        iconColor: isDarkMode ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primary,
        collapsedIconColor: isDarkMode ? theme.colorScheme.onSurfaceVariant.withValues(
            alpha: 0.7
        ) : theme.colorScheme.secondary,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          question,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: 0),
            child: Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.grey[300] : Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
