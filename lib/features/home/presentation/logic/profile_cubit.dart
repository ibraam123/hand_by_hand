import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final firstName = prefs.getString('firstName') ?? "Guest";
      final lastName = prefs.getString('lastName') ?? "";
      emit(ProfileLoaded(firstName, lastName));
    } catch (e) {
      emit(ProfileError("Failed to load profile"));
    }
  }

  Future<void> saveProfile(String firstName, String lastName) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstName);
      await prefs.setString('lastName', lastName);
      emit(ProfileLoaded(firstName, lastName));
    } catch (e) {
      emit(ProfileError("Failed to save profile"));
    }
  }

  void editProfile(String firstName, String lastName) {
    emit(ProfileEdit(firstName, lastName));
  }
}
