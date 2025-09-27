import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'themeMode';

  ThemeCubit() : super(const ThemeInitial(themeMode: ThemeMode.light)) {
    _loadTheme();
  }

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _setAndSaveTheme(newThemeMode);
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
      emit(ThemeInitial(themeMode: themeMode));
    } catch (e) {
      // Handle error, e.g., log it or show a message to the user
      debugPrint('Failed to load theme: $e');
      // Optionally emit a default theme if loading fails
      emit(const ThemeInitial(themeMode: ThemeMode.light));
    }
  }
}
