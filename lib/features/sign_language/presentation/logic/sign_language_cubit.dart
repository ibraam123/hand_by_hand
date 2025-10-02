import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/sign_lesson_entitiy.dart';
import '../../domain/repos/sign_lesson_repo.dart';

part 'sign_language_state.dart';

class SignLanguageCubit extends Cubit<SignLanguageState> {
  SignLanguageCubit(this.signLessonRepo) : super(SignLanguageInitial());
  final SignLessonRepo signLessonRepo;
  Future<void> fetchSignLessons(String langCode) async {
    try {
      emit(SignLanguageLoading());
      final signLessons = await signLessonRepo.getSignLessons(langCode);
      emit(SignLanguageLoaded(signLessons));
    } catch (e) {
      emit(SignLanguageError('Failed to fetch sign lessons: $e'));
    }
  }
}
