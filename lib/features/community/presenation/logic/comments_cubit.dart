import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data_sources/remote/home_remote.dart';

part 'comments_state.dart';


class CommentsCubit extends Cubit<CommentsState> {
  final PostsRemote postsRemote;

  CommentsCubit(this.postsRemote) : super(CommentsInitial());

  Future<void> loadComments(String postId) async {
    emit(CommentsLoading(isInitial: true));

    final result = await postsRemote.getComments(postId);

    result.fold(
          (failure) => emit(CommentsError(failure.message)),
          (comments) {
        // Clean snapshot if it exists
        final cleanedComments = comments.map((comment) {
          final cleaned = Map<String, dynamic>.from(comment);
          cleaned.remove('snapshot');
          return cleaned;
        }).toList();

        emit(CommentsLoaded(cleanedComments, hasMore: false));
      },
    );
  }

  Future<void> addComment(String postId, String comment) async {
    final result = await postsRemote.addComment(postId, comment);

    result.fold(
          (failure) => emit(CommentsError(failure.message)),
          (_) {
        // Refresh comments after adding
        loadComments(postId);
      },
    );
  }
}
