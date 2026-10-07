import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/features/community/presenation/views/main_community_screen.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_screen_body.dart';
import '../../logic/profile_cubit.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorites_screen_body.dart';
import '../widgets/home_screen_body.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/config/app_keys_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    MainCommunityScreen(),
    ProfileScreenBody(),
  ];

  @override
  void initState() {
    super.initState();
    // Load profile through Cubit, not directly here
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Scaffold(
          drawer: isTablet ? null : _buildDrawer(),
          appBar: _buildAppBar(isTablet),
          body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
          bottomNavigationBar: isTablet ? null : _buildBottomNav(isDarkMode),
        );
      },
    );
  }

  // Tablet layout with side navigation
  Widget _buildTabletLayout() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            _onNavItemTapped(index);
          },
          labelType: NavigationRailLabelType.all,
          destinations: _getNavDestinations(),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _screens[_currentIndex]),
      ],
    );
  }

  // Mobile layout with bottom navigation
  Widget _buildMobileLayout() {
    return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: _screens[_currentIndex],
    );
  }

  PreferredSizeWidget _buildAppBar(bool isTablet) {
    return AppBar(
      centerTitle: true,
      title: Text(
        _getTitle(_currentIndex),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: isTablet ? 24.sp : 20.sp,
        ),
      ),
      actions: isTablet
          ? [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Center(
                        child: Text(
                          state.firstName,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ]
          : null,
    );
  }

  Widget _buildDrawer() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return CustomDrawer(name: state.fullName, email: state.email ?? '');
        }
        return const CustomDrawer(name: 'Guest', email: '');
      },
    );
  }


  Widget _buildBottomNav(bool isDarkMode) {
    return NavigationBar(
      indicatorColor: isDarkMode ? Colors.white : Colors.lightBlueAccent,
      selectedIndex: _currentIndex,
      onDestinationSelected: _onNavItemTapped,
      destinations: _getBottomNavDestinations(),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }

  List<NavigationRailDestination> _getNavDestinations() {
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: Text(NavigationKeys.home.tr()),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.favorite_border),
        selectedIcon: const Icon(Icons.favorite),
        label: Text(NavigationKeys.favorites.tr()),
      ),
      /*NavigationRailDestination(
        icon: const Icon(Icons.notifications_outlined),
        selectedIcon: const Icon(Icons.notifications),
        label: Text(NavigationKeys.notifications.tr()),
      ),*/
      NavigationRailDestination(
        icon: const Icon(Icons.people_outline),
        selectedIcon: const Icon(Icons.people),
        label: Text(NavigationKeys.favorites.tr()),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(NavigationKeys.profile.tr()),
      ),
    ];
  }

  List<NavigationDestination> _getBottomNavDestinations() {
    return [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        selectedIcon: const Icon(Icons.home),
        label: NavigationKeys.home.tr(),
      ),
      NavigationDestination(
        icon: const Icon(Icons.favorite_border),
        selectedIcon: const Icon(Icons.favorite),
        label: NavigationKeys.favorites.tr(),
      ),
      NavigationDestination(
        icon: const Icon(Icons.people_outline),
        selectedIcon: const Icon(Icons.people),
        label: Home.community.tr(),
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: NavigationKeys.profile.tr(),
      ),
    ];
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return NavigationKeys.home.tr();
      case 1:
        return NavigationKeys.favorites.tr();
      case 2:
        return Home.community.tr();
      case 3:
        return NavigationKeys.profile.tr();
      default:
        return '';
    }
  }

  void _onNavItemTapped(int index) {
    setState(() => _currentIndex = index);
  }
}

// Add ProfileState extension for fullName
extension ProfileStateX on ProfileState {
  String get fullName {
    if (this is ProfileLoaded) {
      final state = this as ProfileLoaded;
      return '${state.firstName} ${state.lastName}';
    }
    return 'Guest';
  }
}
