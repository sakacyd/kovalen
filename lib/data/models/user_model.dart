import 'package:kovalen/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.avatarUrl,
    required super.semester,
    super.gender,
    super.tujuanBelajar,
    super.gayaBelajar,

    super.maxDistancePreference = 15.0,
    required super.latitude,
    required super.longitude,
    required super.lastLocationUpdate,
    required super.gpa,
    required super.universityId,
    required super.studyProgramId,
    super.universityName,
    super.studyProgramName,
    super.role = 'pelanggan',
    super.ratingScore = 0.0,
    super.ratingCount = 0,
    super.status = 'active',
    super.suspendedUntil,
    super.interests = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      semester: json['semester'] as int? ?? 0,
      gender: json['gender'],
      tujuanBelajar: json['tujuan_belajar'],
      gayaBelajar: json['gaya_belajar'],

      maxDistancePreference:
          (json['max_distance_preference'] as num?)?.toDouble() ?? 15.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      lastLocationUpdate: json['last_location_update'] ?? '',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
      universityId: json['university_id'] ?? '',
      studyProgramId: json['study_program_id'] ?? '',
      universityName:
          json['university_name'] ??
          (json['university'] != null ? json['university']['name'] : null),
      studyProgramName:
          json['study_program_name'] ??
          (json['study_program'] != null
              ? '${json['study_program']['education_level']} ${json['study_program']['name']}'
              : null),
      role: json['role'] ?? 'pelanggan',
      ratingScore: (json['rating_score'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['rating_count'] as int? ?? 0,
      status: json['status'] ?? 'active',
      suspendedUntil: json['suspended_until'] != null
          ? DateTime.parse(json['suspended_until'])
          : null,
      interests: _parseInterests(json['user_interests']),
    );
  }

  static List<String> _parseInterests(dynamic userInterestsJson) {
    if (userInterestsJson == null) return [];
    if (userInterestsJson is List) {
      return userInterestsJson
          .map((ui) {
            if (ui is Map && ui['interests'] is Map) {
              return ui['interests']['name'] as String;
            }
            return '';
          })
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'semester': semester,
      'gender': gender,
      'tujuan_belajar': tujuanBelajar,
      'gaya_belajar': gayaBelajar,

      'max_distance_preference': maxDistancePreference,
      'latitude': latitude,
      'longitude': longitude,
      'last_location_update': lastLocationUpdate,
      'gpa': gpa,
      'university_id': universityId,
      'study_program_id': studyProgramId,
      'university_name': universityName,
      'study_program_name': studyProgramName,
      'role': role,
      'rating_score': ratingScore,
      'rating_count': ratingCount,
      'status': status,
      'suspended_until': suspendedUntil?.toIso8601String(),
      'interests': interests,
    };
  }

  @override
  UserModel copyWith({
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
    return UserModel(
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
