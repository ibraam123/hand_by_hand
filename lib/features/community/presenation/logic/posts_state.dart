part of 'posts_cubit.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  final bool hasMore;
  PostsLoaded(this.posts , {this.hasMore = true});
}
class PostsActionError extends PostsState {
  final String message;
  final List<PostEntity> posts; // keep old posts
  PostsActionError(this.message, this.posts);
}

final class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
}

