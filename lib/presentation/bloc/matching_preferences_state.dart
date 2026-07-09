part of 'matching_preferences_bloc.dart';

abstract class MatchingPreferencesState {}

class MatchingPreferencesInitial extends MatchingPreferencesState {}

class MatchingPreferencesLoading extends MatchingPreferencesState {}

class MatchingPreferencesLoaded extends MatchingPreferencesState {
  final double maxDistance;

  MatchingPreferencesLoaded(this.maxDistance);
}

class MatchingPreferencesFailure extends MatchingPreferencesState {
  final String message;

  MatchingPreferencesFailure(this.message);
}
