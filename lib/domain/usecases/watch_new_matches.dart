import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/matchmaking_repository.dart';

class WatchNewMatches implements StreamUseCase<bool, NoParams> {
  final MatchmakingRepository repository;

  WatchNewMatches(this.repository);

  @override
  Stream<Either<Failure, bool>> call(NoParams params) {
    return repository.watchNewMatches();
  }
}
