import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String id;
  final String title;
  final String email;
  final String date;
  final int likes;
  final int commentCount;
  final List<String> likedBy;
  final DocumentSnapshot? firestoreDoc;


  PostEntity({
    required this.id,
    required this.title,
    required this.email,
    required this.date,
    required this.likes,
    required this.commentCount,
    this.likedBy = const [],
    this.firestoreDoc,
  });

  PostEntity copyWith({
    String? id,
    String? title,
    String? email,
    String? date,
    int? likes,
    int? commentCount,
    List<String>? likedBy,
    DocumentSnapshot? firestoreDoc,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      email: email ?? this.email,
      date: date ?? this.date,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      likedBy: likedBy ?? this.likedBy,
      firestoreDoc: firestoreDoc ?? this.firestoreDoc,
    );
  }
}