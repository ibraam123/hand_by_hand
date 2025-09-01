import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/routes.dart';

import '../../../../generated/assets.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 10), () {
      GoRouter.of(context).go(AppRoutes.kSignUpView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(
            Assets.imagesLogoImage,
            width: MediaQuery.of(context).size.width * 0.7, // Responsive width
            height: MediaQuery.of(context).size.width * 0.7, // Maintain aspect ratio
            fit: BoxFit.contain, // Ensure the entire image is visible
          ),
        ),
      ],
    );
  }
}