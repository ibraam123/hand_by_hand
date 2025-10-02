import 'package:flutter/material.dart';
import 'logout_drawer_item.dart';
import 'menu_drawer_items.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.name, required this.email});
  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              accountName: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(color: Colors.white),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
            Expanded(
              child: MenuDrawerItems(isDarkMode: isDarkMode , ),
            ),
            LogoutDrawerItem(),
          ],
        ),
      ),
    );
  }
}


