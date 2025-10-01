

import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/user_profile.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfile> getProfile();
  Future<void> saveProfile(UserProfile profile);
}


// Data Layer - Data Source Implementation
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl(this.sharedPreferences);

  static const String _firstNameKey = 'firstName';
  static const String _lastNameKey = 'lastName';
  static const String _email = 'email';

  @override
  Future<UserProfile> getProfile() async {
    final firstName = sharedPreferences.getString(_firstNameKey);
    final lastName = sharedPreferences.getString(_lastNameKey);
    final email = sharedPreferences.getString(_email);


    if (firstName == null || lastName == null) {
      throw Exception('Profile not found');
    }

    return UserProfile(firstName: firstName, lastName: lastName , email: email);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await sharedPreferences.setString(_firstNameKey, profile.firstName);
    await sharedPreferences.setString(_lastNameKey, profile.lastName);
  }
}