import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/usecases/rating/rate_user.dart';
import 'package:kovalen/domain/usecases/rating/get_room_participants.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RateUser _rateUser;
  final GetRoomParticipants _getRoomParticipants;

  RatingBloc({
    required RateUser rateUser,
    required GetRoomParticipants getRoomParticipants,
  }) : _rateUser = rateUser,
       _getRoomParticipants = getRoomParticipants,
       super(RatingInitial()) {
    on<FetchRoomParticipantsEvent>(_onFetchRoomParticipants);
    on<SubmitUserRatingEvent>(_onSubmitUserRating);
  }

  void _onFetchRoomParticipants(
    FetchRoomParticipantsEvent event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading());
    final result = await _getRoomParticipants(
      GetRoomParticipantsParams(roomId: event.roomId),
    );

    result.fold(
      (failure) => emit(RatingError(failure.message)),
      (participants) => emit(RoomParticipantsLoaded(participants)),
    );
  }

  void _onSubmitUserRating(
    SubmitUserRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    final currentState = state;
    List<User> participants = [];
    if (currentState is RoomParticipantsLoaded) {
      participants = currentState.participants;
    }

    emit(RatingLoading());
    final result = await _rateUser(
      RateUserParams(
        rateeId: event.rateeId,
        rating: event.rating,
        review: event.review,
      ),
    );

    result.fold((failure) => emit(RatingError(failure.message)), (_) {
      emit(RatingSuccess('Berhasil memberikan rating!'));
      // Restore participants state after rating so user can rate others
      if (participants.isNotEmpty) {
        emit(RoomParticipantsLoaded(participants));
      }
    });
  }
}
