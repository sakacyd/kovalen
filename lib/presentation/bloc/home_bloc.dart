import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/domain/usecases/get_current_user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentUser _getCurrentUser;
  HomeBloc({required GetCurrentUser getCurrentUser})
    : _getCurrentUser = getCurrentUser,
      super(HomeInitial()) {
    on<HomeEvent>((event, emit) => emit(HomeLoading()));
    on<LoadHomeData>(_onHomeDataRequested);
  }

  FutureOr<void> _onHomeDataRequested(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final userResult = await _getCurrentUser(NoParams());

    if (userResult.isLeft()) {
      final failure = userResult.swap().getOrElse(
        (_) => Failure('Unknown error'),
      );
      emit(HomeFailure(failure.message));
      return;
    }

    final user = userResult.getOrElse((_) => throw Exception('Missing user'));

    emit(HomeSuccess(user));
  }
}
