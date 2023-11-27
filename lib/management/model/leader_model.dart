import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
part 'leader_model.g.dart';

@JsonSerializable()
class LeaderModel extends BaseModel {
  final bool leader;

  LeaderModel({required this.leader});

  factory LeaderModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderModelFromJson(json);
}
