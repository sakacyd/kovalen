import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/university_model.dart';
import 'package:kovalen/data/models/study_program_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileSettingsRemoteDataSource {
  Future<UserModel> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
  });
  Future<List<UniversityModel>> getUniversities();
  Future<List<StudyProgramModel>> getStudyProgramsByUniversityId(
    String universityId,
  );
  Future<void> signOut();
}

class ProfileSettingsRemoteDataSourceImpl implements ProfileSettingsRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileSettingsRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
  }) async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) {
        throw ServerException('User not logged in');
      }

      final userId = session.user.id;

      final response = await supabaseClient
          .from('users')
          .update({
            'full_name': fullName,
            'avatar_url': avatarUrl,
            'university_id': universityId,
            'study_program_id': studyProgramId,
            'semester': semester,
            'gpa': gpa,
          })
          .eq('id', userId)
          .select();

      return UserModel.fromJson(response.first).copyWith(
        email: session.user.email,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UniversityModel>> getUniversities() async {
    try {
      final response = await supabaseClient.from('universities').select();
      return response.map((e) => UniversityModel.fromJson(e)).toList();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StudyProgramModel>> getStudyProgramsByUniversityId(
    String universityId,
  ) async {
    try {
      final response = await supabaseClient
          .from('study_programs')
          .select()
          .eq('university_id', universityId);
      return response.map((e) => StudyProgramModel.fromJson(e)).toList();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
