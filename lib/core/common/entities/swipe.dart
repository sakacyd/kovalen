class Swipe {
  final String id;
  final String swiperId;
  final String swipedId;
  final bool isLiked;
  final DateTime createdAt;

  Swipe({
    required this.id,
    required this.swiperId,
    required this.swipedId,
    required this.isLiked,
    required this.createdAt,
  });
}
