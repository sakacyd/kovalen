class User {
  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;
  final int semester;
  final double latitude;
  final double longitude;
  final String lastLocationUpdate;
  final double gpa;
  final String universityId;
  final String studyProgramId;
  final String? universityName;
  final String? studyProgramName;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.semester,
    required this.latitude,
    required this.longitude,
    required this.lastLocationUpdate,
    required this.gpa,
    required this.universityId,
    required this.studyProgramId,
    this.universityName,
    this.studyProgramName,
  });
}
// TODO: tambahin gender cok