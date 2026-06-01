import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      // Simulasi panggilan Network/API
      await Future.delayed(const Duration(seconds: 2));

      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        emit(AuthAuthenticated("Budi Santoso"));
      } else {
        emit(AuthError("Kredensial tidak valid. Silakan periksa kembali."));
      }
    });
  }
}
