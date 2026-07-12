part of 'rating_bloc.dart';

abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RoomParticipantsLoaded extends RatingState {
  final List<User> participants;
  RoomParticipantsLoaded(this.participants);
}

class RatingSuccess extends RatingState {
  final String message;
  RatingSuccess(this.message);
}

class RatingError extends RatingState {
  final String message;
  RatingError(this.message);
}
