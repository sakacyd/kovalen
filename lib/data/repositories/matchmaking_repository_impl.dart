import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/match_profile.dart';
import 'package:kovalen/data/datasources/matchmaking_remote_data_source.dart';
import 'package:kovalen/domain/repository/matchmaking_repository.dart';

class MatchmakingRepositoryImpl implements MatchmakingRepository {
  final MatchmakingRemoteDataSource remoteDataSource;

  MatchmakingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MatchProfile>>> getPotentialMatches() async {
    try {
      final profiles = await remoteDataSource.getPotentialMatches();
      return Right(profiles);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> swipeUser(String swipedId, bool isLiked) async {
    try {
      final isMatch = await remoteDataSource.swipeUser(swipedId, isLiked);
      return Right(isMatch);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Stream<Either<Failure, void>> watchNewMatches() async* {
    try {
      await for (final _ in remoteDataSource.watchNewMatches()) {
        yield const Right(null);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    }
  }
}
