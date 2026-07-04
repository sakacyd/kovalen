import 'package:kovalen/core/common/entities/study_program.dart';

class StudyProgramModel extends StudyProgram {
  StudyProgramModel({
    required super.id,
    required super.universityId,
    required super.programCode,
    required super.name,
    required super.educationLevel,
  });

  factory StudyProgramModel.fromJson(Map<String, dynamic> json) {
    return StudyProgramModel(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      programCode: json['program_code'] as String,
      name: json['name'] as String,
      educationLevel: json['education_level'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'program_code': programCode,
      'name': name,
      'education_level': educationLevel,
    };
  }

  StudyProgramModel copyWith({
    String? id,
    String? universityId,
    String? programCode,
    String? name,
    String? educationLevel,
  }) {
    return StudyProgramModel(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      programCode: programCode ?? this.programCode,
      name: name ?? this.name,
      educationLevel: educationLevel ?? this.educationLevel,
    );
  }
}
