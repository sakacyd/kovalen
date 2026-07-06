import 'dart:async';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/chat_room_model.dart';
import 'package:kovalen/data/models/message_model.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MessagesRemoteDataSource {
  Future<List<ChatRoomModel>> getChatRooms();
  Stream<List<ChatRoomModel>> watchChatRooms();
  Future<List<MessageModel>> getMessages(String roomId);
  Future<MessageModel> sendMessage(String roomId, String content);
}

class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final SupabaseClient supabaseClient;

  MessagesRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');
      final currentUserId = session.user.id;

      // 1. Get rooms the user is part of
      final participantRooms = await supabaseClient
          .from('chat_participants')
          .select('room_id')
          .eq('user_id', currentUserId);

      final List<String> roomIds = (participantRooms as List).map((e) => e['room_id'] as String).toList();
      if (roomIds.isEmpty) return [];

      // 2. Fetch rooms
      final roomsResponse = await supabaseClient
          .from('chat_rooms')
          .select('*, chat_participants(user_id, users(*)), messages(*)')
          .inFilter('id', roomIds)
          .order('created_at', ascending: false);

      List<ChatRoomModel> rooms = [];
      for (var roomData in roomsResponse) {
        // Find other user in 'personal' chat
        UserModel? otherUser;
        if (roomData['type'] == 'personal' && roomData['chat_participants'] != null) {
          final participants = roomData['chat_participants'] as List;
          for (var p in participants) {
            if (p['user_id'] != currentUserId && p['users'] != null) {
              otherUser = UserModel.fromJson(p['users']);
              break;
            }
          }
        }

        // Find last message
        String? lastMessage;
        DateTime? lastMessageTime;
        if (roomData['messages'] != null) {
          final messages = roomData['messages'] as List;
          if (messages.isNotEmpty) {
            // Sort by created_at desc to get the latest
            messages.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
            lastMessage = messages.first['content'];
            lastMessageTime = DateTime.parse(messages.first['created_at']);
          }
        }

        rooms.add(ChatRoomModel.fromJson(
          roomData,
          lastMessage: lastMessage,
          lastMessageTime: lastMessageTime,
          otherUser: otherUser,
        ));
      }

      // Sort rooms by last message time
      rooms.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      return rooms;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String roomId) async {
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

  @override
  Stream<List<ChatRoomModel>> watchChatRooms() async* {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');
      
      // Emit the initial state
      yield await getChatRooms();

      // Listen for changes
      final streamController = StreamController<List<ChatRoomModel>>();
      final channel = supabaseClient.channel('public:chat_rooms_changes');

      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'chat_participants',
        callback: (payload) async {
          streamController.add(await getChatRooms());
        }
      ).onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'chat_rooms',
        callback: (payload) async {
          streamController.add(await getChatRooms());
        }
      ).onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'messages',
        callback: (payload) async {
          streamController.add(await getChatRooms());
        }
      ).subscribe();

      yield* streamController.stream;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
