
import 'package:hand_by_hand/features/auth/data/repo/user_repo.dart';
import 'package:hand_by_hand/features/auth/data/models/user_progress.dart';

class ProgressService {
  final UserRepository _userRepository;

  ProgressService(this._userRepository);

  // Update lesson progress
  Future<void> completeLesson(String userId, UserProgress currentProgress) async {
    final updatedProgress = currentProgress.copyWith(
      completedLessons: currentProgress.completedLessons + 1,
      streakDays: _calculateStreak(currentProgress.streakDays),
    );

    await _userRepository.updateProgress(userId, updatedProgress);
  }

  // Update places contribution progress
  Future<void> addContributedPlace(String userId, UserProgress currentProgress) async {
    final updatedProgress = currentProgress.copyWith(
      contributedPlaces: currentProgress.contributedPlaces + 1,
    );

    await _userRepository.updateProgress(userId, updatedProgress);
  }

  int _calculateStreak(int currentStreak) {
    // Simple streak logic - you can enhance this with date tracking
    return currentStreak + 1;
  }
}