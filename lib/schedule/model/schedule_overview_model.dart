import 'package:json_annotation/json_annotation.dart';
import '../../common/model/default_model.dart';
part 'schedule_overview_model.g.dart';

enum DateCategory{
  MONTH, WEEK,
}
@JsonSerializable()
class ScheduleOverViewModel extends BaseModel {
  final String startDate;
  final String endDate;
  final DateCategory dateCategory;
  final List<Schedule> schedules;

  ScheduleOverViewModel({
    required this.startDate,
    required this.endDate,
    required this.dateCategory,
    required this.schedules,
  });

  factory ScheduleOverViewModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleOverViewModelFromJson(json);

  int getMaxOrder(){
    if(schedules.isEmpty){
      return 0;
    }
    return schedules.last.order;
  }

  List<Schedule> getSchedulesByOrder({required int order}){
    return schedules.where((e) => e.order == order).toList();
  }

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
