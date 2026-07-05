import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/matchmaking_repository.dart';

class SwipeUser implements UseCase<void, SwipeUserParams> {
  final MatchmakingRepository repository;

  SwipeUser(this.repository);

  @override
  Future<Either<Failure, void>> call(SwipeUserParams params) async {
    return await repository.swipeUser(params.swipedId, params.isLiked);
  }
}

class SwipeUserParams {
  final String swipedId;
  final bool isLiked;

  SwipeUserParams({required this.swipedId, required this.isLiked});
}
