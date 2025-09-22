import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/theme.dart';
import 'package:hand_by_hand/core/config/routes.dart';
import 'package:hand_by_hand/init_dependcies.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'features/accessible_places/presentation/logic/place_cubit.dart';
import 'features/auth/presentation/logic/auth_cubit.dart';
import 'features/home/presentation/logic/profile_cubit.dart';
import 'features/role_model/presenatation/logic/role_model_cubit.dart';
import 'features/sign_language/presentation/logic/sign_language_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await Hive.openBox<bool>('favorites');

  await serviceLocator.allReady();
  runApp(const MyApp());
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
            BlocProvider(create: (context) => serviceLocator<ProfileCubit>()..loadProfile()),
            BlocProvider(create: (context) => serviceLocator<RoleModelCubit>()..getRoleModels()),
            BlocProvider(create: (context) => serviceLocator<SignLanguageCubit>()..fetchSignLessons()),
            BlocProvider(create: (context) => serviceLocator<PlaceCubit>()..fetchPlaces()),
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
    return MaterialApp.router(
      routerConfig: AppRoutes.router,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
