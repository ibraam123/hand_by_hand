import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

class AppRoutes {
  static const String kSplashView = '/';
  static const String kSignUpView = '/signUp';

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
    ],
  );
}
