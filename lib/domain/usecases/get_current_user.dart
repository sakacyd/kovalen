import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final HomeRepository homeRepository;

  GetCurrentUser(this.homeRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await homeRepository.getCurrentUser();
  }
}
