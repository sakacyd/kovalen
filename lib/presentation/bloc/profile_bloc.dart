import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/domain/usecases/get_current_user.dart';
import 'package:kovalen/domain/usecases/get_user_interests.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  final GetCurrentUser _getCurrentUser;
  final GetUserInterests _getUserInterests;

  ProfileBloc({
    required AppUserCubit appUserCubit,
    required GetCurrentUser getCurrentUser,
    required GetUserInterests getUserInterests,
  }) : _appUserCubit = appUserCubit,
       _getCurrentUser = getCurrentUser,
       _getUserInterests = getUserInterests,
       super(ProfileInitial()) {
    on<LoadProfileData>(_onProfileDataRequested);
  }

  FutureOr<void> _onProfileDataRequested(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final userRes = await _getCurrentUser(NoParams());

    await userRes.fold((l) async => emit(ProfileFailure(l.message)), (
      user,
    ) async {
      _appUserCubit.updateUser(user);
      final interestsRes = await _getUserInterests(NoParams());
      interestsRes.fold(
        (l) => emit(
          ProfileFailure(l.message),
        ), // Or just emit success with empty interests if we don't want to fail the whole profile
        (interests) => emit(ProfileSuccess(user, interests: interests)),
      );
    });
  }
}
