

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../../../../core/usecases/use_case.dart';
import '../repos/posts_repo.dart';

class AddLikeUseCase implements UseCase<Map<String, dynamic>, String> {
  final PostsRepo repo;
  AddLikeUseCase(this.repo);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String postId) {
    return repo.likePost(postId);
  }
}