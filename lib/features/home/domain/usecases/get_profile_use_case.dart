import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../entities/user_profile.dart';
import '../repo/profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call() async {
    return await repository.getProfile();
  }
}