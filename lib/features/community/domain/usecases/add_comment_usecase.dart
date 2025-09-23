

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error.dart';
import '../../../../core/usecases/use_case.dart';
import '../repos/posts_repo.dart';

class AddCommentUseCase implements UseCase<void, CommentParams>{
  final PostsRepo repo;
  AddCommentUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(CommentParams params) {
    return repo.addComment(params.postId, params.comment);
  }

}

class CommentParams{
  final String postId;
  final String comment;
  const CommentParams(this.postId, this.comment);
}