import 'package:fpdart/fpdart.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/group_schedule.dart';
import 'package:kovalen/domain/repository/group_schedule_repository.dart';

class CreateScheduleParams {
  final String roomId;
  final String title;
  final DateTime meetingTime;
  final String locationName;
  final String? locationUrl;

  CreateScheduleParams({
    required this.roomId,
    required this.title,
    required this.meetingTime,
    required this.locationName,
    this.locationUrl,
  });
}

class CreateSchedule implements UseCase<GroupSchedule, CreateScheduleParams> {
  final GroupScheduleRepository repository;

  CreateSchedule(this.repository);

  @override
  Future<Either<Failure, GroupSchedule>> call(CreateScheduleParams params) async {
    return await repository.createSchedule(
      roomId: params.roomId,
      title: params.title,
      meetingTime: params.meetingTime,
      locationName: params.locationName,
      locationUrl: params.locationUrl,
    );
  }
}
