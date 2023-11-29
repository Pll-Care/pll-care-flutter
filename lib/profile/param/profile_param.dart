/*
{
  "bio": "string",
  "nickname": "string",
  "imageUrl": "string"
}
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/management/model/team_member_model.dart';

part 'profile_param.g.dart';

@JsonSerializable()
class UpdateIntroParam {
  final String bio;
  final String nickname;
  final String imageUrl;

  UpdateIntroParam({
    required this.bio,
    required this.nickname,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => _$UpdateIntroParamToJson(this);
}

@JsonSerializable()
class Contact {
  final String email;
  final String github;
  final String websiteUrl;

  Contact({
    required this.email,
    required this.github,
    required this.websiteUrl,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class ProjectExperience {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final List<String> techStack;

  ProjectExperience({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.techStack,
  });

  Map<String, dynamic> toJson() => _$ProjectExperienceToJson(this);

  factory ProjectExperience.fromJson(Map<String, dynamic> json) =>
      _$ProjectExperienceFromJson(json);
}

/*
{
  "contact": {
    "email": "string",
    "github": "string",
    "websiteUrl": "string"
  },
  "recruitPosition": "백엔드",
  "techStack": [
    "Spring"
  ],
  "projectId": 0,
  "projectExperiences": [
    {
      "title": "string",
      "description": "string",
      "startDate": "2023-11-29",
      "endDate": "2023-11-29",
      "techStack": [
        "Spring"
      ]
    }
  ],
  "delete": true
}
 */
@JsonSerializable()
class PatchProfileParam {
  final Contact? contact;
  final PositionType? recruitPosition;
  final String? imageUrl;
  final List<String>? techStack;
  final int? projectId;
  final List<ProjectExperience>? projectExperiences;
  final bool? delete;

  PatchProfileParam({
    required this.contact,
    required this.recruitPosition,
    required this.imageUrl,
    required this.techStack,
    required this.projectId,
    required this.projectExperiences,
    required this.delete,
  });

  Map<String, dynamic> toJson() => _$PatchProfileParamToJson(this);
}
