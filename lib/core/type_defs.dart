import 'package:fpdart/fpdart.dart';
import 'package:tweet_x/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<
    void>; //when we don't need to return anything, just to check if it's a success or failure
