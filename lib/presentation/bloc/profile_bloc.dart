import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/study_program.dart';
import 'package:kovalen/core/common/entities/university.dart';
import 'package:kovalen/domain/usecases/get_current_user.dart';
import 'package:kovalen/domain/usecases/update_user_profile.dart';
import 'package:kovalen/domain/usecases/get_universities_data.dart';
import 'package:kovalen/domain/usecases/get_study_programs_data.dart';
import 'package:kovalen/domain/usecases/user_sign_out.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  final GetCurrentUser _getCurrentUser;
  final UpdateUserProfile _updateUserProfile;
  final GetUniversitiesData _getUniversitiesData;
  final GetStudyProgramsData _getStudyProgramsData;
  final UserSignOut _userSignOut;
  ProfileBloc({
    required AppUserCubit appUserCubit,
    required GetCurrentUser getCurrentUser,
    required UpdateUserProfile updateUserProfile,
    required GetUniversitiesData getUniversitiesData,
    required GetStudyProgramsData getStudyProgramsData,
    required UserSignOut userSignOut,
  }) : _appUserCubit = appUserCubit,
       _getCurrentUser = getCurrentUser,
       _updateUserProfile = updateUserProfile,
       _getUniversitiesData = getUniversitiesData,
       _getStudyProgramsData = getStudyProgramsData,
       _userSignOut = userSignOut,
       super(ProfileInitial()) {
    on<LoadProfileData>(_onProfileDataRequested);
    on<UpdateProfileData>(_onUpdateProfileData);
    on<ProfileLoadUniversities>(_onLoadUniversities);
    on<ProfileLoadStudyPrograms>(_onLoadStudyPrograms);
    on<ProfileSignOut>(_onProfileSignOut);
  }

  FutureOr<void> _onProfileDataRequested(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final userResult = await _getCurrentUser(NoParams());

    if (userResult.isLeft()) {
      final failure = userResult.swap().getOrElse(
        (_) => Failure('Unknown error'),
      );
      emit(ProfileFailure(failure.message));
      return;
    }

    final user = userResult.getOrElse((_) => throw Exception('Missing user'));
    _appUserCubit.updateUser(user);
    emit(ProfileSuccess(user));
  }

  FutureOr<void> _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    emit(ProfileLoading());
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
        emit(ProfileFailure(failure.message));
        if (currentState is ProfileDataLoaded) {
          emit(currentState);
        }
      },
      (user) {
        _appUserCubit.updateUser(user);
        emit(ProfileSuccess(user));
      },
    );
  }

  FutureOr<void> _onProfileSignOut(
    ProfileSignOut event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _userSignOut(NoParams());

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (r) => _emitSignOutSuccess(emit),
    );
  }

  void _emitSignOutSuccess(Emitter<ProfileState> emit) {
    _appUserCubit.updateUser(null);
    emit(ProfileInitial());
  }

  FutureOr<void> _onLoadUniversities(
    ProfileLoadUniversities event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _getUniversitiesData(NoParams());
    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (universities) {
        final currentState = state;
        if (currentState is ProfileDataLoaded) {
          emit(currentState.copyWith(universities: universities));
        } else {
          emit(ProfileDataLoaded(universities: universities));
        }
      },
    );
  }

  FutureOr<void> _onLoadStudyPrograms(
    ProfileLoadStudyPrograms event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _getStudyProgramsData(
      GetStudyProgramsDataParams(universityId: event.universityId),
    );
    res.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (programs) {
        final currentState = state;
        if (currentState is ProfileDataLoaded) {
          emit(currentState.copyWith(studyPrograms: programs));
        } else {
          emit(ProfileDataLoaded(universities: const [], studyPrograms: programs));
        }
      },
    );
  }
}
