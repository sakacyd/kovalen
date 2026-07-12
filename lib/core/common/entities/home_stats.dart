class HomeStats {
  final int activeGroups;
  final int matchesToday;
  final int totalMatches;
  final String? randomInterest;

  const HomeStats({
    required this.activeGroups,
    required this.matchesToday,
    required this.totalMatches,
    this.randomInterest,
  });
}
