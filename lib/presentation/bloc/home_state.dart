part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final User user;

  HomeSuccess(this.user);
}

final class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}


/* class HomeState {
  final String userName;
  final String userInitial;
  final int activeGroups;
  final int todayMatches;
  final List<Map<String, String>> studyGroups;

  HomeState({
    required this.userName,
    required this.userInitial,
    required this.activeGroups,
    required this.todayMatches,
    required this.studyGroups,
  });

  factory HomeState.initial() {
    return HomeState(
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
