import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/domain/usecases/get_current_user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppUserCubit _appUserCubit;
  final GetCurrentUser _getCurrentUser;

  ProfileBloc({
    required AppUserCubit appUserCubit,
    required GetCurrentUser getCurrentUser,
  }) : _appUserCubit = appUserCubit,
       _getCurrentUser = getCurrentUser,
       super(ProfileInitial()) {
    on<LoadProfileData>(_onProfileDataRequested);
  }

  FutureOr<void> _onProfileDataRequested(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final res = await _getCurrentUser(NoParams());

    res.fold(
      (l) => emit(ProfileFailure(l.message)),
      (r) => _emitLoadProfileDataSuccess(emit, r),
    );
  }

  void _emitLoadProfileDataSuccess(Emitter<ProfileState> emit, User user) {
    _appUserCubit.updateUser(user);
    emit(ProfileSuccess(user));
  }
}
