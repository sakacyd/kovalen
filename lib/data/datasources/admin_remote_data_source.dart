import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/data/models/chat_room_model.dart';
import 'package:kovalen/data/models/group_schedule_model.dart';
import 'package:kovalen/data/models/group_activity_model.dart';

abstract interface class AdminRemoteDataSource {
  Future<List<UserModel>> getAllUsers();
  Future<List<ChatRoomModel>> getAllGroups();
  Future<void> changeUserRole(String userId, String newRole);
  Future<void> changeUserStatus(
    String userId,
    String status,
    DateTime? suspendedUntil,
  );
  Future<void> deleteUser(String userId);
  Future<Map<String, dynamic>> getGroupDetails(String roomId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final SupabaseClient supabaseClient;

  AdminRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await supabaseClient.from('users').select();
      return response.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ChatRoomModel>> getAllGroups() async {
    try {
      final response = await supabaseClient
          .from('chat_rooms')
          .select()
          .eq('type', 'group');
      return response.map((json) => ChatRoomModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changeUserRole(String userId, String newRole) async {
    try {
      await supabaseClient
          .from('users')
          .update({'role': newRole})
          .eq('id', userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changeUserStatus(
    String userId,
    String status,
    DateTime? suspendedUntil,
  ) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'suspended_until': suspendedUntil?.toIso8601String(),
      };
      await supabaseClient.from('users').update(updateData).eq('id', userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await supabaseClient.from('users').delete().eq('id', userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getGroupDetails(String roomId) async {
    try {
      final schedulesRes = await supabaseClient
          .from('group_schedules')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: false);

      final activitiesRes = await supabaseClient
          .from('group_activities')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: false);

      final schedules = schedulesRes
          .map((json) => GroupScheduleModel.fromJson(json))
          .toList();
      final activities = activitiesRes
          .map((json) => GroupActivityModel.fromJson(json))
          .toList();

      return {'schedules': schedules, 'activities': activities};
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
