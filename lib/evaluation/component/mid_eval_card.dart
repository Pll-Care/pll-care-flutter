import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/evaluation/provider/midterm_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/custom_dialog.dart';

import '../../schedule/model/schedule_calendar_model.dart';
import '../../schedule/model/schedule_detail_model.dart';
import '../../schedule/model/schedule_filter_model.dart';
import '../model/midterm_model.dart';

class MidEvalCard extends StatelessWidget {
  final String title;
  final String period;
  final List<CalendarMember> members;

  const MidEvalCard(
      {super.key,
      required this.title,
      required this.period,
      required this.members});

  factory MidEvalCard.fromModel({required ScheduleFilter model}) {
    final dateFormat = model.scheduleCategory == ScheduleCategory.MILESTONE
        ? DateFormat('MM-dd')
        : DateFormat('MM-dd HH:mm');
    final startDate = dateFormat.format(DateTime.parse(model.startDate));
    final endDate = dateFormat.format(DateTime.parse(model.endDate));
    final period = '$startDate ~ $endDate 진행';
    return MidEvalCard(
      title: model.title,
      period: period,
      members: model.members,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final IconData icon;
    // switch (badge.evaluationBadge) {
    //   case BadgeType.PASSIONATE:
    //     icon = Icons.local_fire_department;
    //     break;
    //   case BadgeType.BANK:
    //     icon = Icons.lightbulb;
    //
    //     break;
    //   case BadgeType.LEADER:
    //     icon = Icons.people;
    //
    //     break;
    //   case BadgeType.SUPPORTER:
    //     icon = Icons.handshake;
    //     break;
    // }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 5 * 4,
      height: 570.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '중간평가 작성',
            style: m_Heading_05.copyWith(color: GREY_100),
          ),
          SizedBox(height: 5.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: GREY_100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: Heading_04.copyWith(color: GREEN_400),
                  ),
                  Text(
                    period,
                    style: m_Heading_02.copyWith(color: GREY_500),
                  ),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: GREEN_200, width: 2),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '참여자 선택',
                            style: m_Heading_02.copyWith(color: GREEN_400),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 70.h,
                            ),
                            child: Wrap(
                              spacing: 7.w,
                              children: [
                                ...members
                                    .map(
                                      (e) => Chip(
                                        label: Text(
                                          e.name,
                                        ),
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            '뱃지 선택',
                            style: m_Heading_02.copyWith(color: GREEN_400),
                          ),
                          const _RadioTile(
                            badgeType: BadgeType.PASSIONATE,
                          ),
                          const _RadioTile(
                            badgeType: BadgeType.BANK,
                          ),
                          const _RadioTile(
                            badgeType: BadgeType.LEADER,
                          ),
                          const _RadioTile(
                            badgeType: BadgeType.SUPPORTER,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 13.h,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: CustomDialog.textButtonStyle,
              child: Text(
                '작성 완료',
                style: m_Body_01.copyWith(color: GREEN_400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioTile extends ConsumerWidget {
  final BadgeType badgeType;

  const _RadioTile({super.key, required this.badgeType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title;
    final IconData icon;
    switch (badgeType) {
      case BadgeType.PASSIONATE:
        title = '열정적인 참여자';
        icon = Icons.local_fire_department;
        break;
      case BadgeType.BANK:
        title = '아이디어 뱅크';
        icon = Icons.lightbulb;
        break;
      case BadgeType.LEADER:
        title = '탁월한 리더';
        icon = Icons.people;

        break;
      case BadgeType.SUPPORTER:
        title = '최고의 서포터';
        icon = Icons.handshake;
        break;
    }
    final selectedBadge = ref.watch(badgeProvider);

    return RadioListTile<BadgeType>(
        controlAffinity: ListTileControlAffinity.trailing,
        title: Row(
          children: [
            Card(
              shape: CircleBorder(
                  side: BorderSide(
                      width: 2,
                      color:
                          selectedBadge == badgeType ? GREEN_200 : GREY_100)),
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    icon,
                    color: GREEN_200,
                  )),
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              title,
              style: m_Heading_03.copyWith(color: GREY_500),
            ),
          ],
        ),
        activeColor: GREEN_200,
        // overlayColor:
        //     MaterialStateProperty.all(GREEN_200),
        fillColor: MaterialStateProperty.all(GREEN_200),
        value: badgeType,
        groupValue: selectedBadge == badgeType ? badgeType : null,
        // selected: true,
        onChanged: (value) {
          ref.read(badgeProvider.notifier).update((state) => value!);
        });
  }
}
