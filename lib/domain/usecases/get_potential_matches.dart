import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/match_profile.dart';
import 'package:kovalen/domain/repository/matchmaking_repository.dart';

class GetPotentialMatches implements UseCase<List<MatchProfile>, NoParams> {
  final MatchmakingRepository repository;

  GetPotentialMatches(this.repository);

  @override
  Future<Either<Failure, List<MatchProfile>>> call(NoParams params) async {
    return await repository.getPotentialMatches();
  }
}
