import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repos/posts_repo.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../../domain/usecases/add_like_usecase.dart';
import '../../domain/usecases/add_post_usecase.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepo repo;
  final AddLikeUseCase addLikeUseCase;
  final AddCommentUseCase addCommentUseCase;
  final AddPostUseCase addPostUseCase;

  PostsCubit({
    required this.repo,
    required this.addLikeUseCase,
    required this.addCommentUseCase,
    required this.addPostUseCase,
  }) : super(PostsInitial());

  /// Fetch all posts
  Future<void> fetchPosts() async {
    emit(PostsLoading());
    final Either<Failure, List<PostEntity>> result = await repo.getPosts();

    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (posts) => emit(PostsLoaded(posts)),
    );
  }

  /// Like a post
  Future<void> likePost(String postId) async {
    if (state is! PostsLoaded) return;

    final currentState = state as PostsLoaded;
    final Either<Failure, int> result = await addLikeUseCase.call(postId);

    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (likes) {
        final updatedPosts = currentState.posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(likes: likes);
          }
          return post;
        }).toList();

        emit(PostsLoaded(updatedPosts));
      },
    );
  }

  /// Add comment to a post
  Future<void> addComment(String postId, String comment) async {
    if (state is! PostsLoaded) return;

    final currentState = state as PostsLoaded;
    final params = CommentParams(postId, comment);
    final Either<Failure, void> result = await addCommentUseCase.call(params);

    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (_) {
        // For simplicity, refetch all posts
        fetchPosts();
      },
    );
  }

  /// Add a new post
  Future<void> addPost(PostEntity post) async {
    if (state is! PostsLoaded) return;

    final Either<Failure, void> result = await addPostUseCase.call(post);

    result.fold(
          (failure) => emit(PostsError(failure.message)),
          (_) {
        // After adding a post, refetch all posts
        fetchPosts();
      },
    );
  }
}
