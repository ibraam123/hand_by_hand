part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {
  final ThemeMode themeMode;
  final bool isEnglish ;
  final bool isLoading ;
  const ThemeState(this.themeMode , this.isEnglish, this.isLoading);
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial({required ThemeMode themeMode , bool isEnglish = true , bool isLoading = false}) : super(themeMode , isEnglish , isLoading);
}



