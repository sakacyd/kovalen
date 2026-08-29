import 'package:kovalen/core/common/entities/interest_category.dart';

class InterestCategoryModel extends InterestCategory {
  InterestCategoryModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory InterestCategoryModel.fromJson(Map<String, dynamic> json) {
    return InterestCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'type': type};
  }
}
