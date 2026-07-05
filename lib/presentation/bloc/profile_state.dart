part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class LoadUserProfileSuccess extends ProfileState {
  final User user;

  LoadUserProfileSuccess(this.user);
}

final class ProfileDataLoaded extends ProfileState {
  final List<University> universities;
  final List<StudyProgram> studyPrograms;

  ProfileDataLoaded({
    required this.universities,
    this.studyPrograms = const [],
  });

  ProfileDataLoaded copyWith({
    List<University>? universities,
    List<StudyProgram>? studyPrograms,
  }) {
    return ProfileDataLoaded(
      universities: universities ?? this.universities,
      studyPrograms: studyPrograms ?? this.studyPrograms,
    );
  }
}

final class UpdateUserProfileSuccess extends ProfileState {
  final User user;

  UpdateUserProfileSuccess(this.user);
}

final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}
