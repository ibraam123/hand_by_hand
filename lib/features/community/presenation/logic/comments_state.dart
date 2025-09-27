part of 'comments_cubit.dart';

abstract class CommentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Map<String, dynamic>> comments;
  final bool hasMore;

  CommentsLoaded(this.comments, {this.hasMore = true});

  @override
  List<Object?> get props => [comments, hasMore];
}

class CommentsError extends CommentsState {
  final String message;

  CommentsError(this.message);

  @override
  List<Object?> get props => [message];
}
