import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hand_by_hand/features/community/data/models/post_model.dart';

import '../../../../../core/errors/error.dart';

abstract class PostsRemote {
  Future<Either<Failure, void>> addPost(Map<String, dynamic> post);
  Future<Either<Failure, List<PostModel>>> getPosts({
    DocumentSnapshot? lastDoc,
    required int limit,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getComments(
    String postId, {
    DocumentSnapshot? lastDoc,
  });
  Future<Either<Failure, void>> addComment(String postId, String comment);
  Future<Either<Failure, Map<String, dynamic>>> likePost(String postId);
}

class PostsRemoteImpl implements PostsRemote {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  PostsRemoteImpl(this.firestore, this.firebaseAuth);

  @override
  Future<Either<Failure, void>> addPost(Map<String, dynamic> post) async {
    try {
      // Add post with commentCount = 0, likes = 0
      await firestore.collection("posts").add({
        ...post,
        "commentCount": 0,
        "likes": 0,
        "likedBy": [],
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPosts({
    DocumentSnapshot? lastDoc,
    required int limit,
  }
      ) async {
    try {
      Query query = firestore.collection("posts").limit(limit).orderBy("date",descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      final posts = snapshot.docs
          .map(
            (doc) => PostModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          snapshot: doc,
        ),
      )
          .toList();

      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getComments(
    String postId, {
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true);
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      final comments = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id,
          "text": data['text'] ?? '',
          "userId": data['userId'] ?? 'guest',
          "userEmail": data['userEmail'] ?? 'Guest',
          "createdAt": data['createdAt'],
          "snapshot": doc, // Include the DocumentSnapshot for pagination
        };
      }).toList();

      return Right(comments);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
    String postId,
    String comment,
  ) async {
    try {
      final user = firebaseAuth.currentUser;

      final postRef = firestore.collection("posts").doc(postId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) throw Exception("Post not found");

        // Add new comment in subcollection
        final commentData = {
          "text": comment,
          "userId": user?.email ?? "guest",
          "createdAt": FieldValue.serverTimestamp(),
        };

        transaction.set(postRef.collection("comments").doc(), commentData);

        // Update commentCount in post doc
        final currentCount = snapshot["commentCount"] ?? 0;
        transaction.update(postRef, {"commentCount": currentCount + 1});
      });

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> likePost(String postId) async {
    try {
      final postRef = firestore.collection("posts").doc(postId);
      final userEmail = firebaseAuth.currentUser?.email ?? 'anonymous';
      int updatedLikes = 0;
      bool isLiked = false;

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        if (!snapshot.exists) throw Exception("Post not found");

        final data = snapshot.data()!;
        final likedBy = List<String>.from(data["likedBy"] ?? []);
        final currentLikes = data["likes"] ?? 0;

        // ✅ If user already liked → Unlike (decrement)
        if (likedBy.contains(userEmail)) {
          likedBy.remove(userEmail);
          updatedLikes = currentLikes > 0 ? currentLikes - 1 : 0;
          isLiked = false;
        }
        // ✅ Else → Like (increment)
        else {
          likedBy.add(userEmail);
          updatedLikes = currentLikes + 1;
          isLiked = true;
        }

        transaction.update(postRef, {
          "likes": updatedLikes,
          "likedBy": likedBy,
        });
      });

      return Right(
        {
          "likes": updatedLikes,
          "isLiked": isLiked,
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
