
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/errors/error.dart';

abstract class PostsRemote {
  Future<Either<Failure, void>> addPost(Map<String, dynamic> post);
  Future<Either<Failure, List<Map<String, dynamic>>>> getPosts();
  Future<Either<Failure, void>> addComment(String postId, String comment);
  Future<Either<Failure, int>> likePost(String postId);
}

class PostsRemoteImpl implements PostsRemote {
  final FirebaseFirestore firestore;
  PostsRemoteImpl(this.firestore);


  @override
  Future<Either<Failure, void>> addPost(Map<String, dynamic> post) async {
    try {
      await firestore.collection("posts").add(post);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPosts() async {
    try {
      final snapshot = await firestore.collection("posts").get();
      final posts = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          ...data,
        };
      }).toList();
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> addComment(String postId, String comment) async {
    try {
      final postRef = firestore.collection("posts").doc(postId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);

        final data = snapshot.data();
        if (data == null) throw Exception("Post not found");

        final currentComments = List<String>.from(data["comments"] ?? []);
        final currentCount = data["commentCount"] ?? 0;

        currentComments.add(comment);

        transaction.update(postRef, {
          "comments": currentComments,
          "commentCount": currentCount + 1,
        });
      });

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @override
  Future<Either<Failure, int>> likePost(String postId) async {
    try {
      final postRef = firestore.collection("posts").doc(postId);
      final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
      int updatedLikes = 0;

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        final data = snapshot.data();
        if (data == null) throw Exception("Post not found");

        // Get the likedBy list
        final likedBy = List<String>.from(data["likedBy"] ?? []);

        // Check if current user already liked
        if (likedBy.contains(userEmail)) {
          updatedLikes = data["likes"] ?? 0; // No change
          return;
        }

        // Add user to likedBy
        likedBy.add(userEmail);
        updatedLikes = (data["likes"] ?? 0) + 1;

        transaction.update(postRef, {
          "likes": updatedLikes,
          "likedBy": likedBy,
        });
      });

      return Right(updatedLikes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

