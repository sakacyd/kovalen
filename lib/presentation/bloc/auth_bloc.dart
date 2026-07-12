import 'dart:async';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/usecases/current_user.dart';
import 'package:kovalen/domain/usecases/user_sign_in.dart';
import 'package:kovalen/domain/usecases/user_sign_up.dart';
import 'package:kovalen/domain/usecases/change_password.dart';
import 'package:kovalen/domain/usecases/update_user_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:intl/intl.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final ChangePassword _changePassword;
  final AppUserCubit _appUserCubit;
  final UpdateUserLocation _updateUserLocation;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required ChangePassword changePassword,
    required AppUserCubit appUserCubit,
    required UpdateUserLocation updateUserLocation,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _currentUser = currentUser,
       _changePassword = changePassword,
       _appUserCubit = appUserCubit,
       _updateUserLocation = updateUserLocation,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthChangePassword>(_onChangePassword);
  }

  FutureOr<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  FutureOr<void> _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignIn(
      UserSignInParams(email: event.email, password: event.password),
    );
    await res.fold(
      (l) async => emit(AuthFailure(l.message)),
      (user) async {
        if (!await _checkUserStatus(user, emit)) return;
        _emitAuthSuccess(user, emit);
      },
    );
  }

  FutureOr<void> _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    await res.fold(
      (l) async {
        _appUserCubit.updateUser(null);
        emit(AuthFailure(l.message));
      },
      (user) async {
        if (!await _checkUserStatus(user, emit)) return;

        // Optimistic UI updates
        _emitAuthSuccess(user, emit);

        // Update location in the background
        bool serviceEnabled;
        LocationPermission permission;

        try {
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
            }

            if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
              Position position = await Geolocator.getCurrentPosition();
              
              final locRes = await _updateUserLocation(
                UpdateUserLocationParams(
                  latitude: position.latitude,
                  longitude: position.longitude,
                ),
              );

              locRes.fold(
                (l) => debugPrint('Location update failed: ${l.message}'),
                (updatedUser) {
                  _emitAuthSuccess(updatedUser, emit);
                },
              );
            }
          }
        } catch (e) {
          debugPrint('Failed to get location: $e');
        }
      },
    );
  }

  Future<bool> _checkUserStatus(User user, Emitter<AuthState> emit) async {
    if (user.status == 'banned') {
      await Supabase.instance.client.auth.signOut();
      _appUserCubit.updateUser(null);
      emit(const AuthFailure('Akun Anda telah diblokir secara permanen.'));
      return false;
    }

    if (user.status == 'suspended' && user.suspendedUntil != null) {
      if (user.suspendedUntil!.isAfter(DateTime.now())) {
        await Supabase.instance.client.auth.signOut();
        _appUserCubit.updateUser(null);
        final formatter = DateFormat('dd MMM yyyy, HH:mm');
        final dateStr = formatter.format(user.suspendedUntil!.toLocal());
        emit(AuthFailure('Akun Anda ditangguhkan hingga $dateStr.'));
        return false;
      }
    }
    return true;
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  FutureOr<void> _onChangePassword(
    AuthChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _changePassword(
      ChangePasswordParams(newPassword: event.newPassword),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        final currentUser = _appUserCubit.state;
        if (currentUser is AppUserLoggedIn) {
          emit(AuthSuccess(currentUser.user));
        } else {
          emit(AuthInitial());
        }
      },
    );
  }
}
