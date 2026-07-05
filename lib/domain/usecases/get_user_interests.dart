import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/domain/repository/profile_repository.dart';

class GetUserInterests implements UseCase<List<Interest>, NoParams> {
  final ProfileRepository repository;

  GetUserInterests(this.repository);

  @override
  Future<Either<Failure, List<Interest>>> call(NoParams params) async {
    return await repository.getUserInterests();
  }
}
