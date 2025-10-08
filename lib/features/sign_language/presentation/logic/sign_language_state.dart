part of 'sign_language_cubit.dart';

@immutable
sealed class SignLanguageState {}

final class SignLanguageInitial extends SignLanguageState {}

final class SignLanguageLoading extends SignLanguageState {}

final class SignLanguageLoaded extends SignLanguageState {
  final List<SignLessonEntitiy> signLessons;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final bool isLoadingMore;

  SignLanguageLoaded(
      this.signLessons, {
        this.lastDocument,
        this.hasMore = true,
        this.isLoadingMore = false,
      });
}

final class SignLanguageError extends SignLanguageState {
  final String message;
  SignLanguageError(this.message);
}

