import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/features/sign_language/presentation/views/widgets/sign_lesson_container.dart';

import '../../../domain/entities/sign_lesson_entitiy.dart';


class LessonsList extends StatelessWidget {
  final ScrollController _scrollController;
  final List<SignLessonEntitiy> lessons;
  final bool hasMore;

  const LessonsList({
    super.key,
    required ScrollController scrollController,
    required this.lessons,
    required this.hasMore,
  }) : _scrollController = scrollController;

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 64, color: Colors.grey.shade400),
            SizedBox(height: 12.h),
            Text(
              "No lessons available",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(12.w),
      itemCount: hasMore ? lessons.length + 1 : lessons.length,
      itemBuilder: (context, index) {
        if (index >= lessons.length) {
          // Bottom loader
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final signLesson = lessons[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: SignLessonCustomContainer(signLessonModel: signLesson),
          ),
        );
      },
    );
  }
}
