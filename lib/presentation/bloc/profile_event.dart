part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class LoadProfileData extends ProfileEvent {}

final class UpdateProfileData extends ProfileEvent {
  final String fullName;
  final String avatarUrl;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final double gpa;
  final List<String> interests;

  UpdateProfileData({
    required this.fullName,
    required this.avatarUrl,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gpa,
    required this.interests,
  });
}

final class ProfileLoadUniversities extends ProfileEvent {}

final class ProfileLoadStudyPrograms extends ProfileEvent {
  final String universityId;
  ProfileLoadStudyPrograms(this.universityId);
}

final class ProfileSignOut extends ProfileEvent {}
