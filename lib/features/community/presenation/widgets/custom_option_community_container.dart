import 'package:flutter/material.dart';

class CustomOptionCommunityContainer extends StatelessWidget {
  const CustomOptionCommunityContainer({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10),
      child:  Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
              color: theme.colorScheme.shadow.withValues(alpha: 0.3),
            )
          ]
        ),
        child: Material(
          color: theme.colorScheme.surfaceContainerHighest, // matches container background
          borderRadius: BorderRadius.circular(20),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            onTap: onTap,
            leading: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 28,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      )
    );
  }
}