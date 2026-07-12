import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/user_model.dart';
import 'package:kovalen/core/common/entities/home_stats.dart';
import 'package:kovalen/core/common/entities/home_data.dart';
import 'package:kovalen/data/models/chat_room_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'dart:math';

abstract interface class HomeRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel?> getCurrentUserData();
  Future<HomeStats> getHomeStats();
  Stream<HomeData> watchHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;

  HomeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select('*, study_programs(name, education_level)')
            .eq('id', currentUserSession!.user.id);

        final studyProgramData = userData.first['study_programs'];
        String studyProgramDisplay = 'Program Studi Belum Diisi';

        if (studyProgramData != null) {
          final level = studyProgramData['education_level'] ?? '';
          final name = studyProgramData['name'] ?? '';

          if (level.isNotEmpty && name.isNotEmpty) {
            studyProgramDisplay = '$level - $name';
          } else {
            studyProgramDisplay = name.isNotEmpty ? name : level;
          }
        }

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
          fullName: userData.first['full_name'],
          avatarUrl: userData.first['avatar_url'],
          semester: userData.first['semester'],
          gpa: (userData.first['gpa'] as num?)?.toDouble() ?? 0.0,
          universityId: userData.first['university_id'],
          studyProgramId: studyProgramDisplay,
        );
      }
      return null;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HomeStats> getHomeStats() async {
    try {
      final userId = currentUserSession?.user.id;
      if (userId == null) {
        throw ServerException('User not logged in');
      }

      // Count active groups
      final groupCountRes = await supabaseClient
          .from('chat_participants')
          .select('room_id, chat_rooms!inner(type)')
          .eq('user_id', userId)
          .eq('chat_rooms.type', 'group')
          .count(CountOption.exact);
      final activeGroups = groupCountRes.count;

      // Count total matches
      final totalMatchesRes = await supabaseClient
          .from('matches')
          .select('id')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .count(CountOption.exact);
      final totalMatches = totalMatchesRes.count;

      // Count today's matches
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).toUtc().toIso8601String();
      final todayMatchesRes = await supabaseClient
          .from('matches')
          .select('id')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .gte('created_at', startOfDay)
          .count(CountOption.exact);
      final matchesToday = todayMatchesRes.count;

      final userInterests = await supabaseClient
          .from('user_interests')
          .select('interests!inner(name, interest_categories!inner(type))')
          .eq('user_id', userId)
          .eq('interests.interest_categories.type', 'academic');

      String? randomInterestName;
      if (userInterests.isNotEmpty) {
        final random = Random();
        final randomRow = userInterests[random.nextInt(userInterests.length)];
        randomInterestName = randomRow['interests']['name'];
      }

      return HomeStats(
        activeGroups: activeGroups,
        matchesToday: matchesToday,
        totalMatches: totalMatches,
        randomInterest: randomInterestName,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<HomeData> watchHomeData() {
    final userId = currentUserSession?.user.id;
    if (userId == null) {
      throw ServerException('User not logged in');
    }

    final controller = StreamController<HomeData>();

    Future<void> emitData() async {
      try {
        final stats = await getHomeStats();
        
        final groupRooms = await supabaseClient
            .from('chat_participants')
            .select('chat_rooms!inner(*)')
            .eq('user_id', userId)
            .eq('chat_rooms.type', 'group');
        
        final List<ChatRoomModel> activeGroups = groupRooms.map((row) {
          final roomData = row['chat_rooms'];
          return ChatRoomModel.fromJson(roomData);
        }).toList();

        final homeData = HomeData(
          stats: stats,
          activeGroups: activeGroups,
          randomInterest: stats.randomInterest,
        );
        if (!controller.isClosed) controller.add(homeData);
      } catch (e) {
        if (!controller.isClosed) controller.addError(ServerException(e.toString()));
      }
    }

    // Initial fetch
    emitData();

    // Listen to changes
    final chatSub = supabaseClient.channel('public:chat_participants').onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'chat_participants',
      callback: (payload) {
        emitData();
      },
    ).subscribe();

    final matchesSub = supabaseClient.channel('public:matches').onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'matches',
      callback: (payload) {
        emitData();
      },
    ).subscribe();

    controller.onCancel = () {
      supabaseClient.removeChannel(chatSub);
      supabaseClient.removeChannel(matchesSub);
      controller.close();
    };

    return controller.stream;
  }
}
