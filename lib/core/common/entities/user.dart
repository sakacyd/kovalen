class User {
  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;
  final int semester;
  final String? gender;
  final String? tujuanBelajar;
  final String? gayaBelajar;
  final String? hobi;
  final double maxDistancePreference;
  final double latitude;
  final double longitude;
  final String lastLocationUpdate;
  final double gpa;
  final String universityId;
  final String studyProgramId;
  final String? universityName;
  final String? studyProgramName;
  final String role;
  final double ratingScore;
  final int ratingCount;
  final String status;
  final DateTime? suspendedUntil;
  final List<String> interests;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.semester,
    this.gender,
    this.tujuanBelajar,
    this.gayaBelajar,
    this.hobi,
    this.maxDistancePreference = 15.0,
    required this.latitude,
    required this.longitude,
    required this.lastLocationUpdate,
    required this.gpa,
    required this.universityId,
    required this.studyProgramId,
    this.universityName,
    this.studyProgramName,
    this.role = 'pelanggan',
    this.ratingScore = 0.0,
    this.ratingCount = 0,
    this.status = 'active',
    this.suspendedUntil,
    this.interests = const [],
  });

  bool get isProfileComplete {
    return universityId.isNotEmpty &&
        studyProgramId.isNotEmpty &&
        semester > 0 &&
        gender != null &&
        tujuanBelajar != null &&
        gayaBelajar != null;
  }

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    int? semester,
    String? gender,
    String? tujuanBelajar,
    String? gayaBelajar,
    double? maxDistancePreference,
    double? latitude,
    double? longitude,
    String? lastLocationUpdate,
    double? gpa,
    String? universityId,
    String? studyProgramId,
    String? universityName,
    String? studyProgramName,
    String? role,
    double? ratingScore,
    int? ratingCount,
    String? status,
    DateTime? suspendedUntil,
    List<String>? interests,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      semester: semester ?? this.semester,
      gender: gender ?? this.gender,
      tujuanBelajar: tujuanBelajar ?? this.tujuanBelajar,
      gayaBelajar: gayaBelajar ?? this.gayaBelajar,
      maxDistancePreference:
          maxDistancePreference ?? this.maxDistancePreference,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      gpa: gpa ?? this.gpa,
      universityId: universityId ?? this.universityId,
      studyProgramId: studyProgramId ?? this.studyProgramId,
      universityName: universityName ?? this.universityName,
      studyProgramName: studyProgramName ?? this.studyProgramName,
      role: role ?? this.role,
      ratingScore: ratingScore ?? this.ratingScore,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      suspendedUntil: suspendedUntil ?? this.suspendedUntil,
      interests: interests ?? this.interests,
    );
  }
}
