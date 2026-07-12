import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/admin_repository.dart';

class GetAllUsers implements UseCase<List<User>, NoParams> {
  final AdminRepository repository;

  GetAllUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getAllUsers();
  }
}
