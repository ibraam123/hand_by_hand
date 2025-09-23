

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../../../../core/usecases/use_case.dart';
import '../repos/posts_repo.dart';

class AddLikeUseCase implements UseCase<int, String> {
  final PostsRepo repo;
  AddLikeUseCase(this.repo);

  @override
  Future<Either<Failure, int>> call(String params) {
    return repo.likePost(params);
  } 
}