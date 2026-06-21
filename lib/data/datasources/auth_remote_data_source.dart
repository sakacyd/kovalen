import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();
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
      print('==== 3.1 MENGIRIM PAYLOAD KE SUPABASE ====');
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      print('==== 3.2 DAPAT BALASAN DARI SUPABASE ====');
      if (response.user == null) {
        throw ServerException('User is null!');
      }
      
      print('==== 3.3 PARSING JSON KE USERMODEL ====');
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      print('==== 3.X AUTH EXCEPTION: ${e.message} ====');
      throw ServerException(e.message);
    } catch (e) {
      print('==== 3.X GENERAL EXCEPTION: $e ====');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );

      if (response.user == null) {
        throw ServerException('User is null!');
      }

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
          fullName: userData.first['full_name'],
          avatarUrl: userData.first['avatar_url'],
          phoneNumber: userData.first['phone_number'],
          studyProgram: userData.first['study_program'],
          semester: userData.first['semester'],
          latitude: userData.first['latitude'],
          longitude: userData.first['longitude'],
          lastLocationUpdate: userData.first['last_location_update'],
        );
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
