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
  });

  Map<String, dynamic> toJson() => _$UpdatePostParamToJson(this);
}

/*
{
  "projectId": 0,
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
  });

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
