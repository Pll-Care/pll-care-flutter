/*
[
  {
    "applyId": 0,
    "memberId": 0,
    "name": "string",
    "imageUrl": "string",
    "position": "미정"
  }
]
 */


import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/management/model/team_member_model.dart';

import '../../common/model/default_model.dart';
part 'apply_model.g.dart';

@JsonSerializable()
class ApplyModel extends BaseModel {
  final int applyId;
  final int memberId;
  final String name;
  final String imageUrl;
  final PositionType position;

  ApplyModel( {
    required this.applyId,
    required this.memberId,
    required this.name,
    required this.imageUrl,
    required this.position,
  });

  factory ApplyModel.fromJson(Map<String, dynamic> json) =>
      _$ApplyModelFromJson(json);
}
