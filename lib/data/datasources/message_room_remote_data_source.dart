import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MessageRoomRemoteDataSource {
  Stream<List<MessageModel>> getMessageRoomMessages(String roomId);
  Future<MessageModel> sendMessage(String roomId, String content);
}

class MessageRoomRemoteDataSourceImpl implements MessageRoomRemoteDataSource {
  final SupabaseClient supabaseClient;

  MessageRoomRemoteDataSourceImpl(this.supabaseClient);

  @override
  Stream<List<MessageModel>> getMessageRoomMessages(String roomId) async* {
    try {
      // Pre-fetch participants to enrich message stream
      final participants = await supabaseClient
          .from('chat_participants')
          .select('user_id, users(full_name, avatar_url)')
          .eq('room_id', roomId);
          
      final Map<String, dynamic> userCache = {};
      for (var p in participants) {
        final user = p['users'];
        if (user != null) {
          userCache[p['user_id'] as String] = user;
        }
      }

      yield* supabaseClient
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('room_id', roomId)
          .order('created_at', ascending: true)
          .map((data) {
            return data.map((m) {
              final senderId = m['sender_id'] as String;
              final user = userCache[senderId];
              return MessageModel(
                id: m['id'] as String,
                roomId: m['room_id'] as String,
                senderId: senderId,
                content: m['content'] as String,
                createdAt: DateTime.parse(m['created_at']),
                senderName: user?['full_name'] as String?,
                senderAvatarUrl: user?['avatar_url'] as String?,
              );
            }).toList();
          });
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessage(String roomId, String content) async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');

      final response = await supabaseClient
          .from('messages')
          .insert({
            'room_id': roomId,
            'sender_id': session.user.id,
            'content': content,
          })
          .select('*, sender:users(full_name, avatar_url)')
          .single();

      return MessageModel.fromJson(response);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
