import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/management/component/management_body.dart';

import '../../common/model/default_model.dart';

part 'team_member_model.g.dart';

enum PositionType {
  @JsonValue('프론트엔드')
  FRONTEND,
  @JsonValue('백엔드')
  BACKEND,
  @JsonValue('미정')
  NONE,
  @JsonValue('디자인')
  DESIGN,
  @JsonValue('기획')
  PLANNER,
  ;
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
