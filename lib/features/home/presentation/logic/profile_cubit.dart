import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/save_profile_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.getProfileUseCase,
    required this.saveProfileUseCase,
  }) : super(ProfileInitial());
  final GetProfileUseCase getProfileUseCase;
  final SaveProfileUseCase saveProfileUseCase;


  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUseCase();
      profile.fold(
            (failure) => emit(ProfileError(failure.message)),
            (profile) => emit(ProfileLoaded(profile.firstName, profile.lastName , profile.email)),
      );
    } catch (e) {
      emit(ProfileError("Failed to load profile"));
    }
  }

  Future<void> saveProfile(String firstName, String lastName) async {
    emit(ProfileLoading());
    try {
      final profile = UserProfile(firstName: firstName, lastName: lastName);
      final result = await saveProfileUseCase(profile);
      result.fold(
            (failure) => emit(ProfileError(failure.message)),
            (_) => emit(ProfileLoaded(firstName, lastName , null)),
      );
    } catch (e) {
      emit(ProfileError("Failed to save profile"));
    }
  }

  void editProfile(String firstName, String lastName) {
    emit(ProfileEdit(firstName, lastName));
  }
}
