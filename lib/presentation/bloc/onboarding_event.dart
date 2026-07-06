part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

final class OnboardingLoadUniversities extends OnboardingEvent {}

final class OnboardingLoadStudyPrograms extends OnboardingEvent {
  final String universityId;
  OnboardingLoadStudyPrograms(this.universityId);
}

final class OnboardingSubmit extends OnboardingEvent {
  final String fullName;
  final String avatarUrl;
  final File? avatarFile;
  final String universityId;
  final String studyProgramId;
  final int semester;
  final double gpa;
  final List<String> interests;

  OnboardingSubmit({
    required this.fullName,
    required this.avatarUrl,
    this.avatarFile,
    required this.universityId,
    required this.studyProgramId,
    required this.semester,
    required this.gpa,
    required this.interests,
  });
}
