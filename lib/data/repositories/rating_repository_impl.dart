import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/repository/rating_repository.dart';
import 'package:kovalen/data/datasources/rating_remote_data_source.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> rateUser({
    required String targetUserId,
    required double score,
    String? feedback,
  }) async {
    try {
      await remoteDataSource.rateUser(
        targetUserId: targetUserId,
        score: score,
        feedback: feedback,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getRoomParticipants(String roomId) async {
    try {
      final participants = await remoteDataSource.getRoomParticipants(roomId);
      return right(participants);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
