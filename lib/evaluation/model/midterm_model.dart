import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

import 'chart_rank_model.dart';

part 'midterm_model.g.dart';

enum BadgeType {
  @JsonValue('열정적인_참여자')
  PASSIONATE('열정적인 참여자'),
  @JsonValue('아이디어_뱅크')
  BANK('아이디어 뱅크'),
  @JsonValue('탁월한_리더')
  LEADER('탁월한 리더'),
  @JsonValue('최고의_서포터')
  SUPPORTER('최고의 서포터');
  const BadgeType(this.name);
  final String name;
}

@JsonSerializable()
class BadgeModel {
  final BadgeType evaluationBadge;
  final int? quantity;

  BadgeModel({required this.evaluationBadge, required this.quantity});

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);
}

@JsonSerializable()
class ChartBadgeModel {
  @JsonKey(name: '열정적인_참여자')
  final int passionateCnt;
  @JsonKey(name: '아이디어_뱅크')
  final int bankCnt;
  @JsonKey(name: '탁월한_리더')
  final int leaderCnt;
  @JsonKey(name: '최고의_서포터')
  final int supporterCnt;

  ChartBadgeModel({
    required this.passionateCnt,
    required this.bankCnt,
    required this.leaderCnt,
    required this.supporterCnt,
  });

  factory ChartBadgeModel.fromJson(Map<String, dynamic> json) =>
      _$ChartBadgeModelFromJson(json);
}

@JsonSerializable()
class MidTermModel extends BaseModel {
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
class MidTermRankModel extends RankModel {
  MidTermRankModel({
    required super.rank,
    required super.name,
    required super.quantity,
  });

  factory MidTermRankModel.fromJson(Map<String, dynamic> json) =>
      _$MidTermRankModelFromJson(json);
}
