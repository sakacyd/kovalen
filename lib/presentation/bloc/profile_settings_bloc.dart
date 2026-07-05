import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/domain/usecases/update_user_profile.dart';
import 'package:kovalen/domain/usecases/get_universities_data.dart';
import 'package:kovalen/domain/usecases/get_study_programs_data.dart';
import 'package:kovalen/domain/usecases/user_sign_out.dart';
import 'package:kovalen/domain/repository/profile_settings_repository.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  final AppUserCubit _appUserCubit;
  final UpdateUserProfile _updateUserProfile;
  final GetUniversitiesData<ProfileSettingsRepository> _getUniversitiesData;
  final GetStudyProgramsData<ProfileSettingsRepository> _getStudyProgramsData;
  final UserSignOut _userSignOut;

  ProfileSettingsBloc({
    required AppUserCubit appUserCubit,
    required UpdateUserProfile updateUserProfile,
    required GetUniversitiesData<ProfileSettingsRepository> getUniversitiesData,
    required GetStudyProgramsData<ProfileSettingsRepository> getStudyProgramsData,
    required UserSignOut userSignOut,
  }) : _appUserCubit = appUserCubit,
       _updateUserProfile = updateUserProfile,
       _getUniversitiesData = getUniversitiesData,
       _getStudyProgramsData = getStudyProgramsData,
       _userSignOut = userSignOut,
       super(ProfileSettingsInitial()) {
    on<UpdateProfileSettingsData>(_onUpdateProfileSettingsData);
    on<ProfileSettingsLoadUniversities>(_onLoadUniversities);
    on<ProfileSettingsLoadStudyPrograms>(_onLoadStudyPrograms);
    on<ProfileSettingsSignOut>(_onProfileSettingsSignOut);
  }

  FutureOr<void> _onUpdateProfileSettingsData(
    UpdateProfileSettingsData event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final currentState = state;
    emit(ProfileSettingsLoading());
    final res = await _updateUserProfile(
      UpdateUserProfileParams(
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
        emit(ProfileSettingsFailure(failure.message));
        if (currentState is ProfileSettingsDataLoaded) {
          emit(currentState);
        }
      },
      (user) {
        _appUserCubit.updateUser(user);
        emit(UpdateProfileSettingsSuccess(user));
      },
    );
  }

  FutureOr<void> _onProfileSettingsSignOut(
    ProfileSettingsSignOut event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final res = await _userSignOut(NoParams());

    res.fold(
      (l) => emit(ProfileSettingsFailure(l.message)),
      (r) {
        _appUserCubit.updateUser(null);
        emit(ProfileSettingsInitial());
      },
    );
  }

  FutureOr<void> _onLoadUniversities(
    ProfileSettingsLoadUniversities event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final res = await _getUniversitiesData(NoParams());
    res.fold((failure) => emit(ProfileSettingsFailure(failure.message)), (
      universities,
    ) {
      final currentState = state;
      if (currentState is ProfileSettingsDataLoaded) {
        emit(currentState.copyWith(universities: universities));
      } else {
        emit(ProfileSettingsDataLoaded(universities: universities));
      }
    });
  }

  FutureOr<void> _onLoadStudyPrograms(
    ProfileSettingsLoadStudyPrograms event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final res = await _getStudyProgramsData(
      GetStudyProgramsDataParams(universityId: event.universityId),
    );
    res.fold((failure) => emit(ProfileSettingsFailure(failure.message)), (programs) {
      final currentState = state;
      if (currentState is ProfileSettingsDataLoaded) {
        emit(currentState.copyWith(studyPrograms: programs));
      } else {
        emit(
          ProfileSettingsDataLoaded(universities: const [], studyPrograms: programs),
        );
      }
    });
  }
}
