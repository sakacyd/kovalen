part of 'group_schedule_bloc.dart';

abstract class GroupScheduleEvent {}

class FetchActiveScheduleEvent extends GroupScheduleEvent {
  final String roomId;
  FetchActiveScheduleEvent(this.roomId);
}

class CreateGroupScheduleEvent extends GroupScheduleEvent {
  final String roomId;
  final String title;
  final DateTime meetingTime;
  final String locationName;
  final String? locationUrl;

  CreateGroupScheduleEvent({
    required this.roomId,
    required this.title,
    required this.meetingTime,
    required this.locationName,
    this.locationUrl,
  });
}

class CompleteGroupScheduleEvent extends GroupScheduleEvent {
  final String scheduleId;
  CompleteGroupScheduleEvent(this.scheduleId);
}
