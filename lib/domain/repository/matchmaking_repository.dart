import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/match_profile.dart';

abstract interface class MatchmakingRepository {
  Future<Either<Failure, List<MatchProfile>>> getPotentialMatches();
  Future<Either<Failure, bool>> swipeUser(String swipedId, bool isLiked);
  Stream<Either<Failure, bool>> watchNewMatches();
}
