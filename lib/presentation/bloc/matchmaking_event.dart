part of 'matchmaking_bloc.dart';

@immutable
sealed class MatchmakingEvent {}

final class LoadMatchmakingData extends MatchmakingEvent {}

final class SwipeUserEvent extends MatchmakingEvent {
  final String swipedId;
  final bool isLiked;

  SwipeUserEvent({required this.swipedId, required this.isLiked});
}
