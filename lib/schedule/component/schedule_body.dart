import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pllcare/schedule/component/filter/schedule_filter.dart';
import 'custom_calendar.dart';

class ScheduleBody extends StatefulWidget {
  final int projectId;

  const ScheduleBody({
    super.key,
    required this.projectId,
  });

  @override
  State<ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  @override
  Widget build(BuildContext context) {
    log("build~");

    return CustomScrollView(
      slivers: [
        CustomCalendar(
          projectId: widget.projectId,
        ),
        ScheduleFilter(projectId: widget.projectId,),
      ],
    );
  }
}
