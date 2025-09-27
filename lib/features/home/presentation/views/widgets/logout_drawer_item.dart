import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routes.dart';
import '../../../../auth/presentation/logic/auth_cubit.dart';

class LogoutDrawerItem extends StatelessWidget {
  const LogoutDrawerItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("Logout"),
        onTap: () {
          context.read<AuthCubit>().signOut();
          final prefs = SharedPreferences.getInstance();
          prefs.then((value) => value.clear());
          GoRouter.of(context).go(AppRoutes.kSignInView);
        },
      ),
    );
  }
}
