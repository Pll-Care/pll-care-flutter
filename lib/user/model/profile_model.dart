import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/management/model/team_member_model.dart';

import '../../post/model/post_model.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileValidateModel extends BaseModel {
  final bool myProfile;

  ProfileValidateModel({required this.myProfile});

  factory ProfileValidateModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileValidateModelFromJson(json);
}

@JsonSerializable()
class RoleTechStackModel extends BaseModel {
  final PositionType recruitPosition;
  final List<TechStack> techStack;
  final bool myProfile;

  RoleTechStackModel({
    required this.recruitPosition,
    required this.techStack,
    required this.myProfile,
  });

  factory RoleTechStackModel.fromJson(Map<String, dynamic> json) =>
      _$RoleTechStackModelFromJson(json);
}

/*
{
  "contact": {
    "email": "string",
    "github": "string",
    "websiteUrl": "string"
  },
  "myProfile": true
}
 */
@JsonSerializable()
class ContactModel extends BaseModel {
  final ContactModel contact;
  final bool myProfile;

  ContactModel({
    required this.contact,
    required this.myProfile,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);
}

/*
{
  "name": "string",
  "nickName": "string",
  "imageUrl": "string",
  "bio": "string",
  "myProfile": true
}
 */
@JsonSerializable()
class ProfileIntroModel extends BaseModel {
  final String name;
  final String nickName;
  final String imageUrl;
  final String bio;
  final bool myProfile;

  ProfileIntroModel({
    required this.name,
    required this.nickName,
    required this.imageUrl,
    required this.bio,
    required this.myProfile,
  });

  factory ProfileIntroModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileIntroModelFromJson(json);
}
