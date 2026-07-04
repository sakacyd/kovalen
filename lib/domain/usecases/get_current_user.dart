import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/base_user_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUser<T extends BaseUserRepository>
    implements UseCase<User, NoParams> {
  final T repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
