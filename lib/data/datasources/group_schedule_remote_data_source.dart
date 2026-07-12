import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/group_schedule_model.dart';
import 'package:intl/intl.dart';

abstract interface class GroupScheduleRemoteDataSource {
  Future<GroupScheduleModel?> getActiveSchedule(String roomId);
  Future<GroupScheduleModel> createSchedule({
    required String roomId,
    required String title,
    required DateTime meetingTime,
    required String locationName,
    String? locationUrl,
  });
  Future<void> completeSchedule(String scheduleId);
}

class GroupScheduleRemoteDataSourceImpl implements GroupScheduleRemoteDataSource {
  final SupabaseClient supabaseClient;

  GroupScheduleRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<GroupScheduleModel?> getActiveSchedule(String roomId) async {
    try {
      final response = await supabaseClient
          .from('group_schedules')
          .select()
          .eq('room_id', roomId)
          .eq('is_completed', false)
          .maybeSingle();

      if (response == null) return null;
      return GroupScheduleModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GroupScheduleModel> createSchedule({
    required String roomId,
    required String title,
    required DateTime meetingTime,
    required String locationName,
    String? locationUrl,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      final response = await supabaseClient.from('group_schedules').insert({
        'room_id': roomId,
        'title': title,
        'meeting_time': meetingTime.toUtc().toIso8601String(),
        'location_name': locationName,
        'created_by': userId,
        if (locationUrl != null && locationUrl.isNotEmpty) 'location_url': locationUrl,
      }).select().single();

      final formattedDate = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(meetingTime.toLocal());
      final locationUrlString = (locationUrl != null && locationUrl.isNotEmpty) ? '\n🔗 Tautan: $locationUrl' : '';
      final messageContent = '📅 Saya telah membuat jadwal pertemuan baru:\n**$title**\n🕒 Waktu: $formattedDate\n📍 Lokasi: $locationName$locationUrlString';
      
      await supabaseClient.from('messages').insert({
        'room_id': roomId,
        'sender_id': userId,
        'content': messageContent,
      });

      return GroupScheduleModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> completeSchedule(String scheduleId) async {
    try {
      await supabaseClient
          .from('group_schedules')
          .update({'is_completed': true})
          .eq('id', scheduleId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
