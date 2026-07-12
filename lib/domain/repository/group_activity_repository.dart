import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/group_activity.dart';

abstract interface class GroupActivityRepository {
  Future<Either<Failure, GroupActivity>> createActivity({
    required String scheduleId,
    required String roomId,
    required String activitySummary,
    String? materialCovered,
    String? nextGoals,
  });
}
