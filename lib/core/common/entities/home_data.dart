import 'package:kovalen/core/common/entities/chat_room.dart';
import 'package:kovalen/core/common/entities/home_stats.dart';

class HomeData {
  final HomeStats stats;
  final List<ChatRoom> activeGroups;
  final String? randomInterest;

  const HomeData({
    required this.stats,
    required this.activeGroups,
    this.randomInterest,
  });
}
