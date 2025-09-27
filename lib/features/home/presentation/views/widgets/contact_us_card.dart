import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Uri uri;
  final String errorMessage;

  const ContactUsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.uri,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? theme.colorScheme.surface : theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87),
        ),
        subtitle: Text(subtitle,
            style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        onTap: () async {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        },
      ),
    );
  }
}
