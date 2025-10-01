

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_sources/local/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profile = await localDataSource.getProfile();
      return Right(profile);
    } on Exception {
      return Left(ServerFailure('Profile not found'));
    } catch (e) {
      return Left(ServerFailure('Failed to get profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(UserProfile profile) async {
    try {
      await localDataSource.saveProfile(profile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to save profile: $e'));
    }
  }
}
