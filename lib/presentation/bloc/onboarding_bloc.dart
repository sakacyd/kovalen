import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/domain/usecases/get_study_programs_data.dart';
import 'package:kovalen/domain/usecases/get_universities_data.dart';
import 'package:kovalen/domain/usecases/get_available_interests.dart';
import 'package:kovalen/domain/usecases/submit_onboarding_data.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SubmitOnboardingData _submitOnboardingData;
  final GetUniversitiesData _getUniversitiesData;
  final GetStudyProgramsData _getStudyProgramsData;
  final GetAvailableInterests _getAvailableInterests;
  final AppUserCubit _appUserCubit;

  OnboardingBloc({
    required SubmitOnboardingData submitOnboardingData,
    required GetUniversitiesData getUniversitiesData,
    required GetStudyProgramsData getStudyProgramsData,
    required GetAvailableInterests getAvailableInterests,
    required AppUserCubit appUserCubit,
  }) : _submitOnboardingData = submitOnboardingData,
       _getUniversitiesData = getUniversitiesData,
       _getStudyProgramsData = getStudyProgramsData,
       _getAvailableInterests = getAvailableInterests,
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
    final interestsRes = await _getAvailableInterests(NoParams());

    Map<String, Map<String, List<Interest>>> availableInterests = {};
    interestsRes.fold(
      (failure) =>
          null, // Just ignore failure for interests, it won't break onboarding entirely
      (interests) => availableInterests = interests,
    );

    res.fold(
      (failure) => emit(OnboardingFailure(failure.message)),
      (universities) => emit(
        OnboardingDataLoaded(
          universities: universities,
          availableInterests: availableInterests,
        ),
      ),
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
        avatarFile: event.avatarFile,
        universityId: event.universityId,
        studyProgramId: event.studyProgramId,
        semester: event.semester,
        gender: event.gender,
        tujuanBelajar: event.tujuanBelajar,
        gayaBelajar: event.gayaBelajar,
        gpa: event.gpa,
        interestIds: event.interests,
      ),
    );

    res.fold(
      (failure) {
        emit(OnboardingFailure(failure.message));
        if (currentState is OnboardingDataLoaded) {
          emit(currentState);
        }
      },
      (user) {
        _appUserCubit.updateUser(user);
        emit(OnboardingSuccess());
      },
    );
  }
}
