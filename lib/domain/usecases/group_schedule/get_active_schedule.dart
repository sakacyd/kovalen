import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/group_schedule.dart';
import 'package:kovalen/domain/repository/group_schedule_repository.dart';

class GetActiveScheduleParams {
  final String roomId;
  GetActiveScheduleParams({required this.roomId});
}

class GetActiveSchedule implements UseCase<GroupSchedule?, GetActiveScheduleParams> {
  final GroupScheduleRepository repository;

  GetActiveSchedule(this.repository);

  @override
  Future<Either<Failure, GroupSchedule?>> call(GetActiveScheduleParams params) async {
    return await repository.getActiveSchedule(params.roomId);
  }
}
