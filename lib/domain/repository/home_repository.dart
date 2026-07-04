import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/base_user_repository.dart';

abstract interface class HomeRepository implements BaseUserRepository {
  @override
  Future<Either<Failure, User>> getCurrentUser();
}
