/*
{
  "content": [
    {
      "scheduleId": 0,
      "title": "string",
      "startDate": "2023-11-24T08:18:52.720Z",
      "endDate": "2023-11-24T08:18:52.720Z",
      "scheduleCategory": "MILESTONE",
      "members": [
        {
          "id": 0,
          "name": "string",
          "imageUrl": "string"
        }
      ],
      "state": "TBD",
      "modifyDate": "2023-11-24",
      "check": true,
      "evaluationRequired": true
    }
  ],
  "pageNumber": 0,
  "totalElements": 0,
  "totalPages": 0,
  "last": true,
  "size": 0,
  "sort": {
    "empty": true,
    "sorted": true,
    "unsorted": true
  },
  "numberOfElements": 0,
  "first": true,
  "empty": true
}
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/schedule/model/schedule_calendar_model.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';
import 'package:pllcare/schedule/model/schedule_detail_model.dart';


part 'schedule_filter_model.g.dart';

@JsonSerializable()
class ScheduleFilterList extends PaginationModel<ScheduleFilter> {
  @JsonKey(name: 'content')
  @override
  List<ScheduleFilter>? get data => super.data;

  ScheduleFilterList({
    required super.data,
    required super.pageNumber,
    required super.totalElements,
    required super.totalPages,
    required super.last,
    required super.size,
    required super.sort,
    required super.numberOfElements,
    required super.first,
    required super.empty,
  });

  factory ScheduleFilterList.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFilterListFromJson(json);
}


@JsonSerializable()
class ScheduleFilter extends ScheduleDailyModel {
  final StateType state;
  final String modifyDate;
  final bool check;
  final bool evaluationRequired;

  ScheduleFilter({
    required super.scheduleId,
    required super.title,
    required super.startDate,
    required super.endDate,
    required super.scheduleCategory,
    required super.members,
    required this.state,
    required this.modifyDate,
    required this.check,
    required this.evaluationRequired,
  });

  factory ScheduleFilter.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFilterFromJson(json);
}
