import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/features/sign_language/domain/entities/sign_lesson_entitiy.dart';

import '../../logic/sign_language_cubit.dart';


class SignLanguageScreen extends StatelessWidget {
  const SignLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: BlocBuilder<SignLanguageCubit, SignLanguageState>(
        builder: (context, state) {
          if (state is SignLanguageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SignLanguageLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.signLessons.length,
              itemBuilder: (context, index) {
                final signLesson = state.signLessons[index];
                return SignLessonCustomContainer(signLessonModel: signLesson);
              }
            );
          } else if (state is SignLanguageError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        }
      ),
    );
  }
}
class SignLessonCustomContainer extends StatelessWidget {
  const SignLessonCustomContainer({
    super.key,
    required this.signLessonModel,
  });

  final SignLessonEntitiy signLessonModel;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Left: Text Content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signLessonModel.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    signLessonModel.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            /// --- Right: Image
            Flexible(
              child: AspectRatio(
                aspectRatio: 1, // Ensures the image container is a square
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    signLessonModel.imageUrl,
                    fit: BoxFit.contain, // Changed to contain to show the whole image
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: screenWidth * 0.22, color: Colors.grey),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                          child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null));
                    },
                  ),
                ),),
            )
            ],
          ),
        ),
      );
  }
}
