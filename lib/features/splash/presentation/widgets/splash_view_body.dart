import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/app_colors.dart';
import 'package:hand_by_hand/core/config/routes.dart';
import 'package:lottie/lottie.dart';
import 'dart:async'; // Add this import

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
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(seconds: 4), _navigateAfterSplash);
  }

  Future<void> _navigateAfterSplash() async {
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    await authCubit.loadRememberMe();

    final user = FirebaseAuth.instance.currentUser;
    final rememberMeValue = authCubit.rememberMe;

    if (rememberMeValue && user != null) {
      GoRouter.of(context).go(AppRoutes.kMainScreen);
    } else {
      GoRouter.of(context).go(AppRoutes.kSignUpView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          Assets.assetsHandshakeBlue,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
        Text(
          'Hand By Hand',
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}