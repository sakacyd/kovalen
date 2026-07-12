import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/rating_repository.dart';

class RateUserParams {
  final String rateeId;
  final int rating;
  final String? review;

  RateUserParams({
    required this.rateeId,
    required this.rating,
    this.review,
  });
}

class RateUser implements UseCase<void, RateUserParams> {
  final RatingRepository repository;

  RateUser(this.repository);

  @override
  Future<Either<Failure, void>> call(RateUserParams params) async {
    return await repository.rateUser(
      rateeId: params.rateeId,
      rating: params.rating,
      review: params.review,
    );
  }
}
