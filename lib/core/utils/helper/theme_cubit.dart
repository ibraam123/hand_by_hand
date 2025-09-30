import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'themeMode';
  static const String _languageKey = 'isEnglish';


  ThemeCubit() : super(const ThemeInitial(themeMode: ThemeMode.light , isEnglish: true)) {
    _loadTheme();
  }

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _setAndSaveTheme(newThemeMode);
  }

  Future<void> toggleLanguage(BuildContext context) async {
    emit(ThemeInitial(
      themeMode: state.themeMode,
      isEnglish: state.isEnglish,
      isLoading: true,
    ));

    await Future.delayed(const Duration(milliseconds: 400));

    final newLanguage = !state.isEnglish;
    if (newLanguage) {
      await context.setLocale(const Locale('en'));
    } else {
      await context.setLocale(const Locale('ar'));
    }

    _setAndSaveLanguage(newLanguage);
    emit(ThemeInitial(
      themeMode: state.themeMode,
      isEnglish: newLanguage,
      isLoading: false,
    ));
  }

  void _setAndSaveLanguage(bool isEnglish) {
    emit(ThemeInitial(themeMode: state.themeMode , isEnglish: isEnglish));
    _saveLanguage(isEnglish);
  }

  Future<void> _saveLanguage(bool isEnglish) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_languageKey, isEnglish);
    } catch (e) {
      debugPrint('Failed to save language: $e');
    }
  }

  void setTheme(ThemeMode themeMode) {
    _setAndSaveTheme(themeMode);
  }

  void _setAndSaveTheme(ThemeMode themeMode) {
    emit(ThemeInitial(themeMode: themeMode));
    _saveTheme(themeMode);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.name);
    } catch (e) {
      // Handle error, e.g., log it or show a message to the user
      debugPrint('Failed to save theme: $e');
    }
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeString = prefs.getString(_themeKey);
      final themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == savedThemeString,
          orElse: () => ThemeMode.light);
      final savedLanguage = prefs.getBool(_languageKey) ?? true;
      emit(ThemeInitial(themeMode: themeMode , isEnglish: savedLanguage));
    } catch (e) {
      // Handle error, e.g., log it or show a message to the user
      debugPrint('Failed to load theme: $e');
      // Optionally emit a default theme if loading fails
      emit(const ThemeInitial(themeMode: ThemeMode.light));
    }
  }
}
