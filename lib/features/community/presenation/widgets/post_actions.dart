import 'package:flutter/material.dart';

class PostActions extends StatelessWidget {
  final bool hasLiked;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onCommentTap;
  final theme;
  final color;


  const PostActions({
    super.key,
    required this.hasLiked,
    required this.likes,
    required this.comments,
    this.onLike,
    this.onCommentTap,
    required this.theme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        IconButton(
          icon: Icon(
            hasLiked ? Icons.favorite : Icons.favorite_border,
            color: hasLiked ? Colors.red : color,
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
