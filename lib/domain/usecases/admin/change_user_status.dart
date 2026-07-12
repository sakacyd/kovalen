import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/admin_repository.dart';

class ChangeUserStatus implements UseCase<void, ChangeUserStatusParams> {
  final AdminRepository repository;

  ChangeUserStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeUserStatusParams params) async {
    return await repository.changeUserStatus(
      userId: params.userId,
      status: params.status,
      suspendedUntil: params.suspendedUntil,
    );
  }
}

class ChangeUserStatusParams {
  final String userId;
  final String status;
  final DateTime? suspendedUntil;

  ChangeUserStatusParams({
    required this.userId,
    required this.status,
    this.suspendedUntil,
  });
}
