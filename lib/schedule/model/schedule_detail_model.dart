import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'schedule_detail_model.g.dart';

/*
{
  "projectId": 0,
  "title": "string",
  "content": "string",
  "startDate": "2023-11-27T02:10:14.735Z",
  "endDate": "2023-11-27T02:10:14.735Z",
  "address": "string",
  "scheduleCategory": "MILESTONE",
  "deleteAuthorization": true,
  "members": [
    {
      "id": 0,
      "name": "string",
      "in": true
    }
  ]
}
 */
enum ScheduleCategory {
  MILESTONE,
  MEETING,
}

@JsonSerializable()
class ScheduleDetailModel extends BaseModel{
  final int projectId;
  final String title;
  final String content;
  final String startDate;
  final String endDate;
  final String? address;
  final ScheduleCategory scheduleCategory;
  final bool deleteAuthorization;
  final List<ScheduleMember> members;

  ScheduleDetailModel({
    required this.projectId,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.scheduleCategory,
    required this.deleteAuthorization,
    required this.members,
  });

  factory ScheduleDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailModelFromJson(json);
}

@JsonSerializable()
class ScheduleMember {
  final int id;
  final String name;
  @JsonKey(name: 'in')
  final bool isIn;

  ScheduleMember({
    required this.id,
    required this.name,
    required this.isIn,
  });

  factory ScheduleMember.fromJson(Map<String, dynamic> json) =>
      _$ScheduleMemberFromJson(json);
}
