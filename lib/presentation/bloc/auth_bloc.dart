import 'dart:async';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/usecase/usecase.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:kovalen/domain/usecases/current_user.dart';
import 'package:kovalen/domain/usecases/user_sign_in.dart';
import 'package:kovalen/domain/usecases/user_sign_up.dart';
import 'package:kovalen/domain/usecases/user_sign_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserSignOut userSignOut,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _userSignOut = userSignOut,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  FutureOr<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
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
    print('==== 1. PROSES LOGIN DIMULAI ====');
    emit(AuthLoading()); // Mengubah tombol jadi loading

    try {
      print('==== 2. MENGIRIM REQUEST KE SUPABASE ====');
      final res = await _userSignIn(
        UserSignInParams(email: event.email, password: event.password),
      );

      print('==== 3. DAPAT RESPON DARI BLoC/USECASE ====');
      res.fold(
        (l) {
          print('==== 4. BLoC EMIT FAILURE: ${l.message} ====');
          emit(AuthFailure(l.message));
        },
        (r) {
          print('==== 4. BLoC EMIT SUCCESS ====');
          _emitAuthSuccess(r, emit);
        },
      );
    } catch (e) {
      // Menangkap error liar yang mungkin tidak ter-cover oleh Either<Failure, User>
      print('==== FATAL ERROR BLoC: $e ====');
      emit(AuthFailure('Terjadi kesalahan sistem: $e'));
    }
  }

  FutureOr<void> _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold((l) {
      emit(AuthFailure(l.message));
    }, (r) => _emitAuthSuccess(r, emit));
  }

  FutureOr<void> _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignOut(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitSignOutSuccess(emit),
    );
  }

  void _emitSignOutSuccess(Emitter<AuthState> emit) {
    _appUserCubit.updateUser(null);
    emit(AuthInitial());
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
