import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../../../generated/assets.dart';
import '../../../auth/logic/auth_cubit.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _navigateAfterSplash();
  }

  void _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    await authCubit.loadRememberMe(); // هنا هيجيب القيمة من SharedPreferences

    final user = FirebaseAuth.instance.currentUser;
    final rememberMeValue = authCubit.rememberMe; // القيمة اللي محملة من الكيوبت

    if (rememberMeValue && user != null) {
      GoRouter.of(context).go(AppRoutes.kIdentificationView);
    } else {
      GoRouter.of(context).go(AppRoutes.kSignUpView);
    }
  }


  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    // Start rotation from 0 (left) to pi (right, 180 degrees)
    _rotateAnimation = Tween<double>(begin: math.pi, end: 0)
        .animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeTransition(
          opacity: _fadeAnimation, // Use the fade animation
          child: AnimatedBuilder(
            animation: _rotateAnimation, // Use the rotate animation
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(_rotateAnimation.value), // Rotate around Y-axis for horizontal rotation
                child: child, // The widget to rotate
              );
            },
            child: Image.asset(
              Assets.imagesLogoImage, // Your logo image
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
            ), // Responsive width
          ),
        ),
      ],
    );
  }
}