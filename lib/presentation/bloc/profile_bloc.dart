import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/domain/usecases/get_current_user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUser _getCurrentUser;
  ProfileBloc({required GetCurrentUser getCurrentUser})
    : _getCurrentUser = getCurrentUser,
      super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) => emit(ProfileLoading()));
    on<LoadProfileData>(_onProfileDataRequested);
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

    emit(ProfileSuccess(user));
  }
}
