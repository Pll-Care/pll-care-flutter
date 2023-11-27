import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';

import 'chart_rank_model.dart';
part 'finalterm_model.g.dart';

@JsonSerializable()
class FinalTermModel extends BaseModel{
  final String name;
  final String content;
  final ScoreModel score;

  FinalTermModel({
    required this.name,
    required this.content,
    required this.score,
  });

  factory FinalTermModel.fromJson(Map<String, dynamic> json) =>
      _$FinalTermModelFromJson(json);
}


@JsonSerializable()
class FinalTermRankModel extends RankModel{
  final int memberId;

  FinalTermRankModel({
    required super.rank,
    required this.memberId,
    required super.name,
    required super.quantity,
  });

  @override
  @JsonKey(name: 'score')
  get quantity => super.quantity;


  factory FinalTermRankModel.fromJson(Map<String, dynamic> json) =>
      _$FinalTermRankModelFromJson(json);
}


