import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BaseUserRepository {
  Future<Either<Failure, User>> getCurrentUser();
}
