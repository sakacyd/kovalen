import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/get_potential_matches.dart';
import 'package:kovalen/domain/usecases/swipe_user.dart';
import 'package:kovalen/core/common/entities/match_profile.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final GetPotentialMatches _getPotentialMatches;
  final SwipeUser _swipeUser;

  MatchmakingBloc({
    required GetPotentialMatches getPotentialMatches,
    required SwipeUser swipeUser,
  })  : _getPotentialMatches = getPotentialMatches,
        _swipeUser = swipeUser,
        super(MatchmakingInitial()) {
    on<LoadMatchmakingData>(_onLoadMatchmakingData);
    on<SwipeUserEvent>(_onSwipeUser);
  }

  FutureOr<void> _onLoadMatchmakingData(
    LoadMatchmakingData event,
    Emitter<MatchmakingState> emit,
  ) async {
    emit(MatchmakingLoading());
    
    final res = await _getPotentialMatches(NoParams());
    
    res.fold(
      (failure) => emit(MatchmakingFailure(message: failure.message)),
      (matches) => emit(MatchmakingSuccess(matches: matches)),
    );
  }

  FutureOr<void> _onSwipeUser(
    SwipeUserEvent event,
    Emitter<MatchmakingState> emit,
  ) async {
    // Keep current matches in state
    if (state is MatchmakingSuccess) {
      final currentState = state as MatchmakingSuccess;
      final remainingMatches = currentState.matches.where((m) => m.user.id != event.swipedId).toList();
      
      // Emit state to update UI instantly (optimistic update)
      emit(MatchmakingSuccess(matches: remainingMatches));
      
      // Perform API call in background
      final res = await _swipeUser(SwipeUserParams(swipedId: event.swipedId, isLiked: event.isLiked));
      
      // If error, could revert, but typical apps just show error or log
      res.fold(
        (failure) {
          // You could emit a failure here or handle silently
        },
        (_) {},
      );
    }
  }
}
