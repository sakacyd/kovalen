import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/interest_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel?> getCurrentUserData();
  Future<List<InterestModel>> getUserInterests();
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
  Future<List<InterestModel>> getUserInterests() async {
    try {
      final session = currentUserSession;
      if (session == null) {
        throw ServerException('User not logged in');
      }

      final response = await supabaseClient
          .from('user_interests')
          .select('interests(id, name, category_id, interest_categories(id, name, type))')
          .eq('user_id', session.user.id);

      final List<InterestModel> interests = [];
      for (var row in response) {
        if (row['interests'] != null) {
          interests.add(InterestModel.fromJson(row['interests']));
        }
      }

      return interests;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
