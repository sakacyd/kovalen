import 'package:kovalen/core/common/entities/group_activity.dart';

class GroupActivityModel extends GroupActivity {
  GroupActivityModel({
    required super.id,
    required super.scheduleId,
    required super.roomId,
    required super.createdBy,
    required super.activitySummary,
    super.materialCovered,
    super.nextGoals,
    required super.createdAt,
  });

  factory GroupActivityModel.fromJson(Map<String, dynamic> json) {
    return GroupActivityModel(
      id: json['id'],
      scheduleId: json['schedule_id'],
      roomId: json['room_id'],
      createdBy: json['created_by'],
      activitySummary: json['activity_summary'],
      materialCovered: json['material_covered'],
      nextGoals: json['next_goals'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      'room_id': roomId,
      'created_by': createdBy,
      'activity_summary': activitySummary,
      'material_covered': materialCovered,
      'next_goals': nextGoals,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
