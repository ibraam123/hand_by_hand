import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_constant.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../auth/data/models/user_progress.dart';
import '../../../../auth/presentation/logic/auth_cubit.dart';
import '../../logic/sign_language_cubit.dart';

class SignLanguageLessonVideoScreen extends StatefulWidget {
  const SignLanguageLessonVideoScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.description,
    required this.lessonId,
  });

  final String videoUrl;
  final String title;
  final String? description;
  final String lessonId;

  @override
  State<SignLanguageLessonVideoScreen> createState() =>
      _SignLanguageLessonVideoScreenState();
}

class _SignLanguageLessonVideoScreenState
    extends State<SignLanguageLessonVideoScreen> {
  late YoutubePlayerController _controller;
  late final ValueNotifier<bool> _isCompleted;

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    _isCompleted = ValueNotifier(false);
    _isCompleted.addListener(_onCompletionStateChanged);

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller.addListener(_videoProgressListener);
  }

  void _onCompletionStateChanged() {
    if (_isCompleted.value) {
      _markLessonAsCompleted();
    }
  }

  void _videoProgressListener() {
    final duration = _controller.metadata.duration;
    final currentPosition = _controller.value.position;

    // Mark as completed when user watches 90% of the video
    if (!_isCompleted.value &&
        duration.inSeconds > 0 &&
        currentPosition.inSeconds >= (duration.inSeconds * 0.9)) {
      _isCompleted.value = true;
     }
  }

  void _markLessonAsCompleted() {
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthSuccess) {
      final user = authState.user;
      final progress = user?.progress;

      final progressToUse = progress ?? UserProgress(
        totalLessons: AppConstant.totalLessonsCount,
        completedLessons: 0,
        streakDays: 0,
        contributedPlaces: 0,
        completedLessonsIds: [],
        lastLessonCompletion: null,
      );

      // Check if lesson is already completed
      if (progressToUse.completedLessonsIds.contains(widget.lessonId)) {
        // Already completed, show info or do nothing
        CustomSnackBar.show(
          context,
          message: "${Lessons.lessonCompleted.tr()}",
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          icon: Icons.info,
        );
        return;
      }

      context.read<SignLanguageCubit>().completeLesson(user!.id, progressToUse , widget.lessonId);

      // Show completion message
      CustomSnackBar.show(
        context,
        message: "${Lessons.lessonCompleted.tr()}",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        icon: Icons.check_circle,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoProgressListener);
    _isCompleted.removeListener(_onCompletionStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).colorScheme.primary,
        progressColors: ProgressBarColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
          bufferedColor: Theme.of(context).colorScheme.primary.withAlpha(100),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(100),
        ),
        onEnded: (data) {
          if (!_isCompleted.value) {
            _isCompleted.value = true;
          }
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "${Lessons.lesson.tr()}: ${widget.title}",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Video Player Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Video Player
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: player,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lesson Details Section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Lessons.lessonDetails.tr()}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Lesson Title
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Lesson Description
                        if (widget.description != null && widget.description!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.h),
                              Text(
                                widget.description!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),

                        // Progress Tips
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 20.w),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  '${Lessons.progressSaved.tr()}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

