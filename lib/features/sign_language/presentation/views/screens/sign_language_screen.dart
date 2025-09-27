import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/sign_language_cubit.dart';
import '../widgets/sign_lesson_container.dart';


class SignLanguageScreen extends StatelessWidget {
  const SignLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Language Lessons' , style: TextStyle(color: Theme.of(context).colorScheme.onSurface , fontWeight: FontWeight.bold),),
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
            return Center(child: Text(state.message , style: TextStyle(color: Theme.of(context).colorScheme.onSurface),));
          } else {
            return const SizedBox.shrink();
          }
        }
      ),
    );
  }
}
