import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/group_schedule.dart';

abstract interface class GroupScheduleRepository {
  Future<Either<Failure, GroupSchedule?>> getActiveSchedule(String roomId);
  Future<Either<Failure, GroupSchedule>> createSchedule({
    required String roomId,
    required String title,
    required DateTime meetingTime,
    required String locationName,
    String? locationUrl,
  });
  Future<Either<Failure, void>> completeSchedule(String scheduleId);
}
