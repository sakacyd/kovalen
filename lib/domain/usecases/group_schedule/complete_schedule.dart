import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/repository/group_schedule_repository.dart';

class CompleteScheduleParams {
  final String scheduleId;
  CompleteScheduleParams({required this.scheduleId});
}

class CompleteSchedule implements UseCase<void, CompleteScheduleParams> {
  final GroupScheduleRepository repository;

  CompleteSchedule(this.repository);

  @override
  Future<Either<Failure, void>> call(CompleteScheduleParams params) async {
    return await repository.completeSchedule(params.scheduleId);
  }
}
