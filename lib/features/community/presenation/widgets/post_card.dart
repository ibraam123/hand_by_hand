import 'package:flutter/material.dart';
import 'package:hand_by_hand/features/community/presenation/widgets/post_actions.dart';
import 'package:hand_by_hand/features/community/presenation/widgets/post_header.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/tts_service.dart';
import '../../domain/entities/post_entity.dart';
import 'comments_bottom_sheet.dart';

class PostCard extends StatefulWidget {
  final PostEntity post;
  final VoidCallback? onLike;
  final Function(String)? onAddComment;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onAddComment,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late bool _hasLiked;
  int _localCommentCount = 0;


  @override
  void initState() {
    super.initState();
    _hasLiked = widget.post.likedBy.contains(currentUser?.email);
    _localCommentCount = widget.post.commentCount;
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post != oldWidget.post) {
      _hasLiked = widget.post.likedBy.contains(currentUser?.email);
      _localCommentCount = widget.post.commentCount;
    }
  }

  void _openCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CommentsBottomSheet(
        postId: widget.post.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(widget.post.date),
    );

    return Card(
      color: theme.cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              title: widget.post.title,
              email: widget.post.email,
              date: formattedDate,
            ),
            const SizedBox(height: 12),
            PostActions(
              hasLiked: _hasLiked,
              likes: widget.post.likes,
              comments: _localCommentCount,
              onLike: () {
                if (!_hasLiked && widget.onLike != null) {
                  setState(() => _hasLiked = true);
                  widget.onLike!();
                }
              },
              onCommentTap: () => _openCommentsSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}