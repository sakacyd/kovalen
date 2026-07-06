part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LoadHomeData extends HomeEvent {}

final class _UpdateHomeData extends HomeEvent {
  final User user;
  final Either<Failure, HomeData> dataResult;

  _UpdateHomeData(this.user, this.dataResult);
}