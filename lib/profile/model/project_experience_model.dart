import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/post/model/post_model.dart';

part 'project_experience_model.g.dart';
@JsonSerializable()
class ProjectExperienceList extends BaseModel {
  final List<YearProjectExperienceModel> data;
  final bool myProfile;

  ProjectExperienceList({
    required this.data,
    required this.myProfile,
  });

  factory ProjectExperienceList.fromJson(Map<String, dynamic> json) =>
      _$ProjectExperienceListFromJson(json);
}


@JsonSerializable()
class ProjectExperience {
  final int projectId;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final List<TechStack> techStack;

  ProjectExperience({
    required this.projectId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.techStack,
  });

  factory ProjectExperience.fromJson(Map<String, dynamic> json) =>
      _$ProjectExperienceFromJson(json);
}


@JsonSerializable()
class YearProjectExperienceModel extends BaseModel {
  final int  year;
  final List<ProjectExperience> projectExperiences;

  YearProjectExperienceModel({
    required this.year,
    required this.projectExperiences,
  });

  factory YearProjectExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$YearProjectExperienceModelFromJson(json);
}