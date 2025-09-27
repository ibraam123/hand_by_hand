import 'package:flutter/material.dart';

class SectionHelpTitle extends StatelessWidget {
  const SectionHelpTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
    );
  }
}
