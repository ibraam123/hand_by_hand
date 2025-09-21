import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hand_by_hand/features/home/presentation/logic/profile_cubit.dart';

import 'features/auth/presentation/logic/auth_cubit.dart';
import 'features/role_model/data/data_sources/role_model_remote_data_source.dart';
import 'features/role_model/data/repos/roole_model_repo_impl.dart';
import 'features/role_model/domain/repos/role_model_repo.dart';
import 'features/role_model/presenatation/logic/role_model_cubit.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> init() async {
  // ✅ Firebase
  serviceLocator.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // ✅ Third-party Auth
  serviceLocator.registerLazySingleton<GoogleSignIn>(
        () => GoogleSignIn.instance,
  );
  serviceLocator.registerLazySingleton<FacebookAuth>(
        () => FacebookAuth.instance,
  );

  // ✅ Data Sources
  serviceLocator.registerLazySingleton<RoleModelRemoteDataSource>(
        () => RoleModelRemoteDataSourceImpl(
      serviceLocator<FirebaseFirestore>(),
    ),
  );




  serviceLocator.registerLazySingleton<RoleModelRepository>(
        () => RoleModelRepositoryImpl(
      serviceLocator<RoleModelRemoteDataSource>(),
    ),
  );


  // ✅ Cubits / Blocs
  serviceLocator.registerFactory<AuthCubit>(
        () => AuthCubit(
      serviceLocator<FirebaseAuth>(),
      serviceLocator<FirebaseFirestore>(),
      serviceLocator<GoogleSignIn>(),
      serviceLocator<FacebookAuth>(),
    ),
  );

  serviceLocator.registerLazySingleton<ProfileCubit>(
        () => ProfileCubit(),
  );

  serviceLocator.registerFactory<RoleModelCubit>(
        () => RoleModelCubit(
      serviceLocator<RoleModelRepository>(),
    ),
  );
}
