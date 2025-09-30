import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_screen_body.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorites_screen_body.dart';
import '../widgets/home_screen_body.dart';
import '../widgets/notification_screen_body.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/config/app_keys_localization.dart'; // فيه NavigationKeys

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const NotificationsScreen(),
    const ProfileScreenBody(),
  ];
  String _fullName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName =
      '${prefs.getString('firstName')!} ${prefs.getString('lastName')!}';
      _email = prefs.getString('email') ?? 'N/A';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(
          name: _fullName,
          email: _email,
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            currentIndex == 0
                ? NavigationKeys.home.tr()
                : currentIndex == 1
                ? NavigationKeys.favorites.tr()
                : currentIndex == 2
                ? NavigationKeys.notifications.tr()
                : NavigationKeys.profile.tr(),
            style: TextStyle(
              color: theme.appBarTheme.titleTextStyle?.color ??
                  theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _screens[currentIndex],
        bottomNavigationBar: GNav(
          color: theme.bottomNavigationBarTheme.unselectedItemColor ??
              Color.alphaBlend(
                  theme.colorScheme.onSurface.withAlpha(153), Colors.transparent),
          activeColor:
          theme.bottomNavigationBarTheme.selectedItemColor ??
              theme.colorScheme.primary,
          tabBackgroundColor:
          theme.bottomNavigationBarTheme.selectedItemColor != null
              ? Color.alphaBlend(
              theme.bottomNavigationBarTheme.selectedItemColor!
                  .withAlpha(26),
              Colors.transparent)
              : Color.alphaBlend(
              theme.colorScheme.primary.withAlpha(26),
              Colors.transparent),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          gap: 8,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          onTabChange: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          tabs: [
            GButton(
              icon: Icons.home,
              text: NavigationKeys.home.tr(),
              iconActiveColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
              textColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
            ),
            GButton(
              icon: Icons.favorite,
              text: NavigationKeys.favorites.tr(),
              iconActiveColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
              textColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
            ),
            GButton(
              icon: Icons.notifications,
              text: NavigationKeys.notifications.tr(),
              iconActiveColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
              textColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
            ),
            GButton(
              icon: Icons.person,
              text: NavigationKeys.profile.tr(),
              iconActiveColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
              textColor: theme.bottomNavigationBarTheme.selectedItemColor ??
                  theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
