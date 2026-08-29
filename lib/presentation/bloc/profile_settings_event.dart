part of 'profile_settings_bloc.dart';

@immutable
abstract class ProfileSettingsEvent {}

class UpdateProfileSettingsData extends ProfileSettingsEvent {
  final String fullName;
  final String avatarUrl;
  final File? avatarFile;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final String gender;
  final String tujuanBelajar;
  final String gayaBelajar;
  final String hobi;
  final double gpa;
  final List<String> interests;

  UpdateProfileSettingsData({
    required this.fullName,
    required this.avatarUrl,
    this.avatarFile,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gender,
    required this.tujuanBelajar,
    required this.gayaBelajar,
    required this.hobi,
    required this.gpa,
    required this.interests,
  });
}

class ProfileSettingsLoadUniversities extends ProfileSettingsEvent {}

class ProfileSettingsLoadStudyPrograms extends ProfileSettingsEvent {
  final String universityId;

  ProfileSettingsLoadStudyPrograms(this.universityId);
}

class ProfileSettingsSignOut extends ProfileSettingsEvent {}
