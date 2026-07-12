part of 'rating_bloc.dart';

abstract class RatingEvent {}

class FetchRoomParticipantsEvent extends RatingEvent {
  final String roomId;
  FetchRoomParticipantsEvent(this.roomId);
}

class SubmitUserRatingEvent extends RatingEvent {
  final String rateeId;
  final int rating;
  final String? review;

  SubmitUserRatingEvent({
    required this.rateeId,
    required this.rating,
    this.review,
  });
}
