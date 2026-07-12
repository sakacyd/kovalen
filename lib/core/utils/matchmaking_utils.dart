import 'dart:math';
import 'package:kovalen/core/common/entities/user.dart';

class MatchmakingUtils {
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radius Bumi dalam km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _deg2rad(double deg) {
    return deg * (pi / 180.0);
  }

  static int calculateMatchPercentage(User currentUser, User otherUser, double distance) {
    final double myMaxDistance = currentUser.maxDistancePreference;

    // --- Gower's Coefficient Calculation ---
    final String myProdi = currentUser.studyProgramId;
    final int mySemester = currentUser.semester;
    final String myTujuan = currentUser.tujuanBelajar ?? '';
    final String myGaya = currentUser.gayaBelajar ?? '';
    final Set<String> myInterests = currentUser.interests.toSet();

    final String otherProdi = otherUser.studyProgramId;
    final int otherSemester = otherUser.semester;
    final String otherTujuan = otherUser.tujuanBelajar ?? '';
    final String otherGaya = otherUser.gayaBelajar ?? '';
    final Set<String> otherInterests = otherUser.interests.toSet();

    // Bobot berdasarkan hasil kuesioner
    const double wProdi = 80.0;
    const double wSemester = 73.3;
    const double wTujuan = 86.1;
    const double wGaya = 77.0;
    const double wMinat = 73.35; // Rata-rata minat akademik (75.8) dan non-akademik (70.9)
    const double wJarak = 73.9;

    final double sumWeights = wProdi + wSemester + wTujuan + wGaya + wMinat + wJarak;

    // Hitung skor masing-masing atribut (rentang 0.0 - 1.0)
    final double sProdi = (myProdi == otherProdi) ? 1.0 : 0.0;
    
    // Semester difference (max diff assumed ~ 8)
    final double diffSemester = (mySemester - otherSemester).abs().toDouble();
    final double sSemester = max(0.0, 1.0 - (diffSemester / 8.0));
    
    final double sTujuan = (myTujuan.isNotEmpty && myTujuan == otherTujuan) ? 1.0 : 0.0;
    final double sGaya = (myGaya.isNotEmpty && myGaya == otherGaya) ? 1.0 : 0.0;
    
    // Jaccard similarity for interests
    final int intersection = myInterests.intersection(otherInterests).length;
    final int union = myInterests.union(otherInterests).length;
    final double sMinat = union == 0 ? 0.0 : intersection / union;

    // Distance similarity (1.0 = same location, 0.0 = at max distance)
    final double sJarak = max(0.0, 1.0 - (distance / max(1.0, myMaxDistance)));

    final double gowersScore = (
      (sProdi * wProdi) +
      (sSemester * wSemester) +
      (sTujuan * wTujuan) +
      (sGaya * wGaya) +
      (sMinat * wMinat) +
      (sJarak * wJarak)
    ) / sumWeights;

    // Convert percentage 0-100
    return (gowersScore * 100).round().clamp(0, 100);
  }
}
