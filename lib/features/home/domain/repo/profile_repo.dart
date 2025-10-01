


import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, void>> saveProfile(UserProfile profile);
}
