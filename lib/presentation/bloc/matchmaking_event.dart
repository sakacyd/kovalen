part of 'matchmaking_bloc.dart';

@immutable
sealed class MatchmakingEvent {}

final class LoadMatchmakingData extends MatchmakingEvent {}
