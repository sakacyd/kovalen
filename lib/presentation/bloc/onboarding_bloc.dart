import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingSubmit>(_onOnboardingSubmit);
  }

  FutureOr<void> _onOnboardingSubmit(
    OnboardingSubmit event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    try {
      // Simulate API call for saving onboarding data
      await Future.delayed(const Duration(seconds: 1));
      
      // If we had a usecase, we would call it here
      // final result = await _submitOnboardingData(params);
      
      emit(OnboardingSuccess());
    } catch (e) {
      emit(OnboardingFailure(e.toString()));
    }
  }
}
