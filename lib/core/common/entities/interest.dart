import 'package:kovalen/core/common/entities/interest_category.dart';

class Interest {
  final String id;
  final String categoryId;
  final String name;
  final InterestCategory? category;

  Interest({
    required this.id,
    required this.categoryId,
    required this.name,
    this.category,
  });
}
