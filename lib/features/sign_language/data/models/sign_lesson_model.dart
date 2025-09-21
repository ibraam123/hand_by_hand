
import 'package:hand_by_hand/features/sign_language/domain/entities/sign_lesson_entitiy.dart';

class SignLessonModel extends SignLessonEntitiy {
  SignLessonModel({
    required String title,
    required String description,
    required String imageUrl,
  }) : super(title: title, description: description, imageUrl: imageUrl);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignLessonModel &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ imageUrl.hashCode;

  @override
  String toString() {
    return 'SignLessonModel(title: $title, description: $description, imageUrl: $imageUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'titile': title,
      'descreption': description,
      'image_url': imageUrl, // keep Firestore key as snake_case
    };
  }

  factory SignLessonModel.fromMap(Map<String, dynamic> map) {
    return SignLessonModel(
      title: map['titile'] ?? '',
      description: map['descreption'] ?? '',
      imageUrl: map['image_url'] ?? '',
    );
  }
}
