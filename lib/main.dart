import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/theme.dart';
import 'package:hand_by_hand/core/config/routes.dart';
import 'package:hand_by_hand/core/utils/helper/theme_cubit.dart';
import 'package:hand_by_hand/features/community/presenation/logic/comments_cubit.dart';
import 'package:hand_by_hand/features/home/presentation/logic/favorites_cubit.dart';
import 'package:hand_by_hand/init_dependcies.dart';
import 'core/config/bloc_observer.dart';
import 'features/accessible_places/presentation/logic/place_cubit.dart';
import 'features/auth/presentation/logic/auth_cubit.dart';
import 'features/community/presenation/logic/message_cubit.dart';
import 'features/community/presenation/logic/posts_cubit.dart';
import 'features/home/presentation/logic/notifications_cubit.dart';
import 'features/home/presentation/logic/profile_cubit.dart';
import 'features/notification/firebase_api.dart';
import 'features/role_model/presenatation/logic/role_model_cubit.dart';
import 'features/sign_language/presentation/logic/sign_language_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  await init();

  final firebaseApi = serviceLocator<FirebaseApi>();
  await firebaseApi.initNotifications();
  firebaseApi.initPushNotifications();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await serviceLocator.allReady();

  runApp(
    EasyLocalization(
      child: const MyApp(),
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => serviceLocator<AuthCubit>()),
            BlocProvider(
              create: (context) =>
                  serviceLocator<ProfileCubit>(),
            ),
            BlocProvider(
              create: (context) =>
                  serviceLocator<RoleModelCubit>()..getRoleModels(),
            ),
            BlocProvider(
              create: (context) =>
                  serviceLocator<SignLanguageCubit>(),
            ),
            BlocProvider(
              create: (context) => serviceLocator<PlaceCubit>()..fetchPlaces(),
            ),
            BlocProvider(create: (context) => serviceLocator<PostsCubit>()),
            BlocProvider(create: (context) => serviceLocator<CommentsCubit>()),
            BlocProvider(
              create: (context) =>
                  serviceLocator<MessageCubit>()..loadMessages(),
            ),
            BlocProvider(
                create: (context) => serviceLocator<ThemeCubit>()
            ),
            BlocProvider(
                create: (context) => serviceLocator<FavoritesCubit>()
            ),
            BlocProvider(
                create: (context) => serviceLocator<NotificationsCubit>()
            ),
          ],
          child: const AppView(),
        );
      },
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: AppRoutes.router,
          theme: AppTheme.lightTheme,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          title: 'Hand By Hand',
        );
      },
    );
  }
}
