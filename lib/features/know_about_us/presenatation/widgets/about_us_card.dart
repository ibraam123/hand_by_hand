import 'package:flutter/material.dart';

import '../../models/know_about_us_model.dart';

class AboutUsSectionCard extends StatelessWidget {
  final AboutUsSection section;

  const AboutUsSectionCard({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(section.icon, color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    section.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color
                          ?.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: theme.dividerColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              section.content,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}