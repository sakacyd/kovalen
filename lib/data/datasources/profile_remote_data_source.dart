import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/university_model.dart';
import 'package:kovalen/data/models/study_program_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel?> getCurrentUserData();
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

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select(
              '*, universities(name), study_programs(name, education_level)',
            )
            .eq('id', currentUserSession!.user.id);

        final universityName = userData.first['universities']?['name'];
        final studyProgramData = userData.first['study_programs'];
        String studyProgramDisplay = 'Program Studi Belum Diisi';

        if (studyProgramData != null) {
          final level = studyProgramData['education_level'] ?? '';
          final name = studyProgramData['name'] ?? '';

          if (level.isNotEmpty && name.isNotEmpty) {
            studyProgramDisplay = '$level - $name';
          } else {
            studyProgramDisplay = name.isNotEmpty ? name : level;
          }
        }

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
          fullName: userData.first['full_name'],
          avatarUrl: userData.first['avatar_url'],
          semester: userData.first['semester'],
          gpa: (userData.first['gpa'] as num?)?.toDouble() ?? 0.0,
          universityId: userData.first['university_id'],
          studyProgramId: userData.first['study_program_id'],
          universityName: universityName,
          studyProgramName: studyProgramDisplay,
        );
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

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
