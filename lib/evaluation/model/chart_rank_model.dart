import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'chart_rank_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class MidChartRankModel<T, U> extends BaseModel {
  final List<MidChartModel<T>> charts;
  final List<U> ranks;
  final bool evaluation;

  MidChartRankModel({
    required this.charts,
    required this.ranks,
    required this.evaluation,
  });

  factory MidChartRankModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    U Function(Object? json) fromJsonU,
  ) =>
      _$MidChartRankModelFromJson(json, fromJsonT, fromJsonU);
}

@JsonSerializable(
  genericArgumentFactories: true,
)
class FinalChartRankModel<T, U> extends BaseModel {
  final List<FinalChartModel<T>> charts;
  final List<U> ranks;
  final bool evaluation;

  FinalChartRankModel({
    required this.charts,
    required this.ranks,
    required this.evaluation,
  });

  factory FinalChartRankModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      U Function(Object? json) fromJsonU,
      ) =>
      _$FinalChartRankModelFromJson(json, fromJsonT, fromJsonU);
}

@JsonSerializable(genericArgumentFactories: true)
class MidChartModel<T> {
  final int memberId;
  final String name;
  final T evaluation;

  MidChartModel({
    required this.memberId,
    required this.name,
    required this.evaluation,
  });

  factory MidChartModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$MidChartModelFromJson(json, fromJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class FinalChartModel<T> {
  final int memberId;
  final String name;
  final List<T> evaluation;

  FinalChartModel({
    required this.memberId,
    required this.name,
    required this.evaluation,
  });

  factory FinalChartModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$FinalChartModelFromJson(json, fromJsonT);
}

@JsonSerializable()
class RankModel {
  final int rank;
  final String name;
  final num quantity;

  RankModel({
    required this.rank,
    required this.name,
    required this.quantity,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) =>
      _$RankModelFromJson(json);
}
