

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hand_by_hand/features/auth/logic/auth_cubit.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> init() async {
  // Firebase
  serviceLocator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  // Firebase Firestore
  serviceLocator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Cubit
  serviceLocator.registerFactory<AuthCubit>(
        () => AuthCubit(
          serviceLocator<FirebaseAuth>(),
          serviceLocator<FirebaseFirestore>(),
        ), // pass FirebaseAuth from GetIt
  );
}