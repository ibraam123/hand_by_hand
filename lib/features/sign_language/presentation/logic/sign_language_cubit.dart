import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/core/services/progress_service.dart';
import 'package:meta/meta.dart';

import '../../../auth/data/models/user_progress.dart';
import '../../domain/entities/sign_lesson_entitiy.dart';
import '../../domain/repos/sign_lesson_repo.dart';

part 'sign_language_state.dart';

class SignLanguageCubit extends Cubit<SignLanguageState> {
  SignLanguageCubit(this.signLessonRepo , this.progressService) : super(SignLanguageInitial());
  final SignLessonRepo signLessonRepo;
  final ProgressService progressService;



  Future<void> completeLesson(String userId, UserProgress currentProgress) async {
    try {
      await progressService.completeLesson(userId, currentProgress);
    } catch (e) {
      emit(SignLanguageError('Failed to complete lesson: $e'));
    }
  }



  Future<void> fetchSignLessons({
    required String langCode,
    int limit = 10,
  }) async {
    try {
      emit(SignLanguageLoading());
      final signLessons = await signLessonRepo.getSignLessons(
        langCode: langCode,
        limit: limit,
      );
      final hasMore = signLessons.isNotEmpty;

      emit(
        SignLanguageLoaded(
          signLessons,
          lastDocument: signLessons.isNotEmpty
              ? (signLessons.last as dynamic).snapshot
              : null,
          hasMore: hasMore,
        ),
      );
    } catch (e) {
      emit(SignLanguageError('Failed to fetch sign lessons: $e'));
    }
  }

  Future<void> fetchMoreSignLessons(String langCode, {int limit = 10}) async {
    final currentState = state;
    if (currentState is SignLanguageLoaded) {
      if (!currentState.hasMore || currentState.isLoadingMore) return;

      emit(
        SignLanguageLoaded(
          currentState.signLessons,
          lastDocument: currentState.lastDocument,
          hasMore: currentState.hasMore,
          isLoadingMore: true,
        ),
      );
      try {
        final newLessons = await signLessonRepo.getSignLessons(
          langCode: langCode,
          limit: limit,
          lastDocument: currentState.lastDocument,
        );
        final allLessons = [...currentState.signLessons, ...newLessons];
        final hasMore = newLessons.isNotEmpty;

        emit(
          SignLanguageLoaded(
            allLessons,
            lastDocument: newLessons.isNotEmpty
                ? (newLessons.last as dynamic).snapshot
                : currentState.lastDocument,
            hasMore: hasMore,
          ),
        );
      } catch (e) {
        emit(SignLanguageError('Failed to fetch more lessons: $e'));
      }
    }
  }
}
