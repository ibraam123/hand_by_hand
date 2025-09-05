import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/sign_in_view.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/onboarding/models/explanation_screen_model.dart';
import '../../features/onboarding/views/explanation_view.dart';
import '../../features/onboarding/views/identification_view.dart';
import '../../features/onboarding/views/options_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

class AppRoutes {
  static const String kSplashView = '/';
  static const String kSignUpView = '/signUp';
  static const String kSignInView = '/signIn';
  static const String kIdentificationView = '/identification';
  static const String kExplanationView = '/explanation';
  static const String kOptionsView = '/options';
  static const String kForgetPasswordView = '/forgetPassword';

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
      GoRoute(
        path: kExplanationView,
        builder: (context, state) {
          final model = state.extra as ExplanationScreenModel;
          return ExplanationView(explanationScreenModel: model);
        },
      ),
      GoRoute(
        path: kOptionsView,
        builder: (context, state) => const OptionsView(),
      ),
      GoRoute(
        path: kForgetPasswordView,
        builder: (context, state) => const ForgetPasswordView(),
      ),
    ],
  );
}
