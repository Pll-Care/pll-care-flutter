
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

import 'chart_rank_model.dart';

part 'midterm_model.g.dart';

enum BadgeType {
  @JsonValue('열정적인_참여자')
  PASSIONATE,
}

@JsonSerializable()
class BadgeModel {
  final BadgeType evaluationBadge;
  final int quantity;

  BadgeModel({required this.evaluationBadge, required this.quantity});
  factory BadgeModel.fromJson(Map<String, dynamic> json) => _$BadgeModelFromJson(json);
}

@JsonSerializable()
class MidTermModel extends BaseModel{
  final String title;
  final String startDate;
  final String endDate;
  final StateType state;
  final String members;
  final List<BadgeModel> badgeDtos;

  MidTermModel({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.state,
    required this.members,
    required this.badgeDtos,
  });

  factory MidTermModel.fromJson(Map<String, dynamic> json) =>
      _$MidTermModelFromJson(json);
}



@JsonSerializable()
class MidTermRankModel extends RankModel{
  MidTermRankModel({
    required super.rank,
    required super.name,
    required super.quantity,
  });

  factory MidTermRankModel.fromJson(Map<String, dynamic> json) =>
      _$MidTermRankModelFromJson(json);
}

