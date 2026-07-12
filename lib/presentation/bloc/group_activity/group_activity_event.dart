part of 'group_activity_bloc.dart';

abstract class GroupActivityEvent {}

class SubmitGroupActivityEvent extends GroupActivityEvent {
  final String scheduleId;
  final String roomId;
  final String activitySummary;
  final String? materialCovered;
  final String? nextGoals;

  SubmitGroupActivityEvent({
    required this.scheduleId,
    required this.roomId,
    required this.activitySummary,
    this.materialCovered,
    this.nextGoals,
  });
}
