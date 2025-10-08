
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../entities/post_entity.dart';

abstract class PostsRepo {
  Future<Either<Failure, void>> addPost(PostEntity post);
  Future<Either<Failure, List<PostEntity>>> getPosts(
      {
        required int limit,
        DocumentSnapshot? lastDoc,
      }
      );
  Future<Either<Failure, void>> addComment(String postId, String comment);
  Future<Either<Failure, Map<String, dynamic>>> likePost(String postId);
}