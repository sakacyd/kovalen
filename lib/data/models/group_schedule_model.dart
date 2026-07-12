import 'package:kovalen/core/common/entities/group_schedule.dart';

class GroupScheduleModel extends GroupSchedule {
  GroupScheduleModel({
    required super.id,
    required super.roomId,
    required super.title,
    required super.createdBy,
    required super.meetingTime,
    required super.locationName,
    super.locationUrl,
    required super.isCompleted,
    required super.createdAt,
  });

  factory GroupScheduleModel.fromJson(Map<String, dynamic> json) {
    return GroupScheduleModel(
      id: json['id'],
      roomId: json['room_id'],
      title: json['title'] ?? 'Jadwal Pertemuan',
      createdBy: json['created_by'],
      meetingTime: DateTime.parse(json['meeting_time']).toLocal(),
      locationName: json['location_name'],
      locationUrl: json['location_url'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'title': title,
      'created_by': createdBy,
      'meeting_time': meetingTime.toUtc().toIso8601String(),
      'location_name': locationName,
      'location_url': locationUrl,
      'is_completed': isCompleted,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
