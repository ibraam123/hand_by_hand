class UserProgress {
  final int totalLessons;
  final int completedLessons;
  final int streakDays;
  final int contributedPlaces;

  UserProgress({
    required this.totalLessons,
    required this.completedLessons,
    required this.streakDays,
    required this.contributedPlaces,
  });

  // 🔹 progress %
  double get completionPercentage =>
      totalLessons == 0 ? 0 : (completedLessons / totalLessons) * 100;

  // 🔹 Factory from Firestore
  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      totalLessons: map['totalLessons'] ?? 0,
      completedLessons: map['completedLessons'] ?? 0,
      streakDays: map['streakDays'] ?? 0,
      contributedPlaces: map['contributedPlaces'] ?? 0,
    );
  }

  // 🔹 Convert to map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'streakDays': streakDays,
      'contributedPlaces': contributedPlaces,
    };
  }
  // In user_progress.dart - Add copyWith method
  UserProgress copyWith({
    int? totalLessons,
    int? completedLessons,
    int? streakDays,
    int? contributedPlaces,
  }) {
    return UserProgress(
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      streakDays: streakDays ?? this.streakDays,
      contributedPlaces: contributedPlaces ?? this.contributedPlaces,
    );
  }
}
