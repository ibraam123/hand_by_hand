import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/edit_profile_screen_body.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/help_screen.dart';
import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/sign_in_view.dart';
import '../../features/auth/presentation/views/sign_up_view.dart';
import '../../features/home/presentation/views/screens/main_screen.dart';
import '../../features/home/presentation/views/widgets/feedback_screen.dart';
import '../../features/onboarding/models/explanation_screen_model.dart';
import '../../features/onboarding/views/explanation_view.dart';
import '../../features/onboarding/views/identification_view.dart';
import '../../features/role_model/data/models/role_model.dart';
import '../../features/role_model/presenatation/views/screens/role_model_datails_screen.dart';
import '../../features/role_model/presenatation/views/screens/role_models_screen.dart';
import '../../features/sign_language/presentation/views/screens/sign_language_screen.dart';
import '../../features/splash/presentation/views/splash_view.dart';

class AppRoutes {
  static const String kSplashView = '/';
  static const String kSignUpView = '/signUp';
  static const String kSignInView = '/signIn';
  static const String kIdentificationView = '/identification';
  static const String kExplanationView = '/explanation';
  static const String kForgetPasswordView = '/forgetPassword';
  static const String kMainScreen = '/mainScreen';
  static const String kEditProfile = '/editProfile';
  static const String kFeedback = '/feedback';
  static const String kHelp = '/help';
  static const String kRoleModels = '/roleModels';
  static const String kRoleModelDetails = '/roleModelDetails';
  static const String kSignLanguage = '/signLanguage';

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
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
        path: kForgetPasswordView,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      GoRoute(
        path: kMainScreen,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: kEditProfile,
        builder: (context, state) => const EditProfileScreenBody(),
      ),
      GoRoute(
        path: kFeedback,
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: kHelp,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: kRoleModels,
        builder: (context, state) => const RoleModelsScreen(),
      ),
      GoRoute(
        path: kRoleModelDetails,
        builder: (context, state){
          final roleModel = state.extra as RoleModel;
          return RoleModelDetailsScreen(roleModel: roleModel);
        },
      ),
      GoRoute(
        path: kSignLanguage,
        builder: (context, state) => const SignLanguageScreen(),
      ),
    ],
  );
}
