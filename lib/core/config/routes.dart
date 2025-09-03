import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/sign_in_view.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/onboarding/views/identification_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

class AppRoutes {
  static const String kSplashView = '/';
  static const String kSignUpView = '/signUp';
  static const String kSignInView = '/signIn';
  static const String kIdentificationView = '/identification';

  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kSignUpView,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: kSignInView,
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: kIdentificationView,
        builder: (context, state) => const IdentificationView(),
      ),
    ],
  );
}
