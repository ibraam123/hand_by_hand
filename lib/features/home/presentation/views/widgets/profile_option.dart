import 'package:flutter/material.dart';


class ProfileOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final int? notificationCount; // 👈 add this

  const ProfileOptionTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            // 👇 Wrap the icon in a Stack to show a badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 30),
                if ((notificationCount ?? 0) > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount! > 9
                            ? '9+' // 👈 cap the number
                            : notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: theme.colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
