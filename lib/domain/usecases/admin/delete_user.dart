import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/admin_repository.dart';

class DeleteUserParams {
  final String userId;

  DeleteUserParams({required this.userId});
}

class DeleteUser implements UseCase<void, DeleteUserParams> {
  final AdminRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return await repository.deleteUser(userId: params.userId);
  }
}
