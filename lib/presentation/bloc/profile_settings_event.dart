part of 'profile_settings_bloc.dart';

@immutable
abstract class ProfileSettingsEvent {}

class UpdateProfileSettingsData extends ProfileSettingsEvent {
  final String fullName;
  final String avatarUrl;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final double gpa;

  UpdateProfileSettingsData({
    required this.fullName,
    required this.avatarUrl,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gpa,
  });
}

class ProfileSettingsLoadUniversities extends ProfileSettingsEvent {}

class ProfileSettingsLoadStudyPrograms extends ProfileSettingsEvent {
  final String universityId;

  ProfileSettingsLoadStudyPrograms(this.universityId);
}

class ProfileSettingsSignOut extends ProfileSettingsEvent {}
