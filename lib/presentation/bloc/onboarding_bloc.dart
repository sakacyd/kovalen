import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/domain/usecases/get_study_programs_data.dart';
import 'package:kovalen/domain/usecases/get_universities_data.dart';
import 'package:kovalen/domain/usecases/submit_onboarding_data.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SubmitOnboardingData _submitOnboardingData;
  final GetUniversitiesData _getUniversitiesData;
  final GetStudyProgramsData _getStudyProgramsData;
  final AppUserCubit _appUserCubit;

  OnboardingBloc({
    required SubmitOnboardingData submitOnboardingData,
    required GetUniversitiesData getUniversitiesData,
    required GetStudyProgramsData getStudyProgramsData,
    required AppUserCubit appUserCubit,
  })  : _submitOnboardingData = submitOnboardingData,
        _getUniversitiesData = getUniversitiesData,
        _getStudyProgramsData = getStudyProgramsData,
        _appUserCubit = appUserCubit,
        super(OnboardingInitial()) {
    on<OnboardingLoadUniversities>(_onLoadUniversities);
    on<OnboardingLoadStudyPrograms>(_onLoadStudyPrograms);
    on<OnboardingSubmit>(_onOnboardingSubmit);
  }

  FutureOr<void> _onLoadUniversities(
    OnboardingLoadUniversities event,
    Emitter<OnboardingState> emit,
  ) async {
    final res = await _getUniversitiesData(NoParams());
    res.fold(
      (failure) => emit(OnboardingFailure(failure.message)),
      (universities) => emit(OnboardingDataLoaded(universities: universities)),
    );
  }

  FutureOr<void> _onLoadStudyPrograms(
    OnboardingLoadStudyPrograms event,
    Emitter<OnboardingState> emit,
  ) async {
    final currentState = state;
    if (currentState is OnboardingDataLoaded) {
      final res = await _getStudyProgramsData(
        GetStudyProgramsDataParams(universityId: event.universityId),
      );
      res.fold(
        (failure) => emit(OnboardingFailure(failure.message)),
        (programs) => emit(currentState.copyWith(studyPrograms: programs)),
      );
    }
  }

  FutureOr<void> _onOnboardingSubmit(
    OnboardingSubmit event,
    Emitter<OnboardingState> emit,
  ) async {
    final currentState = state;
    emit(OnboardingLoading());
    final res = await _submitOnboardingData(
      SubmitOnboardingDataParams(
        fullName: event.fullName,
        avatarUrl: event.avatarUrl,
        universityId: event.universityId,
        studyProgramId: event.studyProgramId,
        semester: event.semester,
        gpa: event.gpa,
      ),
    );

    res.fold(
      (failure) {
        emit(OnboardingFailure(failure.message));
        if (currentState is OnboardingDataLoaded) {
          emit(currentState); // Restore state if failed
        }
      },
      (user) {
        _appUserCubit.updateUser(user);
        emit(OnboardingSuccess());
      },
    );
  }
}
