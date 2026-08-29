import 'dart:io';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/chat_room_model.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RoomDetailRemoteDataSource {
  Future<UserModel> getUserById(String userId);
  Future<ChatRoomModel> getGroupDetail(String roomId);
  Future<List<UserModel>> getGroupParticipants(String roomId);
  Future<ChatRoomModel> updateGroupProfile(
    String roomId,
    String name,
    File? avatarFile,
  );
  Future<void> addUserToGroup(String roomId, String userId);
}

class RoomDetailRemoteDataSourceImpl implements RoomDetailRemoteDataSource {
  final SupabaseClient supabaseClient;

  RoomDetailRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select('''
            *,
            university:universities(*),
            study_program:study_programs(*),
            user_interests(
              interests(*, interest_categories(*))
            )
          ''')
          .eq('id', userId)
          .single();
      return UserModel.fromJson(response);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChatRoomModel> getGroupDetail(String roomId) async {
    try {
      final response = await supabaseClient
          .from('chat_rooms')
          .select()
          .eq('id', roomId)
          .single();
      return ChatRoomModel.fromJson(response);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getGroupParticipants(String roomId) async {
    try {
      final response = await supabaseClient
          .from('chat_participants')
          .select(
            'users(*, university:universities(*), study_program:study_programs(*))',
          )
          .eq('room_id', roomId);

      return response
          .map<UserModel>((item) => UserModel.fromJson(item['users']))
          .toList();
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChatRoomModel> updateGroupProfile(
    String roomId,
    String name,
    File? avatarFile,
  ) async {
    try {
      String? avatarUrl;

      if (avatarFile != null) {
        final fileExtension = avatarFile.path.split('.').last;
        final fileName =
            'group_${roomId}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final filePath = 'groups/$fileName';

        await supabaseClient.storage
            .from('avatars')
            .upload(filePath, avatarFile);
        avatarUrl = supabaseClient.storage
            .from('avatars')
            .getPublicUrl(filePath);
      }

      final updateData = <String, dynamic>{'name': name};

      if (avatarUrl != null) {
        updateData['avatar_url'] = avatarUrl;
      }

      final response = await supabaseClient
          .from('chat_rooms')
          .update(updateData)
          .eq('id', roomId)
          .select()
          .single();

      return ChatRoomModel.fromJson(response);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addUserToGroup(String roomId, String userId) async {
    try {
      await supabaseClient.from('chat_participants').insert({
        'room_id': roomId,
        'user_id': userId,
      });
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw ServerException('User sudah berada di dalam grup.');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
