// {
// "projectId": 0,
// "memberId": 0,
// "scheduleCategory": "MILESTONE",
// "previous": true
// }

import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';

part 'schedule_param.g.dart';

@JsonSerializable()
class ScheduleParams {
  final int? projectId;
  final int? memberId;
  final ScheduleCategory? scheduleCategory;
  final bool? previous;

  ScheduleParams({
    this.projectId,
    this.memberId,
    this.scheduleCategory,
    this.previous,
  });

  Map<String, dynamic> toJson() => _$ScheduleParamsToJson(this);
}
