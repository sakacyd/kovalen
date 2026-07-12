import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';

abstract interface class RatingRepository {
  Future<Either<Failure, void>> rateUser({
    required String rateeId,
    required int rating,
    String? review,
  });
  Future<Either<Failure, List<User>>> getRoomParticipants(String roomId);
}
