

import '../models/user_model.dart';
import '../models/user_progress.dart';

abstract class UserRepository {
  Future<UserModel> getUser(String id);
  Future<void> updateUser(UserModel user);
  Future<void> updateProgress(String userId, UserProgress progress);
}
