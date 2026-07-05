import 'package:kovalen/core/common/entities/swipe.dart';

class SwipeModel extends Swipe {
  SwipeModel({
    required super.id,
    required super.swiperId,
    required super.swipedId,
    required super.isLiked,
    required super.createdAt,
  });

  factory SwipeModel.fromJson(Map<String, dynamic> json) {
    return SwipeModel(
      id: json['id'] as String,
      swiperId: json['swiper_id'] as String,
      swipedId: json['swiped_id'] as String,
      isLiked: json['is_liked'] as bool,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
