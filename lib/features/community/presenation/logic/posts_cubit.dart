import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  DocumentSnapshot? _lastDoc;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final List<PostEntity> _posts = [];

  final Set<String> _commentedPosts = {};

  PostsCubit({
    required this.repo,
    required this.addLikeUseCase,
    required this.addCommentUseCase,
    required this.addPostUseCase,
  }) : super(PostsLoading());



  Future<void> loadPosts({int limit = 10}) async {

    emit(PostsLoading());
    _lastDoc = null;
    _hasMore = true;
    _posts.clear();

    final result = await repo.getPosts(limit: limit);
    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (posts) {
            if (posts.isEmpty) {
              _hasMore = false;
            } else {
              _lastDoc = posts.last.firestoreDoc; // ✅ Add this
            }
            _posts.addAll(posts);
        _lastDoc = posts.last.firestoreDoc;
        emit(PostsLoaded(List.from(_posts), hasMore: _hasMore));
      },
    );
  }
  Future<void> loadMorePosts({int limit = 10}) async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final result = await repo.getPosts(limit: limit, lastDoc: _lastDoc);
    result.fold(
          (failure) {
        emit(PostsError(failure.message));
      },
          (posts) {
        if (posts.isEmpty) {
          _hasMore = false;
        } else {
          // ✅ Correct: get the last document snapshot from Firestore
          final lastSnapshot = posts.last.firestoreDoc; // <-- this requires storing it in entity
          _lastDoc = lastSnapshot;
        }

        _posts.addAll(posts);
        emit(PostsLoaded(List.from(_posts), hasMore: _hasMore));
      },
    );

    _isLoadingMore = false;
  }


  Future<void> likePost(String postId) async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? 'guest';
    final currentState = state;

    if (currentState is! PostsLoaded) return;

    // Find the post in the current list
    final currentPosts = List<PostEntity>.from(currentState.posts);
    final postIndex = currentPosts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = currentPosts[postIndex];
    final isAlreadyLiked = post.likedBy.contains(currentUserEmail);

    // Optimistically update UI
    final updatedPost = post.copyWith(
      likes: isAlreadyLiked ? post.likes - 1 : post.likes + 1,
      likedBy: isAlreadyLiked
          ? (List<String>.from(post.likedBy)..remove(currentUserEmail))
          : (List<String>.from(post.likedBy)..add(currentUserEmail)),
    );

    currentPosts[postIndex] = updatedPost;
    emit(PostsLoaded(currentPosts, hasMore: currentState.hasMore));

    final result = await addLikeUseCase(postId);
    result.fold(
          (failure) {
        if (state is PostsLoaded) {
          emit(PostsActionError(failure.message, (state as PostsLoaded).posts));
        }
      },
          (data) {
        final updatedLikes = data["likes"];
        final isLiked = data["isLiked"];
        final currentUser = FirebaseAuth.instance.currentUser?.email ?? "guest";

        if (state is PostsLoaded) {
          final current = (state as PostsLoaded).posts;
          final updated = current.map((post) {
            if (post.id == postId) {
              final newLikedBy = List<String>.from(post.likedBy);
              if (isLiked) {
                newLikedBy.add(currentUser);
              } else {
                newLikedBy.remove(currentUser);
              }
              return post.copyWith(likes: updatedLikes, likedBy: newLikedBy);
            }
            return post;
          }).toList();

          emit(PostsLoaded(updated, hasMore: (state as PostsLoaded).hasMore));
        }
      },
    );

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

  Future<void> refreshPosts({int limit = 10}) async {
    await loadPosts(limit: limit);
  }

}
