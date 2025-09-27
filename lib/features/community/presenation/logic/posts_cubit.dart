import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/repos/posts_repo.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/add_like_usecase.dart';
import '../../domain/usecases/add_post_usecase.dart'; // Add this import

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepo repo;
  final AddLikeUseCase addLikeUseCase;
  final AddCommentUseCase addCommentUseCase;
  final AddPostUseCase addPostUseCase;

  StreamSubscription? _postsSubscription;

  PostsCubit({
    required this.repo,
    required this.addLikeUseCase,
    required this.addCommentUseCase,
    required this.addPostUseCase,
  }) : super(PostsLoading()) {
    _listenToPosts();
  }

  void _listenToPosts() {
    _postsSubscription?.cancel();

    emit(PostsLoading());

    _postsSubscription = repo.getPostsStream().listen(
          (posts) {
        emit(PostsLoaded(posts));
      },
      onError: (error) {
        emit(PostsError("Stream error: $error"));
      },
    );
  }

  Future<void> likePost(String postId) async {
    final result = await addLikeUseCase(postId);
    result.fold(
          (failure) {
        // ❌ Don’t replace PostsLoaded → instead notify user
        // Maybe use a SnackBar or keep an error flag
        emit(PostsActionError(failure.message, (state as PostsLoaded).posts));
      },
          (_) {
        // Stream handles update
      },
    );
  }

  Future<void> addComment(String postId, String comment) async {
    final result = await addCommentUseCase(CommentParams(postId, comment));
    result.fold(
          (failure) {
        emit(PostsActionError(failure.message, (state as PostsLoaded).posts));
      },
          (_) {},
    );
  }

  Future<void> addPost(PostEntity post) async {
    final result = await addPostUseCase(post);
    result.fold(
          (failure) {
        emit(PostsActionError(failure.message, (state as PostsLoaded).posts));
      },
          (_) {},
    );
  }

  void refreshPosts() {
    _listenToPosts();
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
