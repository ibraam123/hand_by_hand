import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import '../logic/comments_cubit.dart';
import 'comment_tile.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isAddingComment = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Load all comments (no pagination)
    context.read<CommentsCubit>().loadComments(widget.postId);
  }

  Future<void> _addComment() async {
    if (_isAddingComment) return;

    setState(() => _isAddingComment = true);

    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _isAddingComment = false);
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() => _isAddingComment = false);
      return;
    }

    _controller.clear();

    // Use cubit to add comment
    await context.read<CommentsCubit>().addComment(widget.postId, text);

    setState(() => _isAddingComment = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  Community.comments.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => context
                      .read<CommentsCubit>()
                      .loadComments(widget.postId),
                ),
              ],
            ),
          ),

          // Comments list
          Expanded(
            child: BlocBuilder<CommentsCubit, CommentsState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CommentsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        ElevatedButton(
                          onPressed: () => context
                              .read<CommentsCubit>()
                              .loadComments(widget.postId),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CommentsLoaded) {
                  if (state.comments.isEmpty) {
                    return Center(child: Text(General.noCommentsYet.tr()));
                  }

                  return ListView.builder(
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      final createdAt = comment['createdAt'];
                      DateTime? dateTime;

                      if (createdAt != null) {
                        if (createdAt is Timestamp) {
                          dateTime = createdAt.toDate();
                        } else if (createdAt is String) {
                          dateTime = DateTime.tryParse(createdAt);
                        }
                      }

                      return CommentTile(
                        comment: comment['text'] ?? '',
                        createdAt: dateTime,
                        email: comment['userId']?.toString() ?? '',
                      );
                    },
                  );
                }

                return Center(child: Text(General.noCommentsYet.tr()));
              },
            ),
          ),

          // Add comment input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: Community.addComment.tr(),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _addComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
                  onPressed: _isAddingComment ? null : _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
