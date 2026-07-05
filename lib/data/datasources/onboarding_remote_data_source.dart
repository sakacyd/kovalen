import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/university_model.dart';
import 'package:kovalen/data/models/study_program_model.dart';
import 'package:kovalen/data/models/interest_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class OnboardingRemoteDataSource {
  Future<UserModel> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
    required List<String> interestIds,
  });

  Future<List<UniversityModel>> getUniversities();
  Future<List<StudyProgramModel>> getStudyProgramsByUniversityId(String universityId);
  Future<List<InterestModel>> getAvailableInterests();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final SupabaseClient supabaseClient;

  OnboardingRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> updateUserData({
    required String fullName,
    required String avatarUrl,
    required String universityId,
    required String studyProgramId,
    required int semester,
    required double gpa,
    required List<String> interestIds,
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

      await supabaseClient.from('user_interests').delete().eq('user_id', userId);
      
      if (interestIds.isNotEmpty) {
        final interestInserts = interestIds.map((id) => {
          'user_id': userId,
          'interest_id': id,
        }).toList();
        await supabaseClient.from('user_interests').insert(interestInserts);
      }

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
  Future<List<StudyProgramModel>> getStudyProgramsByUniversityId(String universityId) async {
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
  Future<List<InterestModel>> getAvailableInterests() async {
    try {
      final response = await supabaseClient
          .from('interests')
          .select('id, name, category_id, interest_categories(id, name, type)');
      return response.map((e) => InterestModel.fromJson(e)).toList();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
