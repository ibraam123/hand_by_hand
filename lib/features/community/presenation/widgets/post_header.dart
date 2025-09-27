import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final String title;
  final String email;
  final String date;

  const PostHeader({
    super.key,
    required this.title,
    required this.email,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "$email • $date",
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
