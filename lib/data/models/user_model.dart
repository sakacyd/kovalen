import 'package:kovalen/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.avatarUrl,
    required super.semester,
    required super.latitude,
    required super.longitude,
    required super.lastLocationUpdate,
    required super.gpa,
    required super.universityId,
    required super.studyProgramId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      semester: json['semester'] as int? ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longtitude'] as num?)?.toDouble() ?? 0.0, // Match schema 'longtitude'
      lastLocationUpdate: json['last_location_update'] ?? '',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
      universityId: json['university_id'] ?? '',
      studyProgramId: json['study_program_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'semester': semester,
      'latitude': latitude,
      'longtitude': longitude, // Match schema 'longtitude'
      'last_location_update': lastLocationUpdate,
      'gpa': gpa,
      'university_id': universityId,
      'study_program_id': studyProgramId,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    int? semester,
    double? latitude,
    double? longitude,
    String? lastLocationUpdate,
    double? gpa,
    String? universityId,
    String? studyProgramId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      semester: semester ?? this.semester,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      gpa: gpa ?? this.gpa,
      universityId: universityId ?? this.universityId,
      studyProgramId: studyProgramId ?? this.studyProgramId,
    );
  }
}
