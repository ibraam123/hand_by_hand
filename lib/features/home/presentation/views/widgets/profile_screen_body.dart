import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              padding: const EdgeInsets.all(16),
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.person,
                            size: 60, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${state.firstName} ${state.lastName}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Divider(
                  color: theme.dividerColor,
                  thickness: 2,
                  height: 1,
                ),
                const SizedBox(height: 24),

                ProfileOptionTile(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kEditProfile);
                  },
                ),
                const SizedBox(height: 15),

                ProfileOptionTile(
                  title: "Help & Support",
                  icon: Icons.help_outline,
                  onTap: () {
                    GoRouter.of(context).push(AppRoutes.kHelp);
                  },
                ),
                const SizedBox(height: 15),

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
