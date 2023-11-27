
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
part 'chart_rank_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class ChartRankModel<T, U> extends BaseModel {
  final List<ChartModel<T>> charts;
  final List<U> ranks;
  final bool evaluation;

  ChartRankModel({
    required this.charts,
    required this.ranks,
    required this.evaluation,
  });

  factory ChartRankModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    U Function(Object? json) fromJsonU,
  ) =>
      _$ChartRankModelFromJson(json, fromJsonT, fromJsonU);
}

@JsonSerializable(genericArgumentFactories: true)
class ChartModel<T> {
  final int memberId;
  final int name;
  final List<T> evaluation;

  ChartModel({
    required this.memberId,
    required this.name,
    required this.evaluation,
  });

  factory ChartModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ChartModelFromJson(json, fromJsonT);
}


@JsonSerializable()
class RankModel {
  final int rank;
  final String name;
  final int quantity;

  RankModel({
    required this.rank,
    required this.name,
    required this.quantity,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) =>
      _$RankModelFromJson(json);
}


