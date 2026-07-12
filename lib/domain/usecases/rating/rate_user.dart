import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/rating_repository.dart';

class RateUserParams {
  final String targetUserId;
  final double score;
  final String? feedback;

  RateUserParams({
    required this.targetUserId,
    required this.score,
    this.feedback,
  });
}

class RateUser implements UseCase<void, RateUserParams> {
  final RatingRepository repository;

  RateUser(this.repository);

  @override
  Future<Either<Failure, void>> call(RateUserParams params) async {
    return await repository.rateUser(
      targetUserId: params.targetUserId,
      score: params.score,
      feedback: params.feedback,
    );
  }
}
