import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hand_by_hand/core/config/routes.dart';
import 'package:hand_by_hand/features/community/presenation/widgets/custom_option_community_container.dart';

class MainCommunityScreen extends StatelessWidget {
  const MainCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Community",
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            children: [
              CustomOptionCommunityContainer(
                title: "Chat Messaging",
                subtitle: "Chat with other users in the community",
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.kCommunityChat);
                },
              ),
              CustomOptionCommunityContainer(
                title: "Social Media Feed",
                subtitle: "Share and discover posts from the community",
                icon: Icons.group_work_outlined,
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.kCommunityPosts);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}