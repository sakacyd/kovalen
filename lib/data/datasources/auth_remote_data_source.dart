import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUser();
  Future<void> changePassword({required String newPassword});
  Future<UserModel> updateUserLocation({
    required double latitude,
    required double longitude,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('User is null!');
      }

      final userData = await supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id);

      return UserModel.fromJson(
        userData.first,
      ).copyWith(email: response.user!.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'full_name': fullName},
      );

      if (response.user == null) {
        throw ServerException('User is null!');
      }

      final userData = await supabaseClient
          .from('users')
          .select()
          .eq('id', response.user!.id);

      return UserModel.fromJson(
        userData.first,
      ).copyWith(email: response.user!.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword({required String newPassword}) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final session = currentUserSession;
      if (session == null) throw ServerException('User not logged in');

      final updateData = {
        'latitude': latitude,
        'longitude': longitude,
        'last_location_update': DateTime.now().toUtc().toIso8601String(),
      };

      final response = await supabaseClient
          .from('users')
          .update(updateData)
          .eq('id', session.user.id)
          .select()
          .single();

      return UserModel.fromJson(response).copyWith(email: session.user.email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
