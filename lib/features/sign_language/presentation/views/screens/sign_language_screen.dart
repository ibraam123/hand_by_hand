import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/features/sign_language/domain/entities/sign_lesson_entitiy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/sign_language_cubit.dart';


class SignLanguageScreen extends StatelessWidget {
  const SignLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Language' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 20.sp),),
        centerTitle: true,
      ),
      body: BlocBuilder<SignLanguageCubit, SignLanguageState>(
        builder: (context, state) {
          if (state is SignLanguageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SignLanguageLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(12.w),
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
    return Card(
      elevation: 4.0.r,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
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
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    signLessonModel.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Reduced max lines for description
                  ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            /// --- Right: Image
            Flexible(
              child: AspectRatio(
                aspectRatio: 1, // Ensures the image container is a square
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0.r),
                  child: Image.network(
                    signLessonModel.imageUrl,
                    fit: BoxFit.contain, // Changed to contain to show the whole image
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 80.w, color: Colors.grey), // Adjusted size with screen util
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
