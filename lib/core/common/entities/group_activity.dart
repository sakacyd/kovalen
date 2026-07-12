class GroupActivity {
  final String id;
  final String scheduleId;
  final String roomId;
  final String createdBy;
  final String activitySummary;
  final String? materialCovered;
  final String? nextGoals;
  final DateTime createdAt;

  GroupActivity({
    required this.id,
    required this.scheduleId,
    required this.roomId,
    required this.createdBy,
    required this.activitySummary,
    this.materialCovered,
    this.nextGoals,
    required this.createdAt,
  });
}
