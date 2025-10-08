import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_screen_body.dart';
import '../../logic/profile_cubit.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorites_screen_body.dart';
import '../widgets/home_screen_body.dart';
import '../widgets/notification_screen_body.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/config/app_keys_localization.dart'; // فيه NavigationKeys

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  static const List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    NotificationsScreen(),
    ProfileScreenBody(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Load profile through Cubit, not directly here
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          drawer: isTablet ? null : _buildDrawer(),
          appBar: _buildAppBar(isTablet),
          body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
          bottomNavigationBar: isTablet ? null : _buildBottomNav(),
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
          onDestinationSelected: _onTabChanged,
          labelType: NavigationRailLabelType.all,
          destinations: _getNavDestinations(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _screens[_currentIndex],
        ),
      ],
    );
  }

  // Mobile layout with bottom navigation
  Widget _buildMobileLayout() {
    return PageView(
      controller: _pageController,
      onPageChanged: _onTabChanged,
      children: _screens,
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
          return CustomDrawer(
            name: state.fullName,
            email: state.email ?? '',
          );
        }
        return const CustomDrawer(name: 'Guest', email: '');
      },
    );
  }

  Widget _buildBottomNav() {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final showText = width > 360;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: theme.colorScheme.shadow.withValues(alpha: .1),
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: GNav(
        selectedIndex: _currentIndex,
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
        padding: EdgeInsets.symmetric(horizontal: showText ? 16.w : 10.w, vertical: 12.h),
        gap: showText ? 8.w : 0,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        tabMargin: EdgeInsets.symmetric(horizontal: 4.w),
        onTabChange: _onTabChanged,
        tabs: _getNavTabs(),
      ),
    );
  }

  List<GButton> _getNavTabs() {
    return [
      GButton(icon: Icons.home_outlined, text: NavigationKeys.home.tr()),
      GButton(icon: Icons.favorite_border, text: NavigationKeys.favorites.tr()),
      GButton(icon: Icons.notifications_outlined, text: NavigationKeys.notifications.tr()),
      GButton(icon: Icons.person_outline, text: NavigationKeys.profile.tr()),
    ];
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
      NavigationRailDestination(
        icon: const Icon(Icons.notifications_outlined),
        selectedIcon: const Icon(Icons.notifications),
        label: Text(NavigationKeys.notifications.tr()),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(NavigationKeys.profile.tr()),
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
        return NavigationKeys.notifications.tr();
      case 3:
        return NavigationKeys.profile.tr();
      default:
        return '';
    }
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    if (_pageController.hasClients) {
      _pageController.jumpToPage(index); // immediate switch
    }
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