import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/features/home/presentation/logic/profile_cubit.dart';
import 'package:hand_by_hand/features/home/presentation/views/widgets/custom_features_container.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/config/routes.dart';
import '../../../../../generated/assets.dart';
import '../../../domain/entities/feature_model.dart';
import '../../../../../core/config/app_keys_localization.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late final List<FeatureModel> _features;

  @override
  void initState() {
    super.initState();
    _initializeFeatures();
    // Load once, not on every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadProfile();
    });
  }

  void _initializeFeatures() {
    _features = [
      FeatureModel(
        title: Home.accessiblePlaces,
        subtitle: Home.accessiblePlacesSub,
        image: Assets.imagesF1,
        buttonText: Home.explorePlaces,
        onPress: () => context.push(AppRoutes.kPlaces),
      ),
      FeatureModel(
        title: Home.signLessons,
        subtitle: Home.signLessonsSub,
        image: Assets.imagesF7,
        buttonText: Home.startLearning,
        onPress: () => context.push(AppRoutes.kSignLanguage),
      ),
      FeatureModel(
        title: Home.roleModels,
        subtitle: Home.roleModelsSub,
        image: Assets.imagesF3,
        buttonText: Home.getInspired,
        onPress: () => context.push(AppRoutes.kRoleModels),
      ),
      FeatureModel(
        title: Home.community,
        subtitle: Home.communitySub,
        image: Assets.imagesF5,
        buttonText: Home.joinCommunity,
        onPress: () => context.push(AppRoutes.kCommunity),
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true; // Keep state alive when switching tabs

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final locale = context.locale;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          sliver: SliverToBoxAdapter(
            child: _WelcomeHeader(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverList.separated(
            itemCount: _features.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final feature = _features[index];
              return CustomFeaturesContainer(
                title: feature.title.tr(),
                subtitle: feature.subtitle.tr(),
                image: feature.image,
                buttonText: feature.buttonText.tr(),
                onPress: feature.onPress,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Separate widget for better performance
class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ProfileState state) {
    final theme = Theme.of(context);

    if (state is ProfileLoading) {
      return _buildMessage(
        context,
        Home.loading.tr(),
        isLoading: true,
      );
    }

    if (state is ProfileError) {
      return _buildMessage(
        context,
        Home.error.tr(),
        isError: true,
      );
    }

    if (state is ProfileLoaded) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Home.welcome.tr(namedArgs: {"name": state.firstName}),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMessage(
      BuildContext context,
      String message, {
        bool isLoading = false,
        bool isError = false,
      }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (isLoading)
          SizedBox(
            width: 16.w,
            height: 16.h,
            child: CircularProgressIndicator(strokeWidth: 2.w),
          )
        else if (isError)
          Icon(Icons.error_outline, size: 20.sp, color: theme.colorScheme.error),
        if (isLoading || isError) SizedBox(width: 8.w),
        Text(
          message,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isError ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}