import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/home_stats.dart';
import 'package:kovalen/domain/repository/home_repository.dart';

class GetHomeStats implements UseCase<HomeStats, NoParams> {
  final HomeRepository repository;

  GetHomeStats(this.repository);

  @override
  Future<Either<Failure, HomeStats>> call(NoParams params) async {
    return await repository.getHomeStats();
  }
}
