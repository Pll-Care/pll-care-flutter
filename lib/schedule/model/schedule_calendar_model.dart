import 'package:json_annotation/json_annotation.dart';
import '../../common/model/default_model.dart';
part 'schedule_calendar_model.g.dart';

@JsonSerializable()
class CalendarScheduleModel extends BaseModel {
  final List<Meeting>? meetings;
  final List<Milestone>? milestones;

  CalendarScheduleModel({
    required this.meetings,
    required this.milestones,
  });

  factory CalendarScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarScheduleModelFromJson(json);
}

@JsonSerializable()
class CalendarSchedule {
  final int scheduleId;
  final String title;
  final String content;
  final String startDate;
  final String endDate;
  final List<CalendarMember> members;

  CalendarSchedule({
    required this.scheduleId,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.members,
  });

  factory CalendarSchedule.fromJson(Map<String, dynamic> json) =>
      _$CalendarScheduleFromJson(json);
}

@JsonSerializable()
class Meeting extends CalendarSchedule {
  final String address;
  Meeting({
    required super.scheduleId,
    required super.title,
    required super.content,
    required super.startDate,
    required super.endDate,
    required super.members,
    required this.address,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
}

@JsonSerializable()
class Milestone extends CalendarSchedule {
  Milestone(
      {required super.scheduleId,
      required super.title,
      required super.content,
      required super.startDate,
      required super.endDate,
      required super.members});

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}

@JsonSerializable()
class CalendarMember {
  final int id;
  final String name;
  final String imageUrl;

  CalendarMember({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CalendarMember.fromJson(Map<String, dynamic> json) => _$CalendarMemberFromJson(json);
}
