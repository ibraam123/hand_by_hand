
import '../../domain/entities/sign_lesson_entitiy.dart';
import '../../domain/repos/sign_lesson_repo.dart';
import '../data_sources/sign_language_remote_data_source.dart';

class SignLessonRepoImpl implements SignLessonRepo {
  final SignLanguageRemoteDataSource remoteDataSource;

  SignLessonRepoImpl(this.remoteDataSource);
  @override
  Future<List<SignLessonEntitiy>> getSignLessons() async {
    final models = await remoteDataSource.fetchSignLessons();
    return models;
  }
}