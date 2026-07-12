import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/group_activity.dart';
import 'package:kovalen/domain/repository/group_activity_repository.dart';
import 'package:kovalen/data/datasources/group_activity_remote_data_source.dart';

class GroupActivityRepositoryImpl implements GroupActivityRepository {
  final GroupActivityRemoteDataSource remoteDataSource;

  GroupActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, GroupActivity>> createActivity({
    required String scheduleId,
    required String roomId,
    required String activitySummary,
    String? materialCovered,
    String? nextGoals,
  }) async {
    try {
      final activity = await remoteDataSource.createActivity(
        scheduleId: scheduleId,
        roomId: roomId,
        activitySummary: activitySummary,
        materialCovered: materialCovered,
        nextGoals: nextGoals,
      );
      return right(activity);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
