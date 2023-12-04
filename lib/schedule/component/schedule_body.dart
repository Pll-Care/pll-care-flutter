import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pllcare/theme.dart';
import 'package:table_calendar/table_calendar.dart';

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
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? rangeStartDay;
  DateTime? rangeEndDay;

  @override
  Widget build(BuildContext context) {
    log("build~");
    final now = DateTime.now();
    CalendarStyle calendarStyle = CalendarStyle(
      rangeHighlightScale: 1.0,
      rangeHighlightColor: GREEN_200,
      selectedDecoration: const BoxDecoration(
        color: GREEN_200,
        shape: BoxShape.circle,
      ),
      rangeStartDecoration: const BoxDecoration(
        color: GREEN_200,
        shape: BoxShape.circle,
      ),
      rangeEndDecoration: const BoxDecoration(
        color: GREEN_200,
        shape: BoxShape.circle,
      ),
      withinRangeDecoration: const BoxDecoration(
        color: GREEN_200,
        shape: BoxShape.circle,
      ),
      rangeEndTextStyle: m_Heading_03.copyWith(color: GREY_100),
      rangeStartTextStyle: m_Heading_03.copyWith(color: GREY_100),
      withinRangeTextStyle: m_Heading_03.copyWith(color: GREY_100),
      defaultTextStyle: m_Heading_03.copyWith(color: GREY_500),
      outsideTextStyle: m_Heading_03.copyWith(color: GREY_400),
      holidayTextStyle: m_Heading_03.copyWith(color: Colors.red),
      weekendTextStyle: m_Heading_03.copyWith(color: GREY_500),
      selectedTextStyle: m_Heading_03.copyWith(color: GREY_100),
      canMarkersOverflow: true
    );

    final HeaderStyle headerStyle = HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: m_Heading_03.copyWith(color: GREY_500),
    );
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: TableCalendar(
            currentDay: now,
            focusedDay: now,
            firstDay: DateTime(
              2020,
              1,
              1,
            ),
            lastDay: DateTime(2999),
            locale: 'ko_KR',
            calendarFormat: CalendarFormat.month,
            onRangeSelected: (start, end, focusedDay) {
              log('start $start');
              log('end $end');
              log('focusedDay $focusedDay');
              rangeStartDay = start;
              rangeEndDay = end;
              setState(() {});
            },
            rangeEndDay: rangeEndDay,
            rangeStartDay: rangeStartDay,
            // rangeSelectionMode: RangeSelectionMode.toggledOn,
            calendarStyle: calendarStyle,
            headerStyle: headerStyle,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            pageJumpingEnabled: true,
          ),
        ),
      ],
    );
  }
}
