
import 'package:hand_by_hand/features/sign_language/domain/entities/sign_lesson_entitiy.dart';

class SignLessonModel extends SignLessonEntitiy {
  SignLessonModel({
    required super.title,
    required super.description,
    required super.videoUrl
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignLessonModel &&
        other.title == title &&
        other.description == description &&
        other.videoUrl == videoUrl;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'SignLessonModel(title: $title, description: $description , videoUrl: $videoUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'titile': title,
      'descreption': description,
      'video_url': videoUrl
    };
  }

  factory SignLessonModel.fromMap(Map<String, dynamic> map) {
    return SignLessonModel(
      title: map['titile'] ?? '',
      description: map['descreption'] ?? '',
      videoUrl: map['video_url'] ?? ''
    );
  }
}
