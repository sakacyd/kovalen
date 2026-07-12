import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/group_activity.dart';
import 'package:kovalen/domain/repository/group_activity_repository.dart';

class CreateGroupActivityParams {
  final String scheduleId;
  final String roomId;
  final String activitySummary;
  final String? materialCovered;
  final String? nextGoals;

  CreateGroupActivityParams({
    required this.scheduleId,
    required this.roomId,
    required this.activitySummary,
    this.materialCovered,
    this.nextGoals,
  });
}

class CreateGroupActivity implements UseCase<GroupActivity, CreateGroupActivityParams> {
  final GroupActivityRepository repository;

  CreateGroupActivity(this.repository);

  @override
  Future<Either<Failure, GroupActivity>> call(CreateGroupActivityParams params) async {
    return await repository.createActivity(
      scheduleId: params.scheduleId,
      roomId: params.roomId,
      activitySummary: params.activitySummary,
      materialCovered: params.materialCovered,
      nextGoals: params.nextGoals,
    );
  }
}
