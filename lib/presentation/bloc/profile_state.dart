part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final User user;

  ProfileSuccess(this.user);
}

final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}


/* class ProfileState {
  final String userName;
  final String userInitial;
  final int activeGroups;
  final int todayMatches;
  final List<Map<String, String>> studyGroups;

  ProfileState({
    required this.userName,
    required this.userInitial,
    required this.activeGroups,
    required this.todayMatches,
    required this.studyGroups,
  });

  factory ProfileState.initial() {
    return ProfileState(
      userName: 'Budi Santoso',
      userInitial:
          'BS', // Corresponds to the "AR" Avatar from Clean Minimalism HTML
      activeGroups: 3,
      todayMatches: 5,
      studyGroups: [
        {
          'title': 'Kecerdasan Buatan',
          'subtitle': 'Persiapan presentasi proyek akhir',
          'time': '14:00',
        },
        {
          'title': 'Basis Data Lanjut',
          'subtitle': 'Review materi normalisasi dan optimasi query',
          'time': '10:00',
        },
      ],
    );
  }
} */
