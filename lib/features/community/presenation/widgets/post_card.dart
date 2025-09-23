import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/post_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final TextEditingController _commentController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  late bool _hasLiked;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hasLiked = widget.post.likedBy.contains(currentUser?.email);
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post != oldWidget.post) {
      setState(() {
        _hasLiked = widget.post.likedBy.contains(currentUser?.email);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(widget.post.date),
    );

    return Card(
      color: Colors.grey.shade900,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + email + date
            Text(widget.post.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            Text("${widget.post.email} • $formattedDate",
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),

            // Like + comment row
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _hasLiked ? Icons.favorite : Icons.favorite_border,
                    color: _hasLiked ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    if (!_hasLiked && widget.onLike != null) {
                      widget.onLike!();
                      // No need to call setState here as didUpdateWidget will handle it
                    }
                  },
                ),
                Text(widget.post.likes.toString(), style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                const Icon(Icons.comment, color: Colors.white),
                const SizedBox(width: 4),
                Text(widget.post.commentCount.toString(), style: const TextStyle(color: Colors.white)),
              ],
            ),

            const SizedBox(height: 8),

            // Comments
            Column(
              children: widget.post.comments.map((commentData) {
                final commentText = commentData.toString();
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                     commentText,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                );
              }).toList(),
            ),

            // Add new comment input
            if (widget.onAddComment != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = _commentController.text.trim();
                      if (text.isNotEmpty) {
                        widget.onAddComment!(text);
                        _commentController.clear();
                      }
                    },
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
