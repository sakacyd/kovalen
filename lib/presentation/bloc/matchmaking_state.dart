part of 'matchmaking_bloc.dart';

@immutable
sealed class MatchmakingState {}

final class MatchmakingInitial extends MatchmakingState {}

final class MatchmakingLoading extends MatchmakingState {}

final class MatchmakingSuccess extends MatchmakingState {
  final List<MatchProfile> matches;

  MatchmakingSuccess({required this.matches});
}

final class MatchmakingFailure extends MatchmakingState {
  final String message;

  MatchmakingFailure({required this.message});
}

final class MatchmakingMatchFound extends MatchmakingState {
  final List<MatchProfile> matches;

  MatchmakingMatchFound({required this.matches});
}
