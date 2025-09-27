import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/routes.dart';

import '../../../../generated/assets.dart';
import '../../../auth/presentation/logic/auth_cubit.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    await authCubit.loadRememberMe(); // هنا هيجيب القيمة من SharedPreferences

    final user = FirebaseAuth.instance.currentUser;
    final rememberMeValue = authCubit.rememberMe; // القيمة اللي محملة من الكيوبت

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          Assets.imagesHandshakeSvgrepoCom,
        ), // Responsive width
      ],
    );
  }
}