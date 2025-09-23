
class PostEntity {
  final String id; // important to track document id in Firestore
  final String title;
  final String email;
  final String date;
  final List<String> comments;
  final int likes;
  final int commentCount;
  final List<String> likedBy;
  PostEntity({
    required this.id,
    required this.title,
    required this.email,
    required this.date,
    required this.comments,
    required this.likes,
    required this.commentCount,
    this.likedBy = const [],
  });

  PostEntity copyWith({
    String? id,
    String? title,
    String? email,
    String? date,
    List<String>? comments,
    int? likes,
    int? commentCount,
    List<String>? likedBy,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      email: email ?? this.email,
      date: date ?? this.date,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}