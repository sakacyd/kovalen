import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  MatchmakingBloc() : super(MatchmakingInitial()) {
    on<LoadMatchmakingData>(_onLoadMatchmakingData);
  }

  FutureOr<void> _onLoadMatchmakingData(
    LoadMatchmakingData event,
    Emitter<MatchmakingState> emit,
  ) async {
    emit(MatchmakingLoading());
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final dummyMatches = [
      const MatchProfile(
        name: 'Nadia Larasati',
        semester: '5',
        major: 'Ilmu Komputer',
        distance: '0.8 km (Fakultas MIPA)',
        matchPercentage: 85,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBIFwWqJqSSmmCcJ3gXyskISvdu3eWF1s8X4z0ODVa39VvL9JcmBKoO4AaNXX4w8STFkQkh0XwHNg1ya7yR27QgAly8d-A_C7WAFmQ-6kgoLy127TLJFozN9ffmjchGieCqm3FVsPBA6bxE3AEPlijuO7mHOV-YzwkNfuOI9sqbgbmcd_3OPTAK_4f1VOBdv2VopIjMdMhpIzSOGOtp11EU9XN3KYqR1Wx1jOJjxUiAbFyL2vqDUydTMM7vebra_S140Rf1dv88tnG1',
        interests: ['Machine Learning', 'UI/UX Design', 'Data Science'],
      ),
    ];

    emit(MatchmakingSuccess(matches: dummyMatches));
  }
}
