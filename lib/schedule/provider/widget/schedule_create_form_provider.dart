import 'package:pllcare/project/component/project_form.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/schedule_daily_model.dart';
import '../../model/schedule_detail_model.dart';

part 'schedule_create_form_provider.g.dart';

class ScheduleForm {
  final String title;
  final ScheduleCategory category;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? address;
  final List<int> memberIds;
  final String content;

  ScheduleForm({
    required this.title,
    required this.category,
    required this.startDateTime,
    required this.endDateTime,
    this.address,
    required this.memberIds,
    required this.content,
  });

  ScheduleForm copyWith({
    String? title,
    ScheduleCategory? category,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? address,
    List<int>? memberIds,
    String? content,
  }) {
    return ScheduleForm(
      title: title ?? this.title,
      category: category ?? this.category,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      memberIds: memberIds ?? this.memberIds,
      content: content ?? this.content,
    );
  }

  factory ScheduleForm.fromModel({required ScheduleDetailModel model}) {
    return ScheduleForm(
        title: model.title,
        category: model.scheduleCategory,
        startDateTime: DateTime.parse(model.startDate),
        endDateTime: DateTime.parse(model.endDate),
        memberIds: model.members.map((e) => e.id).toList(),
        content: model.content);
  }

  ScheduleForm updateDay(
      {required DateTime? startDay, required DateTime? endDay}) {
    return ScheduleForm(
      title: title,
      category: category,
      startDateTime: startDay,
      endDateTime: endDay,
      memberIds: memberIds,
      content: content,
    );
  }
}

@Riverpod(keepAlive: false)
class ScheduleCreateForm extends _$ScheduleCreateForm {
  @override
  ScheduleForm build() {
    return ScheduleForm(
        title: '',
        category: ScheduleCategory.MILESTONE,
        startDateTime: DateTime.now(),
        endDateTime: DateTime.now(),
        memberIds: [],
        content: '');
  }

  void updateForm({required ScheduleForm form}) {
    state = form;
  }

  bool hasMember({required int memberId}) {
    return state.memberIds.contains(memberId);
  }

  void initForm({required ScheduleForm form}) {
    state = form;
  }
}
