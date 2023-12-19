import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/schedule/provider/schedule_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:developer';
import 'package:collection/collection.dart';
import '../model/schedule_calendar_model.dart';

class CustomCalendar extends ConsumerStatefulWidget {
  final int projectId;

  const CustomCalendar({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends ConsumerState<CustomCalendar> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? rangeStartDay;
  DateTime? rangeEndDay;
  Map<DateTime, List<Event>> events = {};
  List<CalendarSchedule> calendarSchedule = [];
  List<CalendarSchedule> calendarMark = [];

  final HeaderStyle headerStyle = HeaderStyle(
    formatButtonVisible: false,
    titleCentered: true,
    titleTextStyle: m_Heading_03.copyWith(color: GREY_500),
  );
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
    markerDecoration: const BoxDecoration(
      color: GREEN_200,
      shape: BoxShape.circle,
    ),
    todayDecoration: const BoxDecoration(
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
    canMarkersOverflow: false,
  );

  DateTime getOnlyYMd(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  bool isRangeDate(String startDate, String endDate, DateTime validDay) {
    return getOnlyYMd(DateTime.parse(startDate)).isBefore(validDay) &&
            getOnlyYMd(DateTime.parse(endDate)).isAfter(validDay) ||
        getOnlyYMd(DateTime.parse(startDate)).isAtSameMomentAs(validDay) ||
        getOnlyYMd(DateTime.parse(endDate)).isAtSameMomentAs(validDay);
  }

  @override
  Widget build(BuildContext context) {
    CalendarScheduleModel? calendar;

    final model = ref.watch(scheduleProvider(ScheduleProviderParam(
        projectId: widget.projectId, type: ScheduleProviderType.getCalendar)));
    final dateFormat = DateFormat.yMMMd('ko_KR');
    if (model is CalendarScheduleModel) {
      calendar = model;
      calendarSchedule = [
        ...calendar.milestones!
            .where((e) => isRangeDate(e.startDate, e.endDate, selectedDay)),
        ...calendar.meetings!
            .where((e) => isRangeDate(e.startDate, e.endDate, selectedDay)),
      ];
      calendarMark = [...calendar.milestones!, ...calendar.meetings!];
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TableCalendar(
              // currentDay: now,
              focusedDay: selectedDay,
              firstDay: DateTime(2020, 1, 1),
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
              eventLoader: _getEventsForDay,
              pageJumpingEnabled: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Container(
                height: 310.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GREEN_200,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          dateFormat.format(selectedDay),
                          style: m_Heading_01.copyWith(color: GREY_100),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: GREY_100,
                      ),
                      if (calendarSchedule.isEmpty)
                        Expanded(
                          child: Text(
                            '오늘 회의가 없습니다',
                            style: Heading_06.copyWith(color: GREY_100),
                          ),
                        ),
                      if (calendarSchedule.isNotEmpty)
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (_, idx) {
                                return CalendarContent.fromModel(
                                    model: calendarSchedule[idx]);
                              },
                              separatorBuilder: (_, idx) {
                                return SizedBox(
                                  height: 10.h,
                                );
                              },
                              itemCount: calendarSchedule.length),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: GREY_100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48.r),
                                side: const BorderSide(
                                    color: GREEN_200, width: 2)),
                          ),
                          child: Text(
                            '새 일정 생성',
                            style: m_Button_03.copyWith(color: GREEN_400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CalendarSchedule> _getEventsForDay(DateTime day) {
    return calendarMark
        .where((e) => isRangeDate(e.startDate, e.endDate, day))
        .toList();
  }
}

class CalendarContent extends StatelessWidget {
  final String dateRange;
  final String title;
  final String? location;
  final List<CalendarMember> members;

  const CalendarContent({
    super.key,
    required this.dateRange,
    required this.title,
    this.location,
    required this.members,
  });

  factory CalendarContent.fromModel({required CalendarSchedule model}) {
    final dateFormat =
        model is Meeting ? DateFormat('hh:mm') : DateFormat('MM. dd');
    final startDate = dateFormat.format(DateTime.parse(model.startDate));
    final endDate = dateFormat.format(DateTime.parse(model.endDate));
    final dateRange = '$startDate ~ $endDate';
    if (model is Meeting) {
      return CalendarContent(
        dateRange: dateRange,
        title: model.title,
        location: model.address,
        members: model.members,
      );
    } else {
      return CalendarContent(
        dateRange: dateRange,
        title: model.title,
        members: model.members,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: GREY_100,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            dateRange,
            overflow: TextOverflow.ellipsis,
            style: m_Body_02.copyWith(
              color: GREY_500,
            ),
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: m_Heading_04.copyWith(
              color: GREY_500,
            ),
          ),
          SizedBox(
            height: 30.h,
            child: Row(
              children: [
                Text(
                  location ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: m_Body_02.copyWith(color: GREY_500),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ...members.mapIndexed((idx, e) {
                        return Positioned(
                          right: idx * 25,
                          child: Tooltip(
                            message: e.name,
                            textStyle: m_Body_01.copyWith(color: GREY_100),
                            showDuration: const Duration(seconds: 1),
                            triggerMode: TooltipTriggerMode.longPress,
                            child: CircleAvatar(
                              radius: 15,
                              // backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(e.imageUrl),
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Event {
  String title;

  Event(this.title);
}
