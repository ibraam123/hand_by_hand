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
  final Set<String> _likedPosts = {};
  final Set<String> _commentedPosts = {};

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
            if (isClosed) return; // ADD: Safety check
        emit(PostsLoaded(posts));
      },
      onError: (error) {
        emit(PostsError("Stream error: $error"));
      },
    );
  }

  Future<void> likePost(String postId) async {
    // ADD: Prevent duplicate likes
    if (_likedPosts.contains(postId)) return;
    _likedPosts.add(postId);

    try {
      final result = await addLikeUseCase(postId);
      result.fold(
            (failure) {
          if (state is PostsLoaded) {
            emit(PostsActionError(failure.message, (state as PostsLoaded).posts));
          }
        },
            (_) {
          // Stream handles update
        },
      );
    } finally {
      _likedPosts.remove(postId); // ADD: Always remove from tracking
    }
  }

  Future<void> addComment(String postId, String comment) async {
    // ADD: Prevent duplicate comments
    if (_commentedPosts.contains(postId)) return;
    _commentedPosts.add(postId);

    try {
      final result = await addCommentUseCase(CommentParams(postId, comment));
      result.fold(
            (failure) {
          if (state is PostsLoaded) {
            emit(PostsActionError(failure.message, (state as PostsLoaded).posts));
          }
        },
            (_) {},
      );
    } finally {
      _commentedPosts.remove(postId);
    }
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
