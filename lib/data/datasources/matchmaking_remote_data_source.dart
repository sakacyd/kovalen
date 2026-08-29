import 'dart:async';
import 'dart:math';
import 'package:kovalen/core/error/exceptions.dart';
import 'package:kovalen/data/models/match_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MatchmakingRemoteDataSource {
  Future<List<MatchProfileModel>> getPotentialMatches();
  Future<bool> swipeUser(String swipedId, bool isLiked);
  Stream<bool> watchNewMatches();
}

class MatchmakingRemoteDataSourceImpl implements MatchmakingRemoteDataSource {
  final SupabaseClient supabaseClient;

  MatchmakingRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<MatchProfileModel>> getPotentialMatches() async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');

      final currentUserId = session.user.id;

      // Ambil data current user
      final currentUserData = await supabaseClient
          .from('users')
          .select('*, user_interests(interest_id)')
          .eq('id', currentUserId)
          .single();

      final double myLat = currentUserData['latitude'] ?? 0.0;
      final double myLon = currentUserData['longitude'] ?? 0.0;
      final double myMaxDistance =
          (currentUserData['max_distance_preference'] ?? 15.0).toDouble();

      final String myProdi = currentUserData['study_program_id'] ?? '';
      final int mySemester = currentUserData['semester'] ?? 0;
      final String myTujuan = currentUserData['tujuan_belajar'] ?? '';
      final String myGaya = currentUserData['gaya_belajar'] ?? '';

      final List<dynamic> myInterestsData =
          currentUserData['user_interests'] ?? [];
      final Set<String> myInterests = myInterestsData
          .map((e) => e['interest_id'].toString())
          .toSet();
      // Because Supabase RPC is best for complex exclusions, we might need to filter locally if no RPC exists,
      // but assuming we can fetch all and filter, or use a basic query.

      // Fetch swiped IDs first to exclude them
      final swipedResponse = await supabaseClient
          .from('swipes')
          .select('swiped_id')
          .eq('swiper_id', currentUserId);

      final List<String> swipedIds = (swipedResponse as List)
          .map((e) => e['swiped_id'] as String)
          .toList();
      swipedIds.add(currentUserId); // exclude self

      // Fetch potential matches, explicitly filtering out swiped users on the database side
      var query = supabaseClient
          .from('users')
          .select(
            '*, universities(name), study_programs(name, education_level), user_interests(interests(*, interest_categories(*)))',
          )
          .eq('role', 'pelanggan');

      if (swipedIds.isNotEmpty) {
        query = query.not('id', 'in', swipedIds);
      }

      final response = await query;

      List<MatchProfileModel> potentials = [];

      for (var row in response) {
        // Parse university and study program names similar to Profile
        final universityName = row['universities']?['name'];
        final studyProgramData = row['study_programs'];
        String studyProgramDisplay = row['study_program_id'] ?? '';

        if (studyProgramData != null) {
          final level = studyProgramData['education_level'] ?? '';
          final name = studyProgramData['name'] ?? '';
          if (level.isNotEmpty && name.isNotEmpty) {
            studyProgramDisplay = '$level - $name';
          } else {
            studyProgramDisplay = name.isNotEmpty ? name : level;
          }
        }

        row['university_name'] = universityName;
        row['study_program_name'] = studyProgramDisplay;

        // --- Haversine Distance Calculation ---
        final double otherLat = row['latitude'] ?? 0.0;
        final double otherLon = row['longitude'] ?? 0.0;
        final double distance = _calculateHaversine(
          myLat,
          myLon,
          otherLat,
          otherLon,
        );

        // Filter out by max distance
        if (distance > myMaxDistance) {
          continue; // Skip this user
        }

        // --- Gower's Coefficient Calculation ---
        final String otherProdi = row['study_program_id'] ?? '';
        final int otherSemester = row['semester'] ?? 0;
        final String otherTujuan = row['tujuan_belajar'] ?? '';
        final String otherGaya = row['gaya_belajar'] ?? '';

        final List<dynamic> otherInterestsData = row['user_interests'] ?? [];
        final Set<String> otherInterests = otherInterestsData
            .map((e) => e['interest_id'].toString())
            .toSet();

        // Bobot berdasarkan hasil kuesioner
        const double wProdi = 80.0;
        const double wSemester = 73.3;
        const double wTujuan = 86.1;
        const double wGaya = 77.0;
        const double wMinat =
            73.35; // Rata-rata minat akademik (75.8) dan non-akademik (70.9)
        const double wJarak = 73.9;

        final double sumWeights =
            wProdi + wSemester + wTujuan + wGaya + wMinat + wJarak;

        // Hitung skor masing-masing atribut (rentang 0.0 - 1.0)
        final double sProdi = (myProdi == otherProdi) ? 1.0 : 0.0;

        // Semester difference (max diff assumed ~ 8)
        final double diffSemester = (mySemester - otherSemester)
            .abs()
            .toDouble();
        final double sSemester = max(0.0, 1.0 - (diffSemester / 8.0));

        final double sTujuan = (myTujuan.isNotEmpty && myTujuan == otherTujuan)
            ? 1.0
            : 0.0;
        final double sGaya = (myGaya.isNotEmpty && myGaya == otherGaya)
            ? 1.0
            : 0.0;

        // Jaccard similarity for interests
        final int intersection = myInterests
            .intersection(otherInterests)
            .length;
        final int union = myInterests.union(otherInterests).length;
        final double sMinat = union == 0 ? 0.0 : intersection / union;

        // Distance similarity (1.0 = same location, 0.0 = at max distance)
        final double sJarak = max(
          0.0,
          1.0 - (distance / max(1.0, myMaxDistance)),
        );

        final double gowersScore =
            ((sProdi * wProdi) +
                (sSemester * wSemester) +
                (sTujuan * wTujuan) +
                (sGaya * wGaya) +
                (sMinat * wMinat) +
                (sJarak * wJarak)) /
            sumWeights;

        // Convert percentage 0-100
        final int finalMatchPercentage = (gowersScore * 100).round().clamp(
          0,
          100,
        );

        // Update the model variables
        var profileModel = MatchProfileModel.fromJson(row).copyWith(
          distanceInKm: distance,
          matchPercentage: finalMatchPercentage,
          commonInterestsCount: intersection,
        );

        potentials.add(profileModel);
      }

      // Urutkan berdasarkan Gower's Coefficient (matchPercentage) secara descending
      potentials.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));

      return potentials;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> swipeUser(String swipedId, bool isLiked) async {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');

      await supabaseClient.from('swipes').insert({
        'swiper_id': session.user.id,
        'swiped_id': swipedId,
        'is_liked': isLiked,
      });

      if (isLiked) {
        final res = await supabaseClient
            .from('swipes')
            .select('id')
            .eq('swiper_id', swipedId)
            .eq('swiped_id', session.user.id)
            .eq('is_liked', true)
            .maybeSingle();
        return res != null;
      }

      return false;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MatchProfileModel>> watchNewMatches() async* {
    try {
      final session = supabaseClient.auth.currentSession;
      if (session == null) throw ServerException('User not logged in');
      final currentUserId = session.user.id;

      // Initial yield
      yield await getPotentialMatches();

      final streamController = StreamController<List<MatchProfileModel>>();
      final channel = supabaseClient.channel('public:matches_changes');

      streamController.onCancel = () {
        supabaseClient.removeChannel(channel);
      };

      channel
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'swipes',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'target_user_id',
              value: currentUserId,
            ),
            callback: (payload) async {
              streamController.add(await getPotentialMatches());
            },
          )
          .subscribe();

      yield* streamController.stream;
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // --- Utility Functions ---
  double _calculateHaversine(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371.0; // Radius Bumi dalam km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;

    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (pi / 180.0);
  }
}
