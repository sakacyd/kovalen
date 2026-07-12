import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';

abstract interface class RatingRemoteDataSource {
  Future<void> rateUser({
    required String rateeId,
    required int rating,
    String? review,
  });
  Future<List<UserModel>> getRoomParticipants(String roomId);
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final SupabaseClient supabaseClient;

  RatingRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> rateUser({
    required String rateeId,
    required int rating,
    String? review,
  }) async {
    try {
      final currentUserId = supabaseClient.auth.currentUser!.id;
      await supabaseClient.from('user_ratings').insert({
        'rater_id': currentUserId,
        'ratee_id': rateeId,
        'rating': rating,
        'review': review,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getRoomParticipants(String roomId) async {
    try {
      final currentUserId = supabaseClient.auth.currentUser!.id;
      final response = await supabaseClient
          .from('chat_participants')
          .select('user_id, users(*)')
          .eq('room_id', roomId);
      
      final List<UserModel> participants = [];
      for (var row in response) {
        if (row['users'] != null) {
          final user = UserModel.fromJson(row['users']);
          if (user.id != currentUserId) {
            participants.add(user);
          }
        }
      }
      return participants;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
