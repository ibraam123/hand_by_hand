import 'package:flutter/material.dart';

class PostActions extends StatelessWidget {
  final bool hasLiked;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onCommentTap;

  const PostActions({
    super.key,
    required this.hasLiked,
    required this.likes,
    required this.comments,
    this.onLike,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.iconTheme.color;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.favorite ,
            color: color,
          ),
          onPressed: onLike,
        ),
        Text(likes.toString(), style: theme.textTheme.bodyMedium),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(Icons.comment, color: color),
          onPressed: onCommentTap,
        ),
        Text(comments.toString(), style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
