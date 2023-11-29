/*
[
  {
    "scheduleId": 0,
    "title": "string",
    "startDate": "2023-11-24T08:13:42.296Z",
    "endDate": "2023-11-24T08:13:42.296Z",
    "address": "string",
    "scheduleCategory": "MILESTONE",
    "members": [
      {
        "id": 0,
        "name": "string",
        "imageUrl": "string"
      }
    ]
  }
]
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/schedule/model/schedule_calendar_model.dart';

part 'schedule_daily_model.g.dart';

enum ScheduleCategory { MILESTONE, MEETING }

@JsonSerializable()
class ScheduleDailyModel{
  final int scheduleId;
  final String title;
  final String startDate;
  final String endDate;
  final ScheduleCategory scheduleCategory;
  final List<CalendarMember> members;

  ScheduleDailyModel({
    required this.scheduleId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.scheduleCategory,
    required this.members,
  });

  factory ScheduleDailyModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDailyModelFromJson(json);
}
