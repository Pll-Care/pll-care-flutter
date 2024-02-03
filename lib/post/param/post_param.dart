/*
{
  "title": "string",
  "description": "string",
  "recruitStartDate": "2023-11-28",
  "recruitEndDate": "2023-11-28",
  "reference": "string",
  "contact": "string",
  "region": "string",
  "techStack": [
    "Spring"
  ],
  "recruitInfo": [
    {
      "position": "미정",
      "currentCnt": 0,
      "totalCnt": 1
    }
  ]
}
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/management/model/team_member_model.dart';

import '../../util/model/techstack_model.dart';
import '../model/post_model.dart';

part 'post_param.g.dart';

@JsonSerializable()
class UpdatePostParam {
  final String title;
  final String description;
  final String recruitStartDate;
  final String recruitEndDate;
  final String reference;
  final String contact;
  final Region region;
  final List<String> techStack;
  final List<RecruitModel> recruitInfo;
  @JsonKey(includeToJson: false)
  final List<TechStackModel> forWidgetTech;

  UpdatePostParam({
    required this.title,
    required this.description,
    required this.recruitStartDate,
    required this.recruitEndDate,
    required this.reference,
    required this.contact,
    required this.region,
    required this.techStack,
    required this.recruitInfo,
    required this.forWidgetTech,
  });

  UpdatePostParam copyWith({
    String? title,
    String? description,
    String? recruitStartDate,
    String? recruitEndDate,
    String? reference,
    String? contact,
    Region? region,
    List<String>? techStack,
    List<RecruitModel>? recruitInfo,
    List<TechStackModel>? forWidgetTech,
  }) {
    return UpdatePostParam(
      title: title ?? this.title,
      description: description ?? this.description,
      recruitStartDate: recruitStartDate ?? this.recruitStartDate,
      recruitEndDate: recruitEndDate ?? this.recruitEndDate,
      reference: reference ?? this.reference,
      contact: contact ?? this.contact,
      region: region ?? this.region,
      techStack: techStack ?? this.techStack,
      recruitInfo: recruitInfo ?? this.recruitInfo,
      forWidgetTech: forWidgetTech ?? this.forWidgetTech,
    );
  }

  Map<String, dynamic> toJson() => _$UpdatePostParamToJson(this);
}

@JsonSerializable()
class CreatePostParam extends UpdatePostParam {
  final int projectId;

  CreatePostParam({
    required this.projectId,
    required super.title,
    required super.description,
    required super.recruitStartDate,
    required super.recruitEndDate,
    required super.reference,
    required super.contact,
    required super.region,
    required super.techStack,
    required super.recruitInfo,
    required super.forWidgetTech,
  });

  factory CreatePostParam.fromUpdateParam(
      {required int projectId, required UpdatePostParam param}) {
    return CreatePostParam(
      projectId: projectId,
      title: param.title,
      description: param.description,
      recruitStartDate: param.recruitStartDate,
      recruitEndDate: param.recruitEndDate,
      reference: param.reference,
      contact: param.contact,
      region: param.region,
      techStack: param.techStack,
      recruitInfo: param.recruitInfo,
      forWidgetTech: param.forWidgetTech,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$CreatePostParamToJson(this);
}

@JsonSerializable()
class ApplyPostParam {
  final PositionType position;

  ApplyPostParam({
    required this.position,
  });

  Map<String, dynamic> toJson() => _$ApplyPostParamToJson(this);
}
