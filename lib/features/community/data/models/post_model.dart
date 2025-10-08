import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post_entity.dart';


class PostModel extends PostEntity {

  PostModel({
    required super.id,
    required super.title,
    required super.email,
    required super.date,
    required super.likes,
    required super.commentCount,
    super.likedBy = const [],
    super.firestoreDoc,
  });

  /// Factory to create model from Firebase/JSON
  factory PostModel.fromJson(Map<String, dynamic> json, String id) {
    return PostModel(
      id: id,
      title: json['title'] as String? ?? '',
      email: json['email'] as String? ?? '',
      date: json['date'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  factory PostModel.fromFirestore(
      Map<String, dynamic> data,
      {DocumentSnapshot? snapshot}
      ){
    return PostModel(
      id: snapshot?.id ?? '',
      title: data['title'] ?? '',
      email: data['email'] ?? '',
      date: data['date'] ?? '',
      likes: data['likes'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      firestoreDoc: snapshot,
    );
  }
  /// Convert PostModel back to JSON (for saving in Firestore/API)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'email': email,
      'date': date,
      'likes': likes,
      'commentCount': commentCount,
      'likedBy': likedBy,
    };
  }
}
