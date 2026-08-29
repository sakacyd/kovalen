import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/core/common/entities/group_schedule.dart';
import 'package:kovalen/domain/repository/group_schedule_repository.dart';
import 'package:kovalen/data/datasources/group_schedule_remote_data_source.dart';

class GroupScheduleRepositoryImpl implements GroupScheduleRepository {
  final GroupScheduleRemoteDataSource remoteDataSource;

  GroupScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, GroupSchedule?>> getActiveSchedule(
    String roomId,
  ) async {
    try {
      final schedule = await remoteDataSource.getActiveSchedule(roomId);
      return right(schedule);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, GroupSchedule>> createSchedule({
    required String roomId,
    required String title,
    required DateTime meetingTime,
    required String locationName,
    String? locationUrl,
  }) async {
    try {
      final schedule = await remoteDataSource.createSchedule(
        roomId: roomId,
        title: title,
        meetingTime: meetingTime,
        locationName: locationName,
        locationUrl: locationUrl,
      );
      return right(schedule);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> completeSchedule(String scheduleId) async {
    try {
      await remoteDataSource.completeSchedule(scheduleId);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
