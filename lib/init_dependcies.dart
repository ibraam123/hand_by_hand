import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hand_by_hand/core/utils/helper/theme_cubit.dart';
import 'package:hand_by_hand/features/accessible_places/domain/repos/place_repo.dart';
import 'package:hand_by_hand/features/community/data/data_sources/remote/home_remote.dart';
import 'package:hand_by_hand/features/community/presenation/logic/comments_cubit.dart';
import 'package:hand_by_hand/features/community/presenation/logic/message_cubit.dart';
import 'package:hand_by_hand/features/community/presenation/logic/posts_cubit.dart';
import 'package:hand_by_hand/features/home/presentation/logic/profile_cubit.dart';
import 'package:hand_by_hand/features/notification/data/local_data_source/notification_local_data_source.dart';
import 'package:hand_by_hand/features/notification/data/models/notification_model.dart';
import 'package:hand_by_hand/features/sign_language/domain/repos/sign_lesson_repo.dart';
import 'package:hive_flutter/adapters.dart';

import 'features/accessible_places/data/repos/place_repo_impl.dart';
import 'features/accessible_places/presentation/logic/place_cubit.dart';
import 'features/auth/presentation/logic/auth_cubit.dart';
import 'features/community/data/repos/messages_repo.dart';
import 'features/community/data/repos/posts_repo_impl.dart';
import 'features/community/domain/repos/posts_repo.dart';
import 'features/community/domain/usecases/add_comment_usecase.dart';
import 'features/community/domain/usecases/add_like_usecase.dart';
import 'features/community/domain/usecases/add_post_usecase.dart';
import 'features/notification/firebase_api.dart';
import 'features/role_model/data/data_sources/role_model_remote_data_source.dart';
import 'features/role_model/data/repos/roole_model_repo_impl.dart';
import 'features/role_model/domain/repos/role_model_repo.dart';
import 'features/role_model/presenatation/logic/role_model_cubit.dart';
import 'features/sign_language/data/data_sources/sign_language_remote_data_source.dart';
import 'features/sign_language/data/repos/sign_lesson_repo_impl.dart';
import 'features/sign_language/presentation/logic/sign_language_cubit.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();

  Hive.registerAdapter(NotificationModelAdapter());

  await Hive.openBox<bool>('favorites');
  await Hive.openBox<NotificationModel>('notifications');

  serviceLocator.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(),
  );

  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(localDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<FirebaseApi>(
    () => FirebaseApi(localDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<CommunityChatRepository>(
    () => CommunityChatRepositoryImpl(
      serviceLocator<FirebaseFirestore>(),
      serviceLocator<FirebaseAuth>(),
    ),
  );

  serviceLocator.registerFactory<MessageCubit>(
    () => MessageCubit(serviceLocator<CommunityChatRepository>()),
  );

  serviceLocator.registerFactory<CommentsCubit>(
    () => CommentsCubit(serviceLocator<PostsRemote>()),
  );

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
  // ✅ Data Sources
  serviceLocator.registerLazySingleton<RoleModelRemoteDataSource>(
    () => RoleModelRemoteDataSourceImpl(serviceLocator<FirebaseFirestore>()),
  );
  serviceLocator.registerLazySingleton<SignLanguageRemoteDataSource>(
    () => SignLanguageRemoteDataSourceImpl(serviceLocator<FirebaseFirestore>()),
  );

  serviceLocator.registerLazySingleton<RoleModelRepository>(
    () => RoleModelRepositoryImpl(serviceLocator<RoleModelRemoteDataSource>()),
  );

  serviceLocator.registerLazySingleton<SignLessonRepo>(
    () => SignLessonRepoImpl(serviceLocator<SignLanguageRemoteDataSource>()),
  );

  serviceLocator.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(serviceLocator<FirebaseFirestore>()),
  );

  // ✅ Cubits / Blocs
  serviceLocator.registerFactory<AuthCubit>(
    () => AuthCubit(
      serviceLocator<FirebaseAuth>(),
      serviceLocator<FirebaseFirestore>(),
      serviceLocator<GoogleSignIn>(),
    ),
  );

  serviceLocator.registerLazySingleton<ProfileCubit>(() => ProfileCubit());

  serviceLocator.registerLazySingleton<PostsRemote>(
    () => PostsRemoteImpl(serviceLocator<FirebaseFirestore>()),
  );
  serviceLocator.registerLazySingleton<PostsRepo>(
    () => PostsRepoImpl(serviceLocator<PostsRemote>()),
  );
  serviceLocator.registerLazySingleton<AddLikeUseCase>(
    () => AddLikeUseCase(serviceLocator<PostsRepo>()),
  );
  serviceLocator.registerLazySingleton<AddCommentUseCase>(
    () => AddCommentUseCase(serviceLocator<PostsRepo>()),
  );
  serviceLocator.registerLazySingleton<AddPostUseCase>(
    () => AddPostUseCase(serviceLocator<PostsRepo>()),
  );

  serviceLocator.registerFactory<PostsCubit>(
    () => PostsCubit(
      repo: serviceLocator<PostsRepo>(),
      addLikeUseCase: serviceLocator<AddLikeUseCase>(),
      addCommentUseCase: serviceLocator<AddCommentUseCase>(),
      addPostUseCase: serviceLocator<AddPostUseCase>(),
    ),
  );

  serviceLocator.registerFactory<RoleModelCubit>(
    () => RoleModelCubit(serviceLocator<RoleModelRepository>()),
  );

  serviceLocator.registerFactory<SignLanguageCubit>(
    () => SignLanguageCubit(serviceLocator<SignLessonRepo>()),
  );

  serviceLocator.registerFactory<PlaceCubit>(
    () => PlaceCubit(serviceLocator<PlaceRepository>()),
  );

  serviceLocator.registerFactory<ThemeCubit>(
    () => ThemeCubit(),
  );
}
