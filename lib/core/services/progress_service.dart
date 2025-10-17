import 'package:hand_by_hand/features/auth/data/repo/user_repo.dart';
import 'package:hand_by_hand/features/auth/data/models/user_progress.dart';


class ProgressService {
  final UserRepository _userRepository;

  ProgressService(this._userRepository);

  Future<void> completeLesson(
      String userId, UserProgress currentProgress, String lessonId) async {
    // 🧠 If lesson already completed today or before — skip
    if (currentProgress.completedLessonsIds.contains(lessonId)) return;

    final now = DateTime.now();
    final updatedStreak =
    _calculateStreak(currentProgress.streakDays, currentProgress.lastLessonCompletion , now);

    final updatedProgress = currentProgress.copyWith(
      completedLessons: currentProgress.completedLessons + 1,
      completedLessonsIds: [
        ...currentProgress.completedLessonsIds,
        lessonId,
      ],
      streakDays: updatedStreak,
      lastLessonCompletion: now, // 🕓 update last lesson date
    );

    await _userRepository.updateProgress(userId, updatedProgress);
  }


  Future<void> addContributedPlace(
      String userId,
      UserProgress currentProgress,
      ) async {
    final updatedProgress = currentProgress.copyWith(
      contributedPlaces: currentProgress.contributedPlaces + 1,
    );

    await _userRepository.updateProgress(userId, updatedProgress);
  }

  int _calculateStreak(int currentStreak, DateTime? lastLessonDate , DateTime now) {
    if (lastLessonDate == null) return 1; // first ever lesson

    final lastDay = DateTime(lastLessonDate.year, lastLessonDate.month, lastLessonDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(lastDay).inDays;

    if (difference == 0) {
      // same day → no streak increase
      return currentStreak;
    } else if (difference == 1) {
      // next day → streak +1
      return currentStreak + 1;
    } else {
      // missed one or more days → reset streak
      return 1;
    }
  }
}
