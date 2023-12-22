import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';
import 'package:pllcare/schedule/provider/widget/schedule_create_form_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme.dart';
import '../model/schedule_calendar_model.dart';

final HeaderStyle headerStyle = HeaderStyle(
  formatButtonVisible: false,
  titleCentered: true,
  titleTextStyle: m_Heading_03.copyWith(color: GREY_500),
);
final CalendarStyle calendarStyle = CalendarStyle(
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
  markerDecoration: const BoxDecoration(
    color: GREEN_200,
    shape: BoxShape.circle,
  ),
  // todayDecoration: const BoxDecoration(
  //   color: GREEN_200,
  //   shape: BoxShape.circle,
  // ),
  isTodayHighlighted: false,
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
  todayTextStyle: m_Heading_03.copyWith(color: GREY_100),

  canMarkersOverflow: false,
);

class CalendarComponent extends ConsumerStatefulWidget {
  const CalendarComponent({super.key});

  @override
  ConsumerState<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends ConsumerState<CalendarComponent> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? rangeStartDay;
  DateTime? rangeEndDay;

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(scheduleCreateFormProvider);
    if (form.category == ScheduleCategory.MEETING) {
      rangeStartDay = null;
      rangeEndDay = null;
      focusedDay = form.startDateTime;
      selectedDay = form.startDateTime;
    } else {
      rangeStartDay = form.startDateTime;
      rangeEndDay = form.endDateTime;
      selectedDay = DateTime.now();
    }

    log('rangeStartDay ${rangeStartDay}');
    log('rangeEndDay ${rangeEndDay}');

    return TableCalendar(
      // currentDay: now,
      focusedDay: focusedDay,
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2999),
      locale: 'ko_KR',
      calendarFormat: CalendarFormat.month,
      daysOfWeekHeight: 24.h,
      onRangeSelected: (start, end, focusedDay) {
        log('start $start');
        log('end $end');
        log('focusedDay $focusedDay');
        // rangeStartDay = start;
        // rangeEndDay = end;
        this.focusedDay = focusedDay;
        final form = ref.read(scheduleCreateFormProvider);
        ref.read(scheduleCreateFormProvider.notifier).updateForm(
            form: form.copyWith(startDateTime: start, endDateTime: end));
        setState(() {});
      },
      onDaySelected: form.category == ScheduleCategory.MEETING
          ? (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
              ref.read(scheduleCreateFormProvider.notifier).updateForm(
                  form: form.copyWith(
                      startDateTime: focusedDay, endDateTime: focusedDay));
            }
          : null,
      rangeEndDay: form.endDateTime,
      rangeStartDay: rangeStartDay,
      rangeSelectionMode: form.category == ScheduleCategory.MILESTONE
          ? RangeSelectionMode.enforced
          : RangeSelectionMode.disabled,
      calendarStyle: calendarStyle,
      headerStyle: headerStyle,
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      // eventLoader: _getEventsForDay,
      pageJumpingEnabled: true,
    );
  }

// List<CalendarSchedule> _getEventsForDay(DateTime day) {
//   return calendarMark
//       .where((e) => isRangeDate(e.startDate, e.endDate, day))
//       .toList();
// }
}
