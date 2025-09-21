import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routes.dart';
import '../../../../auth/presentation/logic/auth_cubit.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.name, required this.email});
  final String name ;
  final String email ;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold , color: Colors.white),
            ),
            accountEmail: Text(email , style: const TextStyle(color: Colors.white)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.blue),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Logout at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                context.read<AuthCubit>().signOut();
                GoRouter.of(context).go(AppRoutes.kSignInView);
              },
            ),
          ),
        ],
      ),
    );
  }
}
