part of 'rating_bloc.dart';

abstract class RatingEvent {}

class FetchRoomParticipantsEvent extends RatingEvent {
  final String roomId;
  FetchRoomParticipantsEvent(this.roomId);
}

class SubmitUserRatingEvent extends RatingEvent {
  final String targetUserId;
  final double score;
  final String? feedback;

  SubmitUserRatingEvent({
    required this.targetUserId,
    required this.score,
    this.feedback,
  });
}
