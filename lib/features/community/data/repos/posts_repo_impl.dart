import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repos/posts_repo.dart';
import '../data_sources/remote/posts_remote.dart';
import '../models/post_model.dart';

class PostsRepoImpl implements PostsRepo {
  final PostsRemote remote;

  PostsRepoImpl(this.remote);

  @override
  Future<Either<Failure, void>> addPost(PostEntity post) async {
    final model = PostModel(
      id: post.id,
      title: post.title,
      email: post.email,
      date: post.date,
      likes: post.likes,
      commentCount: post.commentCount,
    );

    return await remote.addPost(model.toJson());
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    required int limit,
    DocumentSnapshot? lastDoc,
  }
      ) async {
    final posts = await remote.getPosts(
      lastDoc: lastDoc,
      limit: limit,
    );
    return posts.fold(
      (failure) => Left(failure),
      (posts) => Right(posts),
    );
  }

  @override
  Future<Either<Failure, void>> addComment(String postId, String comment) {
    return remote.addComment(postId, comment);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> likePost(String postId) {
    return remote.likePost(postId);
  }
}
