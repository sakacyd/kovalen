import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/get_matching_preferences.dart';
import 'package:kovalen/domain/usecases/save_matching_preferences.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';

part 'matching_preferences_event.dart';
part 'matching_preferences_state.dart';

class MatchingPreferencesBloc
    extends Bloc<MatchingPreferencesEvent, MatchingPreferencesState> {
  final GetMatchingPreferences _getMatchingPreferences;
  final SaveMatchingPreferences _saveMatchingPreferences;
  final AppUserCubit _appUserCubit;

  MatchingPreferencesBloc({
    required GetMatchingPreferences getMatchingPreferences,
    required SaveMatchingPreferences saveMatchingPreferences,
    required AppUserCubit appUserCubit,
  }) : _getMatchingPreferences = getMatchingPreferences,
       _saveMatchingPreferences = saveMatchingPreferences,
       _appUserCubit = appUserCubit,
       super(MatchingPreferencesInitial()) {
    on<LoadMatchingPreferences>(_onLoadMatchingPreferences);
    on<SaveMatchingPreferencesEvent>(_onSaveMatchingPreferencesEvent);
  }

  FutureOr<void> _onLoadMatchingPreferences(
    LoadMatchingPreferences event,
    Emitter<MatchingPreferencesState> emit,
  ) async {
    emit(MatchingPreferencesLoading());
    final res = await _getMatchingPreferences(NoParams());

    res.fold(
      (failure) => emit(MatchingPreferencesFailure(failure.message)),
      (distance) => emit(MatchingPreferencesLoaded(distance)),
    );
  }

  FutureOr<void> _onSaveMatchingPreferencesEvent(
    SaveMatchingPreferencesEvent event,
    Emitter<MatchingPreferencesState> emit,
  ) async {
    emit(MatchingPreferencesLoading());
    final res = await _saveMatchingPreferences(
      SaveMatchingPreferencesParams(maxDistance: event.maxDistance),
    );

    res.fold(
      (failure) => emit(MatchingPreferencesFailure(failure.message)),
      (success) {
        // Update user state inside cubit
        final currentState = _appUserCubit.state;
        if (currentState is AppUserLoggedIn) {
          final updatedUser = currentState.user.copyWith(
            maxDistancePreference: event.maxDistance,
          );
          _appUserCubit.updateUser(updatedUser);
        }
        emit(MatchingPreferencesSaved(event.maxDistance));
      },
    );
  }
}
