part of 'profile_settings_bloc.dart';

@immutable
abstract class ProfileSettingsState {}

class ProfileSettingsInitial extends ProfileSettingsState {}

class ProfileSettingsLoading extends ProfileSettingsState {}

class ProfileSettingsFailure extends ProfileSettingsState {
  final String message;

  ProfileSettingsFailure(this.message);
}

class ProfileSettingsDataLoaded extends ProfileSettingsState {
  final List<University> universities;
  final List<StudyProgram> studyPrograms;

  ProfileSettingsDataLoaded({
    this.universities = const [],
    this.studyPrograms = const [],
  });

  ProfileSettingsDataLoaded copyWith({
    List<University>? universities,
    List<StudyProgram>? studyPrograms,
  }) {
    return ProfileSettingsDataLoaded(
      universities: universities ?? this.universities,
      studyPrograms: studyPrograms ?? this.studyPrograms,
    );
  }
}

class UpdateProfileSettingsSuccess extends ProfileSettingsState {
  final User user;

  UpdateProfileSettingsSuccess(this.user);
}
