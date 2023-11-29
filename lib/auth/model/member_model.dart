/*
{
  "memberId": 0,
  "imageUrl": "string"
}
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
part 'member_model.g.dart';

@JsonSerializable()
class MemberModel extends BaseModel{
  final int memberId;
  final String imageUrl;

  MemberModel({
    required this.memberId,
    required this.imageUrl,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}
