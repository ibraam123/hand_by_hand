import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/features/home/presentation/logic/profile_cubit.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/custom_features_container.dart';

import '../../../../../core/config/routes.dart';
import '../../../../../generated/assets.dart';
import '../../../domain/feature_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<FeatureModel> featuresData = [
      FeatureModel(
        title: 'Accessible Places',
        subtitle:
        'Find places that are accessible for the disability community.',
        image: Assets.imagesF1,
        buttonText: "Explore Places",
        onPress: () {
          GoRouter.of(context).push(AppRoutes.kPlaces);
        },
      ),
      FeatureModel(
        title: 'Sign Language Lessons',
        subtitle:
        'Start your journey into sign language with our comprehensive lessons.',
        image: Assets.imagesF2,
        buttonText: "Start Learning",
        onPress: () {
          GoRouter.of(context).push(AppRoutes.kSignLanguage);
        },
      ),
      FeatureModel(
        title: 'Role Models for Disability',
        subtitle: 'Discover inspiring figures in the disability community.',
        image: Assets.imagesF3,
        buttonText: "Get Inspired",
        onPress: () {
          GoRouter.of(context).push(AppRoutes.kRoleModels);
        },
      ),
      FeatureModel(
        title: 'Community ',
        subtitle:
        'Communicate to the disability community and know about their rights.',
        image: Assets.imagesF5,
        buttonText: "Join Community",
        onPress: () {
          GoRouter.of(context).push(AppRoutes.kCommunity);
        },
      ),
    ];
    context.read<ProfileCubit>().loadProfile();
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String? firstName;
          if (state is ProfileLoading) {
            firstName = null;
          } else if (state is ProfileLoaded) {
            firstName = state.firstName;
          } else if (state is ProfileError) {
            firstName = "Error";
          }

          return ListView.builder(
            itemCount: featuresData.length + 1, // 1 for welcome message
            itemBuilder: (context, index) {
              if (index == 0) {
                // Welcome message at the top
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeMessage(context, firstName),
                    SizedBox(height: 16.h),
                  ],
                );
              }

              final feature = featuresData[index - 1];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.0.h),
                child: CustomFeaturesContainer(
                  title: feature.title,
                  subtitle: feature.subtitle,
                  image: feature.image,
                  buttonText: feature.buttonText,
                  onPress: feature.onPress,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWelcomeMessage(BuildContext context, String? firstNameUser) {
    String message;
    if (firstNameUser == null) {
      message = "Loading...";
    } else if (firstNameUser == "Error") {
      message = "Error loading profile";
    } else {
      message = "Welcome, $firstNameUser";
    }
    return Text(
      message,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
