import 'package:json_annotation/json_annotation.dart';

import '../../common/model/default_model.dart';

part 'schedule_model.g.dart';

/*
{
  "startDate": "2023-11-20",
  "endDate": "2023-11-20",
  "dateCategory": "MONTH",
  "schedules": [
    {
      "id": 0,
      "title": "string",
      "startDate": "2023-11-20T13:45:32.200Z",
      "endDate": "2023-11-20T13:45:32.200Z",
      "order": 0
    }
  ]
}
 */

enum DateCategory{
  MONTH, WEEK,
}
@JsonSerializable()
class ScheduleModel extends BaseModel {
  final String startDate;
  final String endDate;
  final DateCategory dateCategory;
  final List<Schedule> schedules;

  ScheduleModel({
    required this.startDate,
    required this.endDate,
    required this.dateCategory,
    required this.schedules,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);
}

@JsonSerializable()
class Schedule {
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final int order;

  Schedule({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.order,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
