import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/routes.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';
import '../../../auth/presentation/logic/auth_cubit.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  Future<void> _navigateAfterSplash() async {
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();

    // Wait for auth status to be checked
    await authCubit.checkAuthStatus();

    // Give a small delay to ensure state is updated
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // Listen to the current state after checkAuthStatus completes
    final currentState = authCubit.state;

    if (currentState is AuthSuccess && currentState.user != null) {
      // User is logged in - go to main screen
      GoRouter.of(context).go(AppRoutes.kMainScreen);
    } else {
      // User is not logged in - go to sign up
      GoRouter.of(context).go(AppRoutes.kSignUpView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        Assets.assetsHandshakeBlue,
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration;
          _controller.forward().whenComplete(() {
            _navigateAfterSplash();
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}