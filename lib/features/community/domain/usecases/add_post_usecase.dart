
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/post_entity.dart';
import '../repos/posts_repo.dart';

class AddPostUseCase implements UseCase<void, PostEntity> {
  final PostsRepo repo;
  AddPostUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(PostEntity params) {
    return repo.addPost(params);
  }

}