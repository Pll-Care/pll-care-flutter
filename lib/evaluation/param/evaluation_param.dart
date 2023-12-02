import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/evaluation/model/midterm_model.dart';

part 'evaluation_param.g.dart';

@JsonSerializable()
class CreateMidTermParam {
  final int projectId;
  final int votedId;
  final int scheduleId;
  final BadgeType evaluationBadge;

  CreateMidTermParam({
    required this.projectId,
    required this.votedId,
    required this.scheduleId,
    required this.evaluationBadge,
  });

  Map<String, dynamic> toJson() => _$CreateMidTermParamToJson(this);
}

@JsonSerializable()
class CreateFinalTermParam {
  final int projectId;
  final int evaluatedId;
  final ScoreModel score;
  final String content;

  CreateFinalTermParam({
    required this.projectId,
    required this.evaluatedId,
    required this.score,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$CreateFinalTermParamToJson(this);
}

@JsonSerializable()
class ScoreModel {
  final num sincerity;
  final num jobPerformance;
  final num punctuality;
  final num communication;

  ScoreModel({
    required this.sincerity,
    required this.jobPerformance,
    required this.punctuality,
    required this.communication,
  });

  ScoreModel copyWith({
    num? sincerity,
    num? jobPerformance,
    num? punctuality,
    num? communication,
  }) {
    return ScoreModel(
      sincerity: sincerity ?? this.sincerity,
      jobPerformance: jobPerformance ?? this.jobPerformance,
      punctuality: punctuality ?? this.punctuality,
      communication: communication ?? this.communication,
    );
  }

  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreModelToJson(this);
}
