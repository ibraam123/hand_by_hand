



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_option.dart';
import 'package:hand_by_hand/features/auth/presentation/logic/auth_cubit.dart';

import '../../../../../core/config/app_keys_localization.dart';
import '../../../../../core/config/routes.dart';
import '../../../../auth/data/models/user_progress.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return SafeArea(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          debugPrint('Auth State: ${authState.runtimeType}');


          // Show loading only for specific states, not for AuthSuccess
          if (authState is AuthLoading || authState is AuthInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authState is AuthError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.r, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Authentication Error',
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    authState.errorMessage,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().checkAuthStatus(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }


          if (authState is AuthUnauthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64.r),
                  SizedBox(height: 16.h),
                  Text(
                    'Welcome Back!',
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please sign in to continue',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => GoRouter.of(context).push(AppRoutes.kSignInView),
                    child: Text('Sign In'),
                  ),
                ],
              ),
            );
          }

          if (authState is AuthSuccess && authState.user != null) {
            final user = authState.user!;
            final progress = user.progress;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.all(16.w),
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundColor: isDark
                            ? theme.colorScheme.surface
                            : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          size: 60.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
                Divider(
                  color: theme.dividerColor,
                  thickness: 2.h,
                  height: 1.h,
                ),
                SizedBox(height: 24.h),

                // Profile Options
                ProfileOptionTile(
                  title: Profile.editProfile.tr(),
                  icon: Icons.edit,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kEditProfile);
                  },
                ),
                SizedBox(height: 15.h),

                ProfileOptionTile(
                  title: Profile.helpSupport.tr(),
                  icon: Icons.help_outline,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kHelp);
                  },
                ),
                SizedBox(height: 15.h),

                ProfileOptionTile(
                  title: Profile.feedback.tr(),
                  icon: Icons.feedback_outlined,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kFeedback);
                  },
                ),

                if (progress != null) ...[
                  SizedBox(height: 24.h),
                  _buildProgressCard(context, progress),
                ],
              ],
            );
          } else {
            return const SizedBox.shrink();
          }

        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, UserProgress progress) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  color: theme.colorScheme.primary,
                  size: 24.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Learning Progress',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Progress Percentage
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completion',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${progress.completionPercentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                // Circular Progress Indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: CircularProgressIndicator(
                        value: progress.completionPercentage / 100,
                        strokeWidth: 6.w,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      '${progress.completedLessons}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Progress Bar
            LinearProgressIndicator(
              value: progress.completionPercentage / 100,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              minHeight: 8.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            SizedBox(height: 16.h),

            // Stats Grid
            _buildStatsGrid(context, progress),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, UserProgress progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          '${progress.completedLessons}',
          'Lessons\nCompleted',
          Icons.play_lesson,
        ),
        _buildStatItem(
          context,
          '${progress.streakDays}',
          'Day\nStreak',
          Icons.local_fire_department,
        ),
        _buildStatItem(
          context,
          '${progress.contributedPlaces}',
          'Places\nAdded',
          Icons.place,
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20.w,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/*





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_option.dart';

import '../../../../../core/config/app_keys_localization.dart';
import '../../../../../core/config/routes.dart';
import '../../logic/profile_cubit.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(16.w),
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundColor: isDark
                            ? theme.colorScheme.surface
                            : theme.colorScheme.onSurface.withValues(
                          green: 0.2,
                          red: 0.2,
                          blue: 0.2,
                          alpha: 0.2,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "${state.firstName} ${state.lastName}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Divider(
                  color: theme.dividerColor,
                  thickness: 2.h,
                  height: 1.h,
                ),
                SizedBox(height: 24.h),

                // ✅ استخدم مفاتيح الـ abstract class مع .tr()
                ProfileOptionTile(
                  title: Profile.editProfile.tr(),
                  icon: Icons.edit,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kEditProfile);
                  },
                ),
                SizedBox(height: 15.h),

                ProfileOptionTile(
                  title: Profile.helpSupport.tr(),
                  icon: Icons.help_outline,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kHelp);
                  },
                ),
                SizedBox(height: 15.h),

                ProfileOptionTile(
                  title: Profile.feedback.tr(),
                  icon: Icons.feedback_outlined,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kFeedback);
                  },
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

*/
/**
 * import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:flutter_screenutil/flutter_screenutil.dart';
    import 'package:go_router/go_router.dart';
    import 'package:easy_localization/easy_localization.dart';
    import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_option.dart';
    import 'package:hand_by_hand/features/auth/presentation/logic/auth_cubit.dart';

    import '../../../../../core/config/app_keys_localization.dart';
    import '../../../../../core/config/routes.dart';
    import '../../../../auth/data/models/user_progress.dart';
    import '../../logic/profile_cubit.dart';

    class ProfileScreenBody extends StatelessWidget {
    const ProfileScreenBody({super.key});

    @override
    Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
    child: BlocBuilder<AuthCubit, AuthState>(
    builder: (context, authState) {
    if (authState is AuthSuccess) {
    return BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, profileState) {
    if (profileState is ProfileLoading) {
    return const Center(child: CircularProgressIndicator());
    } else if (profileState is ProfileLoaded) {
    final user = authState.user;
    final progress = user?.progress;

    return ListView(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    padding: EdgeInsets.all(16.w),
    children: [
    // Profile header
    Center(
    child: Column(
    children: [
    CircleAvatar(
    radius: 45.r,
    backgroundColor: isDark
    ? theme.colorScheme.surface
    : theme.colorScheme.onSurface.withValues(alpha: 0.2),
    child: Icon(
    Icons.person,
    size: 60.sp,
    color: theme.colorScheme.onSurface,
    ),
    ),
    SizedBox(height: 12.h),
    Text(
    "${profileState.firstName} ${profileState.lastName}",
    style: theme.textTheme.headlineSmall?.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
    ),
    ),
    SizedBox(height: 8.h),
    Text(
    user!.email,
    style: theme.textTheme.bodyMedium?.copyWith(
    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    ),
    ),
    ],
    ),
    ),

    // Progress Card
    if (progress != null) ...[
    SizedBox(height: 24.h),
    _buildProgressCard(context, progress),
    ],

    SizedBox(height: 24.h),
    Divider(
    color: theme.dividerColor,
    thickness: 2.h,
    height: 1.h,
    ),
    SizedBox(height: 24.h),

    // Profile Options
    ProfileOptionTile(
    title: Profile.editProfile.tr(),
    icon: Icons.edit,
    onTap: () {
    GoRouter.of(context).push(AppRoutes.kEditProfile);
    },
    ),
    SizedBox(height: 15.h),

    ProfileOptionTile(
    title: Profile.helpSupport.tr(),
    icon: Icons.help_outline,
    onTap: () {
    GoRouter.of(context).push(AppRoutes.kHelp);
    },
    ),
    SizedBox(height: 15.h),

    ProfileOptionTile(
    title: Profile.feedback.tr(),
    icon: Icons.feedback_outlined,
    onTap: () {
    GoRouter.of(context).push(AppRoutes.kFeedback);
    },
    ),
    ],
    );
    } else if (profileState is ProfileError) {
    return Center(
    child: Text(
    profileState.message,
    style: theme.textTheme.bodyMedium?.copyWith(
    color: theme.colorScheme.error,
    ),
    ),
    );
    }
    return const SizedBox.shrink();
    },
    );
    }
    return const Center(child: CircularProgressIndicator());
    },
    ),
    );
    }

    Widget _buildProgressCard(BuildContext context, UserProgress progress) {
    final theme = Theme.of(context);

    return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.r),
    ),
    child: Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Header
    Row(
    children: [
    Icon(
    Icons.emoji_events_outlined,
    color: theme.colorScheme.primary,
    size: 24.w,
    ),
    SizedBox(width: 8.w),
    Text(
    'Learning Progress',
    style: theme.textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
    ),
    ),
    ],
    ),
    SizedBox(height: 16.h),

    // Progress Percentage
    Row(
    children: [
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Completion',
    style: theme.textTheme.bodyMedium?.copyWith(
    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    ),
    ),
    SizedBox(height: 4.h),
    Text(
    '${progress.completionPercentage.toStringAsFixed(1)}%',
    style: theme.textTheme.headlineSmall?.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.primary,
    ),
    ),
    ],
    ),
    ),
    SizedBox(width: 16.w),
    // Circular Progress Indicator
    Stack(
    alignment: Alignment.center,
    children: [
    SizedBox(
    width: 60.w,
    height: 60.h,
    child: CircularProgressIndicator(
    value: progress.completionPercentage / 100,
    strokeWidth: 6.w,
    backgroundColor: theme.colorScheme.surfaceContainerHighest,
    valueColor: AlwaysStoppedAnimation<Color>(
    theme.colorScheme.primary,
    ),
    ),
    ),
    Text(
    '${progress.completedLessons}',
    style: TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
    ),
    ),
    ],
    ),
    ],
    ),
    SizedBox(height: 16.h),

    // Progress Bar
    LinearProgressIndicator(
    value: progress.completionPercentage / 100,
    backgroundColor: theme.colorScheme.surfaceContainerHighest,
    valueColor: AlwaysStoppedAnimation<Color>(
    theme.colorScheme.primary,
    ),
    minHeight: 8.h,
    borderRadius: BorderRadius.circular(4.r),
    ),
    SizedBox(height: 16.h),

    // Stats Grid
    _buildStatsGrid(context, progress),
    ],
    ),
    ),
    );
    }

    Widget _buildStatsGrid(BuildContext context, UserProgress progress) {
    final theme = Theme.of(context);

    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    _buildStatItem(
    context,
    '${progress.completedLessons}',
    'Lessons\nCompleted',
    Icons.play_lesson,
    ),
    _buildStatItem(
    context,
    '${progress.streakDays}',
    'Day\nStreak',
    Icons.local_fire_department,
    ),
    _buildStatItem(
    context,
    '${progress.contributedPlaces}',
    'Places\nAdded',
    Icons.place,
    ),
    ],
    );
    }

    Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    final theme = Theme.of(context);

    return Column(
    children: [
    Container(
    padding: EdgeInsets.all(8.w),
    decoration: BoxDecoration(
    color: theme.colorScheme.primary.withValues(alpha: 0.1),
    shape: BoxShape.circle,
    ),
    child: Icon(
    icon,
    size: 20.w,
    color: theme.colorScheme.primary,
    ),
    ),
    SizedBox(height: 8.h),
    Text(
    value,
    style: theme.textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.colorScheme.onSurface,
    ),
    ),
    SizedBox(height: 4.h),
    Text(
    label,
    textAlign: TextAlign.center,
    style: theme.textTheme.bodySmall?.copyWith(
    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
    ),
    ),
    ],
    );
    }
    }
 * */
