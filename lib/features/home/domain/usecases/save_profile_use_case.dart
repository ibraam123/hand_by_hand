

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../entities/user_profile.dart';
import '../repo/profile_repo.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(UserProfile profile) async {
    return await repository.saveProfile(profile);
  }
}