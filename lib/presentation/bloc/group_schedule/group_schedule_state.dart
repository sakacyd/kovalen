part of 'group_schedule_bloc.dart';

abstract class GroupScheduleState {}

class GroupScheduleInitial extends GroupScheduleState {}

class GroupScheduleLoading extends GroupScheduleState {}

class GroupScheduleLoaded extends GroupScheduleState {
  final GroupSchedule? schedule;
  GroupScheduleLoaded(this.schedule);
}

class GroupScheduleActionSuccess extends GroupScheduleState {
  final String message;
  GroupScheduleActionSuccess(this.message);
}

class GroupScheduleError extends GroupScheduleState {
  final String message;
  GroupScheduleError(this.message);
}
