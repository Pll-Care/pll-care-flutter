import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'project_model.g.dart';

/*
        "postId": 107,
        "projectId": 54,
        "projectTitle": "테스트용 프로젝트1",
        "projectImageUrl": "",
        "recruitEndDate": "2023-11-18",
        "title": "제목이 길이가 제한이 있었나요?",
        "description": "테스트용 프로젝트1입니다"

 */
abstract class ProjectMainModel {
  final int postId;
  final int projectId;
  final String projectTitle;
  final String projectImageUrl;
  final String recruitEndDate;
  final String title;
  final String description;

  ProjectMainModel({
    required this.postId,
    required this.projectId,
    required this.projectTitle,
    required this.projectImageUrl,
    required this.recruitEndDate,
    required this.title,
    required this.description,
  });
}
@JsonSerializable()
class ProjectCloseDeadLine extends ProjectMainModel {
  ProjectCloseDeadLine(
      {required super.postId,
      required super.projectId,
      required super.projectTitle,
      required super.projectImageUrl,
      required super.recruitEndDate,
      required super.title,
      required super.description});

  factory ProjectCloseDeadLine.fromJson(Map<String, dynamic> json) =>
      _$ProjectCloseDeadLineFromJson(json);
}

@JsonSerializable()
class ProjectUpToDate extends ProjectMainModel {
  ProjectUpToDate(
      {required super.postId,
        required super.projectId,
        required super.projectTitle,
        required super.projectImageUrl,
        required super.recruitEndDate,
        required super.title,
        required super.description});

  factory ProjectUpToDate.fromJson(Map<String, dynamic> json) =>
      _$ProjectUpToDateFromJson(json);
}

@JsonSerializable()
class ProjectMostLiked extends ProjectMainModel {
  final int likeCount;
  ProjectMostLiked(
      {required super.postId,
        required super.projectId,
        required super.projectTitle,
        required super.projectImageUrl,
        required super.recruitEndDate,
        required super.title,
        required super.description,
        required this.likeCount,
      });

  factory ProjectMostLiked.fromJson(Map<String, dynamic> json) =>
      _$ProjectMostLikedFromJson(json);
}