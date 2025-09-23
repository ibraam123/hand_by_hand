import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/custom_features_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routes.dart';
import '../../../../../generated/assets.dart';
import '../../../domain/feature_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  String? _firstName;

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }

  Future<void> _loadFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName');
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FeatureModel> _featuresData = [
      FeatureModel(
        title: 'Accessible Places',
        subtitle: 'Find places that are accessible for the disability community.',
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
        onPress: (){
          GoRouter.of(context).push(AppRoutes.kSignLanguage);
        }
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
        title: 'Know More About Us',
        subtitle:
        'Discover our mission and meet inspiring figures in the deaf community.',
        image: Assets.imagesF4,
        buttonText: "Learn More",
        onPress: () {
          GoRouter.of(context).push(AppRoutes.kKnowAboutUs);
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
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: ListView(
        children: [
          _buildWelcomeMessage(_firstName),
          SizedBox(height: 16.h),
          ..._featuresData.map((feature) {
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
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage(String? firstNameUser) {
    return Text(
      firstNameUser != null
          ? "Welcome, $firstNameUser"
          : "Loading...", //TODO: ADD SKELETON LOADING
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
