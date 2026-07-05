import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MessageRoomRemoteDataSource {
  Future<List<MessageModel>> getMessageRoomMessages(String roomId);
  Future<MessageModel> sendMessage(String roomId, String content);
}

class MessageRoomRemoteDataSourceImpl implements MessageRoomRemoteDataSource {
  final SupabaseClient supabaseClient;

  MessageRoomRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<MessageModel>> getMessageRoomMessages(String roomId) async {
    try {
      final response = await supabaseClient
          .from('messages')
          .select('*')
          .eq('room_id', roomId)
          .order('created_at', ascending: true);

      return (response as List).map((m) => MessageModel.fromJson(m)).toList();
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
          .select()
          .single();

      return MessageModel.fromJson(response);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
