import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../accessible_places/presentation/views/widgets/bottom_sheet_handle.dart';
import '../../../accessible_places/presentation/views/widgets/custom_text_field.dart';
import '../../../accessible_places/presentation/views/widgets/save_button.dart';
import '../../domain/entities/post_entity.dart';
import '../logic/posts_cubit.dart';
import '../widgets/post_card.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final user = FirebaseAuth.instance.currentUser; // Current user

  void _openAddPostSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BottomSheetHandle(),
                  const SizedBox(height: 12),
                  const Text(
                    "Add New Post",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldPlaces(
                    controller: titleController,
                    label: "Post Title",
                    icon: Icons.title,
                    validator: (v) => v!.isEmpty ? "Enter title" : null,
                  ),
                  const SizedBox(height: 20),
                  SaveButton(
                    onSave: () {
                      if (formKey.currentState!.validate()) {
                        final newPost = PostEntity(
                          id: DateTime.now().toString(),
                          title: titleController.text.trim(),
                          email: user?.email ?? "anonymous",
                          date: DateTime.now().toString(),
                          likes: 0,
                          commentCount: 0,
                          comments: const [],
                        );

                        context.read<PostsCubit>().addPost(newPost);
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "✅ Post added successfully",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            duration: Duration(seconds: 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Posts", style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No posts yet"));
          }

          final posts = snapshot.data!.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return PostEntity(
              id: doc.id,
              title: data['title'] ?? '',
              email: data['email'] ?? '',
              date: data['date'] ?? '',
              likes: data['likes'] ?? 0,
              commentCount: data['commentCount'] ?? 0,
              comments: List<String>.from(data['comments'] ?? []),
            );
          }).toList();

          return ListView.separated(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddPostSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
