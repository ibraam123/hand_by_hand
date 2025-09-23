import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/profile_option.dart';
import '../../../../../core/config/routes.dart';
import '../../logic/profile_cubit.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 60.sp, color: Colors.black),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "${state.firstName} ${state.lastName}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

                ProfileOptionTile(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kEditProfile);
                  },
                ),
                SizedBox(height: 15.h),

                ProfileOptionTile(
                  title: "Help & Support",
                  icon: Icons.help_outline,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kHelp);
                  },
                ),
                SizedBox(height: 15.h),

                ProfileOptionTile(
                  title: "Feedback",
                  icon: Icons.feedback_outlined,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kFeedback);
                  },
                ),

              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
