import '../../domain/entities/post_entity.dart';


class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.title,
    required super.email,
    required super.date,
    required super.comments,
    required super.likes,
    required super.commentCount,
    super.likedBy = const [],
  });

  /// Factory to create model from Firebase/JSON
  factory PostModel.fromJson(Map<String, dynamic> json, String id) {
    return PostModel(
      id: id,
      title: json['title'] as String? ?? '',
      email: json['email'] as String? ?? '',
      date: json['date'] as String? ?? '',
      comments: List<String>.from(json['comments'] ?? []),
      likes: json['likes'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  /// Convert PostModel back to JSON (for saving in Firestore/API)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'email': email,
      'date': date,
      'comments': comments,
      'likes': likes,
      'commentCount': commentCount,
      'likedBy': likedBy,
    };
  }
}
