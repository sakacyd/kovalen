part of 'matching_preferences_bloc.dart';

abstract class MatchingPreferencesEvent {}

class LoadMatchingPreferences extends MatchingPreferencesEvent {}

class SaveMatchingPreferencesEvent extends MatchingPreferencesEvent {
  final double maxDistance;

  SaveMatchingPreferencesEvent(this.maxDistance);
}
