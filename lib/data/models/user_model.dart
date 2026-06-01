import 'package:kovalen/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.fullName, required super.email, required super.avatarUrl, required super.phoneNumber, required super.studyProgram, required super.semester, required super.latitude, required super.longitude, required super.lastLocationUpdate});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      studyProgram: json['study_program'] ?? '',
      semester: json['semester'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      lastLocationUpdate: json['last_location_update'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? studyProgram,
    String? semester,
    String? latitude,
    String? longitude,
    String? lastLocationUpdate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      studyProgram: studyProgram ?? this.studyProgram,
      semester: semester ?? this.semester,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
    );
  }

}