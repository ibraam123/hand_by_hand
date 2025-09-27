import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../data/data_sources/remote/home_remote.dart';

part 'comments_state.dart';


class CommentsCubit extends Cubit<CommentsState> {
  final PostsRemote postsRemote;

  CommentsCubit(this.postsRemote) : super(CommentsInitial());

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  List<Map<String, dynamic>> _allComments = [];

  Future<void> loadComments(String postId, {bool refresh = false}) async {
    if (refresh) {
      _lastDoc = null;
      _hasMore = true;
      _allComments = [];
    }

    if (!_hasMore) return;

    emit(CommentsLoading());

    final result = await postsRemote.getComments(postId, lastDoc: _lastDoc);

    result.fold(
          (failure) => emit(CommentsError(failure.message)),
          (comments) {
        if (comments.isNotEmpty) {
          // Extract the DocumentSnapshot for pagination
          _lastDoc = comments.last["snapshot"] as DocumentSnapshot?;

          // Remove snapshot from the data before adding to list
          final cleanedComments = comments.map((comment) {
            final cleaned = Map<String, dynamic>.from(comment);
            cleaned.remove('snapshot');
            return cleaned;
          }).toList();

          _allComments.addAll(cleanedComments);
        } else {
          _hasMore = false;
        }

        emit(CommentsLoaded(List.from(_allComments), hasMore: _hasMore));
      },
    );
  }

  Future<void> addComment(String postId, String comment) async {
    emit(CommentsLoading());

    final result = await postsRemote.addComment(postId, comment);

    result.fold(
          (failure) => emit(CommentsError(failure.message)),
          (_) {
        // Refresh comments after adding
        loadComments(postId, refresh: true);
      },
    );
  }
}
