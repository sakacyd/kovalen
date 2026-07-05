import 'package:kovalen/core/common/entities/interest.dart';
import 'package:kovalen/data/models/interest_category_model.dart';

class InterestModel extends Interest {
  InterestModel({
    required super.id,
    required super.categoryId,
    required super.name,
    super.category,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      category: json['interest_categories'] != null
          ? InterestCategoryModel.fromJson(json['interest_categories'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
    };
  }
}
