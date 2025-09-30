import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';

import '../../../../core/utils/helper/open_add_post_sheet.dart';
import '../logic/posts_cubit.dart';
import '../widgets/post_card.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  User? get user => FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          Community.post.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostsCubit>().refreshPosts(),
          ),
        ],
      ),
      body: BlocConsumer<PostsCubit, PostsState>(
        listener: (context, state) {
          if (state is PostsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: TextStyle(color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PostsCubit>().refreshPosts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PostsLoaded) {
            final posts = state.posts;

            if (posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.feed, size: 64, color: Colors.grey), // Consider using theme.colorScheme.secondary
                    const SizedBox(height: 16),
                    Text(
                      General.noPostsYet.tr(),
                      style: TextStyle(fontSize: 18, color: Colors.grey), // Consider using theme.colorScheme.secondary
                    ),
                    Text(
                      General.beTheFirstToShare.tr(),
                      style: TextStyle(color: Colors.grey), // Consider using theme.colorScheme.secondary
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostsCubit>().refreshPosts();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    post: post,
                    onLike: () {
                      context.read<PostsCubit>().likePost(post.id);
                    },
                    onAddComment: (comment) {
                      context.read<PostsCubit>().addComment(post.id, comment);
                    },
                  );
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddPostSheet(context , user),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
