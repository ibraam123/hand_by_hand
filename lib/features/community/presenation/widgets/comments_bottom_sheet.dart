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
  final ScrollController _scrollController = ScrollController();
  bool _isAddingComment = false; // ADD: Track comment state


  @override
  void initState() {
    super.initState();
    // Load initial comments
    context.read<CommentsCubit>().loadComments(widget.postId, refresh: true);

    // Setup pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<CommentsCubit>().loadComments(widget.postId);
      }
    });
  }

  void _addComment() async {

    if (_isAddingComment) return; // ADD: Prevent multiple calls
    setState(() {
      _isAddingComment = true;
    });

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _controller.clear();

    // Use cubit to add comment
    context.read<CommentsCubit>().addComment(widget.postId, text);

  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  Community.comments.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => context
                      .read<CommentsCubit>()
                      .loadComments(widget.postId, refresh: true),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<CommentsCubit, CommentsState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                if (state is CommentsLoading && state is! CommentsLoaded) {
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
                              .loadComments(widget.postId, refresh: true),
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
                    controller: _scrollController,
                    itemCount: state.comments.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.comments.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

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
                      );
                    },
                  );
                }

                return Center(child: Text(General.noCommentsYet.tr()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: Community.addComment.tr(),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
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

