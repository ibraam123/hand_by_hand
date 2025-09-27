import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/accessible_places/presentation/views/widgets/bottom_sheet_handle.dart';
import '../../../features/accessible_places/presentation/views/widgets/custom_text_field.dart';
import '../../../features/accessible_places/presentation/views/widgets/save_button.dart';
import '../../../features/community/domain/entities/post_entity.dart';
import '../../../features/community/presenation/logic/posts_cubit.dart';


void openAddPostSheet(BuildContext context , User? user) {
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
                 Text(
                  "Add New Post",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
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
                  label: "Add",
                  icon: Icons.add,
                  onSave: () {
                    if (formKey.currentState!.validate()) {
                      final newPost = PostEntity(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        email: user?.email ?? "anonymous",
                        date: DateTime.now().toString(),
                        likes: 0,
                        commentCount: 0,
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