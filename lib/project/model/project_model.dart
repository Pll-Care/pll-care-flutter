import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/dio/param/param.dart';

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
  final String? projectImageUrl;
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

  ProjectMostLiked({
    required super.postId,
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

/*
      "projectId": 0,
      "title": "string",
      "description": "string",
      "startDate": "2023-11-17",
      "endDate": "2023-11-17",
      "state": "TBD",
      "imageUrl": "string"
 */
@JsonSerializable()
class ProjectListModel {
  final int projectId;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final ProjectListType state;
  final String? imageUrl;

  ProjectListModel({
    required this.projectId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.imageUrl,
  });

  factory ProjectListModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectListModelFromJson(json);
}

@JsonSerializable()
class ProjectList extends PaginationModel<ProjectListModel> {
  @JsonKey(name: 'content')
  @override
  List<ProjectListModel>? get data => super.data;

  ProjectList(
      {required super.data,
      required super.pageNumber,
      required super.totalElements,
      required super.totalPages,
      required super.last,
      required super.size,
      required super.sort,
      required super.numberOfElements,
      required super.first,
      required super.empty});

  factory ProjectList.fromJson(Map<String, dynamic> json) =>
      _$ProjectListFromJson(json);
}