import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/group_activity_model.dart';

abstract interface class GroupActivityRemoteDataSource {
  Future<GroupActivityModel> createActivity({
    required String scheduleId,
    required String roomId,
    required String activitySummary,
    String? materialCovered,
    String? nextGoals,
  });
}

class GroupActivityRemoteDataSourceImpl
    implements GroupActivityRemoteDataSource {
  final SupabaseClient supabaseClient;

  GroupActivityRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<GroupActivityModel> createActivity({
    required String scheduleId,
    required String roomId,
    required String activitySummary,
    String? materialCovered,
    String? nextGoals,
  }) async {
    try {
      final response = await supabaseClient
          .from('group_activities')
          .insert({
            'schedule_id': scheduleId,
            'room_id': roomId,
            'activity_summary': activitySummary,
            if (materialCovered != null && materialCovered.isNotEmpty)
              'material_covered': materialCovered,
            if (nextGoals != null && nextGoals.isNotEmpty)
              'next_goals': nextGoals,
          })
          .select()
          .single();

      return GroupActivityModel.fromJson(response);
    } catch (e) {
      if (e.toString().contains('row-level security policy') ||
          e.toString().contains('RLS')) {
        throw ServerException(
          'Hanya user yang membuat jadwal yang dapat menyelesaikan jadwal',
        );
      }
      throw ServerException(e.toString());
    }
  }
}
