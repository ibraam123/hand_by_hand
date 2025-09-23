
import 'package:dartz/dartz.dart';

import '../errors/error.dart';

abstract interface class UseCase<SuccessType , Params>{
  Future<Either<Failure , SuccessType>> call(Params params);

}

class NoParams{

}