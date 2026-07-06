import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/core/common/entities/home_stats.dart';
import 'package:kovalen/core/error/failures.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/domain/usecases/get_current_user.dart';
import 'package:kovalen/domain/usecases/watch_home_data.dart';
import 'package:kovalen/core/common/entities/home_data.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:fpdart/fpdart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentUser _getCurrentUser;
  final WatchHomeData _watchHomeData;
  final AppUserCubit _appUserCubit;
  
  StreamSubscription? _homeDataSubscription;
  HomeBloc({
    required GetCurrentUser getCurrentUser,
    required WatchHomeData watchHomeData,
    required AppUserCubit appUserCubit,
  })
    : _getCurrentUser = getCurrentUser,
      _watchHomeData = watchHomeData,
      _appUserCubit = appUserCubit,
      super(HomeInitial()) {
    on<HomeEvent>((event, emit) => emit(HomeLoading()));
    on<LoadHomeData>(_onHomeDataRequested);
    on<_UpdateHomeData>(_onUpdateHomeData);
  }

  @override
  Future<void> close() {
    _homeDataSubscription?.cancel();
    return super.close();
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
    _appUserCubit.updateUser(user);

    await _homeDataSubscription?.cancel();
    
    _homeDataSubscription = _watchHomeData(NoParams()).listen((result) {
      add(_UpdateHomeData(user, result));
    });
  }

  FutureOr<void> _onUpdateHomeData(
    _UpdateHomeData event,
    Emitter<HomeState> emit,
  ) {
    event.dataResult.fold(
      (failure) => emit(HomeFailure(failure.message)),
      (data) => emit(HomeSuccess(event.user, data.stats, data.activeGroups)),
    );
  }
}
