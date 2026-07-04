import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/auth_repository.dart';

class ChangePassword implements UseCase<void, ChangePasswordParams> {
  final AuthRepository authRepository;

  ChangePassword(this.authRepository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await authRepository.changePassword(
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String newPassword;

  ChangePasswordParams({required this.newPassword});
}
