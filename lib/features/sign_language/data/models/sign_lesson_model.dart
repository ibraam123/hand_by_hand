import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_by_hand/features/sign_language/domain/entities/sign_lesson_entitiy.dart';

class SignLessonModel extends SignLessonEntitiy {
  final DocumentSnapshot? snapshot; // keep a reference for pagination

  SignLessonModel({
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.type,
    this.snapshot,
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
    return {'titile': title, 'descreption': description, 'video_url': videoUrl};
  }

  factory SignLessonModel.fromMap(Map<String, dynamic> map, String langCode , {DocumentSnapshot? snapshot}) {
    String parseField(dynamic field) {
      if (field == null) return '';
      if (field is String) return field;
      if (field is Map) {
        return field[langCode] ?? field['en'] ?? field.values.first.toString();
      }
      return field.toString();
    }

    return SignLessonModel(
      title: parseField(map['title'] ?? map['titile']), // handle typo too
      description: parseField(map['description'] ?? map['descreption']),
      videoUrl: map['video_url'] ?? '',
      type: map['type'] ?? '',
      snapshot: snapshot,
    );
  }
}
