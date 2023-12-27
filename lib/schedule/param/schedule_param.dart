// {
// "projectId": 0,
// "memberId": 0,
// "scheduleCategory": "MILESTONE",
// "previous": true
// }

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';

import '../model/schedule_detail_model.dart';

part 'schedule_param.g.dart';

@JsonSerializable()
class ScheduleParams extends Equatable {
  final int? projectId;
  final int? memberId;
  final ScheduleCategory? scheduleCategory;
  final bool?
      previous;

  const ScheduleParams({
    this.projectId,
    this.memberId,
    this.scheduleCategory,
    this.previous,
  });

  Map<String, dynamic> toJson() => _$ScheduleParamsToJson(this);

  @override
  List<Object?> get props => [projectId, memberId, scheduleCategory, previous];
}

@JsonSerializable()
class ScheduleCreateParam {
  final int projectId;
  final String startDate;
  final String endDate;
  final ScheduleCategory category;
  final List<int> memberIds;
  final String title;
  final String content;
  final String? address;

  ScheduleCreateParam({
    required this.projectId,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.memberIds,
    required this.title,
    required this.content,
    required this.address,
  });

  Map<String, dynamic> toJson() => _$ScheduleCreateParamToJson(this);
}

@JsonSerializable()
class ScheduleUpdateParam extends ScheduleCreateParam {
  final StateType state;

  ScheduleUpdateParam({
    required super.projectId,
    required super.startDate,
    required super.endDate,
    required this.state,
    required super.category,
    required super.memberIds,
    required super.title,
    required super.content,
    required super.address,
  });

  @override
  Map<String, dynamic> toJson() => _$ScheduleUpdateParamToJson(this);
}

/*
{
  "projectId": 0,
  "state": "TBD"
}
 */
@JsonSerializable()
class ScheduleStateUpdateParam {
  final int projectId;
  final StateType state;

  ScheduleStateUpdateParam({
    required this.projectId,
    required this.state,
  });

  Map<String, dynamic> toJson() => _$ScheduleStateUpdateParamToJson(this);
}

@JsonSerializable()
class ScheduleDeleteParam {
  final int projectId;

  ScheduleDeleteParam({
    required this.projectId,
  });

  Map<String, dynamic> toJson() => _$ScheduleDeleteParamToJson(this);
}
