part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingDataLoaded extends OnboardingState {
  final List<University> universities;
  final List<StudyProgram> studyPrograms;

  OnboardingDataLoaded({
    required this.universities,
    this.studyPrograms = const [],
  });

  OnboardingDataLoaded copyWith({
    List<University>? universities,
    List<StudyProgram>? studyPrograms,
  }) {
    return OnboardingDataLoaded(
      universities: universities ?? this.universities,
      studyPrograms: studyPrograms ?? this.studyPrograms,
    );
  }
}

final class OnboardingSuccess extends OnboardingState {}

final class OnboardingFailure extends OnboardingState {
  final String message;
  OnboardingFailure(this.message);
}
