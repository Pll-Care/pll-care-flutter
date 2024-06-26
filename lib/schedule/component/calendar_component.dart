import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';
import 'package:pllcare/schedule/provider/widget/schedule_create_form_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme.dart';
import '../model/schedule_calendar_model.dart';
import '../model/schedule_detail_model.dart';



class CalendarComponent extends ConsumerStatefulWidget {
  const CalendarComponent({super.key});

  @override
  ConsumerState<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends ConsumerState<CalendarComponent> {
  DateTime? selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? rangeStartDay;
  DateTime? rangeEndDay;
  bool validRangeStartDay = true;
  bool validRangeEndDay = true;
  bool validSelectDay = true;
  bool validRangeHighlight = true;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_500);
    final form = ref.watch(scheduleCreateFormProvider);
    validDay(form);
    final HeaderStyle headerStyle = HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: Theme.of(context)
          .textTheme
          .headlineSmall!.copyWith(color: GREY_500),
    );
    final CalendarStyle calendarStyle = CalendarStyle(
      rangeHighlightScale: 1.0,
      rangeHighlightColor: validRangeHighlight ? GREEN_200 : Colors.red,
      selectedDecoration: BoxDecoration(
        color: validSelectDay ? GREEN_200 : Colors.red,
        shape: BoxShape.circle,
      ),
      rangeStartDecoration: BoxDecoration(
        color: validRangeStartDay ? GREEN_200 : Colors.red,
        shape: BoxShape.circle,
      ),
      rangeEndDecoration: BoxDecoration(
        color: validRangeEndDay ? GREEN_200 : Colors.red,
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
      withinRangeDecoration: BoxDecoration(
        color: validRangeHighlight ? GREEN_200 : Colors.red,
        shape: BoxShape.circle,
      ),
      rangeEndTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_100),
      rangeStartTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_100),
      withinRangeTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_100),
      defaultTextStyle: defaultTextStyle,
      outsideTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_400),
      holidayTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: Colors.red),
      weekendTextStyle: defaultTextStyle,
      selectedTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_100),
      todayTextStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_100),
      canMarkersOverflow: false,
    );

    log('rangeStartDay ${rangeStartDay}');
    log('rangeEndDay ${rangeEndDay}');

    return TableCalendar(
      // currentDay: now,
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:defaultTextStyle,
          weekendStyle: defaultTextStyle),
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
        ref
            .read(scheduleCreateFormProvider.notifier)
            .updateForm(form: form.updateDay(startDay: start, endDay: end));

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

  void validDay(ScheduleForm form) {
    if (form.category == ScheduleCategory.MEETING) {
      rangeStartDay = null;
      rangeEndDay = null;
      focusedDay = form.startDateTime!;
      selectedDay = form.startDateTime!;
      validSelectDay = selectedDay!.isAfter(DateTime.now());
    } else {
      rangeStartDay = form.startDateTime;
      rangeEndDay = form.endDateTime;
      selectedDay = null;// DateTime.now();
      log('form.startDateTime ${form.startDateTime}');
      log('form.endDateTime ${form.endDateTime}');
      if (rangeStartDay != null) {
        validRangeStartDay = rangeStartDay!.isAfter(DateTime.now());
      }
      if (rangeEndDay != null) {
        validRangeEndDay = rangeEndDay!.isAfter(DateTime.now());
      }
      validRangeHighlight = validRangeStartDay && validRangeEndDay;
    }
  }

// List<CalendarSchedule> _getEventsForDay(DateTime day) {
//   return calendarMark
//       .where((e) => isRangeDate(e.startDate, e.endDate, day))
//       .toList();
// }
}
