import 'package:kovalen/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MatchingPreferencesRemoteDataSource {
  Future<double> getDistancePreference();
  Future<void> saveDistancePreference(double maxDistance);
}

class MatchingPreferencesRemoteDataSourceImpl
    implements MatchingPreferencesRemoteDataSource {
  final SupabaseClient supabaseClient;

  MatchingPreferencesRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<double> getDistancePreference() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) {
        throw ServerException('User not logged in');
      }

      final response = await supabaseClient
          .from('users')
          .select('max_distance_preference')
          .eq('id', session.user.id)
          .single();

      final distance = response['max_distance_preference'];
      return (distance as num).toDouble();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> saveDistancePreference(double maxDistance) async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) {
        throw ServerException('User not logged in');
      }

      await supabaseClient
          .from('users')
          .update({'max_distance_preference': maxDistance})
          .eq('id', session.user.id);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
