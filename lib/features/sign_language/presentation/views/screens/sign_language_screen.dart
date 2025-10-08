import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/sign_language/domain/entities/category_lesson_entitiy.dart';
import '../../logic/sign_language_cubit.dart';
import '../widgets/category_lesson_chip.dart';
import '../widgets/lessons_list.dart';

class SignLanguageScreen extends StatefulWidget {
  const SignLanguageScreen({super.key});

  @override
  State<SignLanguageScreen> createState() => _SignLanguageScreenState();
}

class _SignLanguageScreenState extends State<SignLanguageScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<CategoryLessonEntity> categories = [
    CategoryLessonEntity("all", CategoriesSignLanguage.all.tr()),
    CategoryLessonEntity("beginner", CategoriesSignLanguage.beginner.tr()),
    CategoryLessonEntity(
      "intermediate",
      CategoriesSignLanguage.intermediate.tr(),
    ),
    CategoryLessonEntity("hard", CategoriesSignLanguage.hard.tr()),
    CategoryLessonEntity("very hard", CategoriesSignLanguage.veryHard.tr()),
  ];
  String selectedType = "all";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _onScroll();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        0.7 * _scrollController.position.maxScrollExtent) {
      final langCode = context.locale.languageCode;
      context.read<SignLanguageCubit>().fetchMoreSignLessons(langCode);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final langCode = context.locale.languageCode;
    context.read<SignLanguageCubit>().fetchSignLessons(langCode: langCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Home.signLessons.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SignLanguageCubit, SignLanguageState>(
        builder: (context, state) {
          if (state is SignLanguageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SignLanguageLoaded) {
            final allLessons = state.signLessons;
            final filteredLessons = selectedType == 'all'
                ? allLessons
                : allLessons.where((p) => p.type == selectedType).toList();
            return Column(
              children: [
                SizedBox(height: 12.h),
                CategoryLessonChips(
                  categories: categories,
                  selectedType: selectedType,
                  onSelected: (key) => setState(() => selectedType = key),
                ),
                Expanded(
                  child: LessonsList(
                    scrollController: _scrollController,
                    lessons: filteredLessons,
                    hasMore: state.hasMore,
                  ),
                )
              ],
            );
          } else if (state is SignLanguageError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

