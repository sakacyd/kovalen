import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/get_potential_matches.dart';
import 'package:kovalen/domain/usecases/swipe_user.dart';
import 'package:kovalen/domain/usecases/watch_new_matches.dart';
import 'package:kovalen/core/common/entities/match_profile.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final GetPotentialMatches _getPotentialMatches;
  final SwipeUser _swipeUser;
  final WatchNewMatches _watchNewMatches;
  StreamSubscription? _newMatchesSubscription;

  MatchmakingBloc({
    required GetPotentialMatches getPotentialMatches,
    required SwipeUser swipeUser,
    required WatchNewMatches watchNewMatches,
  })  : _getPotentialMatches = getPotentialMatches,
        _swipeUser = swipeUser,
        _watchNewMatches = watchNewMatches,
        super(MatchmakingInitial()) {
    on<LoadMatchmakingData>(_onLoadMatchmakingData);
    on<SwipeUserEvent>(_onSwipeUser);
    on<MatchmakingNewMatchReceived>(_onMatchmakingNewMatchReceived);
    
    _subscribeToNewMatches();
  }

  void _subscribeToNewMatches() {
    _newMatchesSubscription = _watchNewMatches(NoParams()).listen((result) {
      result.fold(
        (failure) {}, // Ignore errors for the stream
        (_) {
          add(MatchmakingNewMatchReceived());
        },
      );
    });
  }

  @override
  Future<void> close() {
    _newMatchesSubscription?.cancel();
    return super.close();
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
    if (state is MatchmakingSuccess || state is MatchmakingMatchFound) {
      final matches = (state is MatchmakingSuccess)
          ? (state as MatchmakingSuccess).matches
          : (state as MatchmakingMatchFound).matches;
          
      final remainingMatches = matches.where((m) => m.user.id != event.swipedId).toList();
      
      // Emit state to update UI instantly (optimistic update)
      emit(MatchmakingSuccess(matches: remainingMatches));
      
      // Perform API call in background
      final res = await _swipeUser(SwipeUserParams(swipedId: event.swipedId, isLiked: event.isLiked));
      
      // If error, could revert, but typical apps just show error or log
      res.fold(
        (failure) {
          // You could emit a failure here or handle silently
        },
        (isMatch) {
          if (isMatch) {
            // Toast will be triggered either here or by the realtime stream. 
            // In case realtime stream is delayed, this optimistic check will still show the toast.
            emit(MatchmakingMatchFound(matches: remainingMatches));
            // Automatically reset to normal success state after
            emit(MatchmakingSuccess(matches: remainingMatches));
          }
        },
      );
    }
  }

  FutureOr<void> _onMatchmakingNewMatchReceived(
    MatchmakingNewMatchReceived event,
    Emitter<MatchmakingState> emit,
  ) {
    if (state is MatchmakingSuccess || state is MatchmakingMatchFound) {
      final matches = (state is MatchmakingSuccess)
          ? (state as MatchmakingSuccess).matches
          : (state as MatchmakingMatchFound).matches;
          
      emit(MatchmakingMatchFound(matches: matches));
      emit(MatchmakingSuccess(matches: matches));
    }
  }
}
