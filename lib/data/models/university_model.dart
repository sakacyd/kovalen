import 'package:kovalen/core/common/entities/university.dart';

class UniversityModel extends University {
  UniversityModel({
    required super.id,
    required super.institutionCode,
    required super.name,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] as String,
      institutionCode: json['institution_code'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'institution_code': institutionCode, 'name': name};
  }

  UniversityModel copyWith({
    String? id,
    String? institutionCode,
    String? name,
  }) {
    return UniversityModel(
      id: id ?? this.id,
      institutionCode: institutionCode ?? this.institutionCode,
      name: name ?? this.name,
    );
  }
}
