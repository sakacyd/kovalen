import 'dart:async';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  StreamSubscription<List<Map<String, dynamic>>>? _userSubscription;

  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      _userSubscription?.cancel();
      _userSubscription = null;
      emit(AppUserLoggedOut());
    } else {
      _setupRealtimeListener(user);
      emit(AppUserLoggedIn(user: user));
    }
  }

  void _setupRealtimeListener(User user) {
    if (_userSubscription != null) return; // Already listening

    _userSubscription = Supabase.instance.client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .listen((List<Map<String, dynamic>> data) async {
          if (data.isNotEmpty) {
            final newRecord = data.first;
            final status = newRecord['status'] as String?;
            final suspendedUntilStr = newRecord['suspended_until'] as String?;

            if (status == 'banned') {
              await Supabase.instance.client.auth.signOut();
              updateUser(null);
            } else if (status == 'suspended' && suspendedUntilStr != null) {
              final suspendedUntil = DateTime.parse(suspendedUntilStr);
              if (suspendedUntil.isAfter(DateTime.now())) {
                await Supabase.instance.client.auth.signOut();
                updateUser(null);
              }
            }
          }
        });
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
