import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';
import 'package:pllcare/schedule/param/schedule_param.dart';
import 'package:pllcare/schedule/provider/schedule_provider.dart';
import 'package:pllcare/util/custom_dialog.dart';

import '../../../common/component/tech_stack_icon.dart';
import '../../../theme.dart';
import 'package:collection/collection.dart';

import '../../model/schedule_calendar_model.dart';
import '../../model/schedule_detail_model.dart';
import '../../model/schedule_filter_model.dart';

class ScheduleFilterCard extends ConsumerWidget {
  final int scheduleId;
  final String day;
  final String dayOfWeek;
  final String period;
  final String title;
  final String modifiedDay;
  final bool evaluationRequired;
  final List<CalendarMember> members;
  final int remainingDay;
  final bool? check;
  final bool isCompleted;
  final GestureTapCallback onTap;
  final GestureTapCallback onComplete;
  final VoidCallback onEval;

  const ScheduleFilterCard({
    super.key,
    required this.scheduleId,
    required this.day,
    required this.dayOfWeek,
    required this.period,
    required this.title,
    required this.modifiedDay,
    required this.evaluationRequired,
    required this.members,
    required this.remainingDay,
    required this.check,
    required this.isCompleted,
    required this.onTap,
    required this.onComplete,
    required this.onEval,
  });

  factory ScheduleFilterCard.fromModel({
    required ScheduleFilter model,
    required bool isCompleted,
    required GestureTapCallback onTap,
    required GestureTapCallback onComplete,
    required VoidCallback onEval,
  }) {
    final dateFormat = model.scheduleCategory == ScheduleCategory.MILESTONE
        ? DateFormat('MM-dd')
        : DateFormat('HH:mm');
    final onlyDayFormat = DateFormat('dd');
    final startDate = dateFormat.format(DateTime.parse(model.startDate));
    final endDate = dateFormat.format(DateTime.parse(model.endDate));
    final period = '$startDate ~ $endDate';
    final day = onlyDayFormat.format(DateTime.parse(model.startDate));
    final dayOfWeek =
        DateFormat('EEEE', 'ko').format(DateTime.parse(model.startDate));
    final remainingDay =
        DateTime.parse(model.startDate).difference(DateTime.now());

    return ScheduleFilterCard(
      scheduleId: model.scheduleId,
      day: day,
      dayOfWeek: dayOfWeek,
      period: period,
      title: model.title,
      modifiedDay: model.modifyDate,
      evaluationRequired: model.evaluationRequired,
      members: model.members,
      remainingDay: remainingDay.inDays,
      check: model.check,
      isCompleted: isCompleted,
      onTap: onTap,
      onComplete: onComplete,
      onEval: onEval,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 150.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: GREY_500,
                  ),
                ),
                Text(
                  dayOfWeek,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: GREY_500,
                  ),
                ),
                if (evaluationRequired && !isCompleted)
                  TextButton(
                    onPressed: onEval,
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        // visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: GREEN_200, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(24.r),
                          ),
                        ),
                        backgroundColor: GREY_100),
                    child: Text(
                      "평가하기",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: GREEN_400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: GREY_100,
                  border: Border.all(
                    color: GREEN_200,
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            period,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              color: GREY_500,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: GREY_500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                ...members.mapIndexed((idx, e) {
                                  return Positioned(
                                    left: idx * 25,
                                    child: Tooltip(
                                      message: e.name,
                                      textStyle:
                                          Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_100),
                                      showDuration: const Duration(seconds: 1),
                                      triggerMode: TooltipTriggerMode.longPress,
                                      child: CircleAvatar(
                                        backgroundImage: e.imageUrl.isNotEmpty
                                            ? NetworkImage(e.imageUrl)
                                            : const AssetImage(
                                                    'assets/main/main1.png')
                                                as ImageProvider,
                                        radius: 15.r,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                          if (check != null && check == false)
                            Row(
                              children: [
                                Text(
                                  '$modifiedDay 수정',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      color: (check != null && check == true)
                                          ? GREEN_400
                                          : Colors.red),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            remainingDay == 0
                                ? 'd-day'
                                : remainingDay > 0
                                    ? 'd-$remainingDay'
                                    : 'd+${remainingDay.abs()}',
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: GREEN_400,
                            ),
                          ),
                          backgroundColor: GREY_100,
                          elevation: 3,
                          shadowColor: Colors.black54,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        if (!evaluationRequired) SizedBox(height: 10.h),
                        if (!evaluationRequired &&
                            !isCompleted &&
                            remainingDay <= 0)
                          InkWell(
                            onTap: onComplete,
                            child: Chip(
                              label: Text(
                                "완료하기",
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: GREY_100,
                                ),
                              ),
                              backgroundColor: GREEN_200,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
