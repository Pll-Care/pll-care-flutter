/*
{
  "score": {
    "sincerity": 0,
    "jobPerformance": 0,
    "punctuality": 0,
    "communication": 0
  }
}
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';

part 'profile_eval_chart_model.g.dart';

@JsonSerializable()
class ProfileEvalChartModel {
  final ScoreModel score;

  ProfileEvalChartModel({
    required this.score,
  });

  factory ProfileEvalChartModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileEvalChartModelFromJson(json);
}
