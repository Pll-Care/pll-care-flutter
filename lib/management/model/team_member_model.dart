import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/management/component/management_body.dart';

import '../../common/model/default_model.dart';

part 'team_member_model.g.dart';

enum PositionType {
  @JsonValue('프론트엔드')
  FRONTEND('프론트엔드'),
  @JsonValue('백엔드')
  BACKEND('백엔드'),
  @JsonValue('미정')
  NONE('미정'),
  @JsonValue('디자인')
  DESIGN('디자인'),
  @JsonValue('기획')
  PLANNER('기획')
  ;
   const PositionType(this.name);
  final String name;
}

@JsonSerializable()
class TeamMemberModel extends BaseModel {
  final int memberId;
  final String name;
  final String imageUrl;
  final PositionType position;
  final bool leader;

  TeamMemberModel({
    required this.memberId,
    required this.name,
    required this.imageUrl,
    required this.position,
    required this.leader,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberModelFromJson(json);
}
