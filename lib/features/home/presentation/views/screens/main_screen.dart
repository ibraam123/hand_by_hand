import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_screen_body.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/home_screen_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _fullName = prefs.getString('firstName')! + ' ' + prefs.getString('lastName')!;
      _email = prefs.getString('email') ?? 'N/A';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: CustomDrawer(
        name: _fullName,
        email: _email,
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(
            Icons.notifications,
            color: Color(0xfffdbf07),
            size: 30,
          ),)
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          currentIndex == 0
              ? 'Home'
              : currentIndex == 1
                  ? 'Favorites'
                  : 'Profile',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ) ,
      body: _screens[currentIndex],
      bottomNavigationBar: GNav(
        backgroundColor: Colors.black, // Dark background for the Nav Bar
        color: Colors.white54, // Color for inactive icons and text
        activeColor: AppColors.primary, // Color for active icon and text (using your primary color)
        tabBackgroundColor: Colors.grey[800]!, // Background color for the selected tab
        // iconSize: 24, // Optional: Adjust icon size
        gap: 8,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        padding: EdgeInsetsGeometry.all(16),
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.favorite,
            text: 'Favorites',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorites Screen'),
    );
  }
}


