class GroupSchedule {
  final String id;
  final String roomId;
  final String title;
  final String createdBy;
  final DateTime meetingTime;
  final String locationName;
  final String? locationUrl;
  final bool isCompleted;
  final DateTime createdAt;

  GroupSchedule({
    required this.id,
    required this.roomId,
    required this.title,
    required this.createdBy,
    required this.meetingTime,
    required this.locationName,
    this.locationUrl,
    required this.isCompleted,
    required this.createdAt,
  });
}
