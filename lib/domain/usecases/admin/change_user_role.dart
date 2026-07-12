import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/admin_repository.dart';

class ChangeUserRoleParams {
  final String userId;
  final String newRole;

  ChangeUserRoleParams({required this.userId, required this.newRole});
}

class ChangeUserRole implements UseCase<void, ChangeUserRoleParams> {
  final AdminRepository repository;

  ChangeUserRole(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeUserRoleParams params) async {
    return await repository.changeUserRole(userId: params.userId, newRole: params.newRole);
  }
}
