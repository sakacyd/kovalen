import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/match_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MatchmakingRemoteDataSource {
  Future<List<MatchProfileModel>> getPotentialMatches();
  Future<void> swipeUser(String swipedId, bool isLiked);
}

class MatchmakingRemoteDataSourceImpl implements MatchmakingRemoteDataSource {
  final SupabaseClient supabaseClient;

  MatchmakingRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<MatchProfileModel>> getPotentialMatches() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');

      final currentUserId = session.user.id;

      // Fetch users that are NOT the current user, and NOT already swiped by the current user.
      // Note: We use a custom query or filter using Postgrest.
      // Because Supabase RPC is best for complex exclusions, we might need to filter locally if no RPC exists,
      // but assuming we can fetch all and filter, or use a basic query.
      
      // Let's fetch swiped IDs first to exclude them
      final swipedResponse = await supabaseClient
          .from('swipes')
          .select('swiped_id')
          .eq('swiper_id', currentUserId);
          
      final List<String> swipedIds = (swipedResponse as List).map((e) => e['swiped_id'] as String).toList();
      swipedIds.add(currentUserId); // exclude self

      // Fetch potential matches
      var query = supabaseClient
          .from('users')
          .select('*, universities(name), study_programs(name, education_level), user_interests(interests(*, interest_categories(*)))');
          
      final response = await query;
      
      List<MatchProfileModel> potentials = [];
      
      for (var row in response) {
        if (!swipedIds.contains(row['id'])) {
          // Parse university and study program names similar to Profile
          final universityName = row['universities']?['name'];
          final studyProgramData = row['study_programs'];
          String studyProgramDisplay = row['study_program_id'] ?? '';
          
          if (studyProgramData != null) {
            final level = studyProgramData['education_level'] ?? '';
            final name = studyProgramData['name'] ?? '';
            if (level.isNotEmpty && name.isNotEmpty) {
              studyProgramDisplay = '$level - $name';
            } else {
              studyProgramDisplay = name.isNotEmpty ? name : level;
            }
          }
          
          row['university_name'] = universityName;
          row['study_program_name'] = studyProgramDisplay;
          
          potentials.add(MatchProfileModel.fromJson(row));
        }
      }

      return potentials;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> swipeUser(String swipedId, bool isLiked) async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');

      await supabaseClient.from('swipes').insert({
        'swiper_id': session.user.id,
        'swiped_id': swipedId,
        'is_liked': isLiked,
      });
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
