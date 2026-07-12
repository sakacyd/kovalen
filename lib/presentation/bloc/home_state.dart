part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final User user;
  final HomeStats stats;
  final List<ChatRoom> activeGroups;
  final String? randomInterest;

  HomeSuccess(this.user, this.stats, this.activeGroups, {this.randomInterest});
}

final class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
