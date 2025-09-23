import 'package:dartz/dartz.dart';
import '../../../../core/errors/error.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repos/posts_repo.dart';
import '../data_sources/remote/home_remote.dart';
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
      comments: post.comments,
      likes: post.likes,
      commentCount: post.commentCount,
    );

    return await remote.addPost(model.toJson());
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    final result = await remote.getPosts();
    return result.fold((failure) => Left(failure), (posts) {
      final entities = posts.map((post) {
        return PostModel.fromJson(post, post["id"]);
      }).toList();
      return Right(entities);
    });
  }

  @override
  Future<Either<Failure, void>> addComment(String postId, String comment) {
    return remote.addComment(postId, comment);
  }

  @override
  Future<Either<Failure, int>> likePost(String postId) {
    return remote.likePost(postId);
  }
}
