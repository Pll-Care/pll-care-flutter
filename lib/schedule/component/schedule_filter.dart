import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/management/provider/management_provider.dart';
import 'package:pllcare/schedule/model/schedule_daily_model.dart';
import 'package:pllcare/schedule/provider/schedule_provider.dart';
import 'package:pllcare/schedule/provider/widget_provider.dart';

import '../../common/model/default_model.dart';
import '../../management/model/team_member_model.dart';
import '../../theme.dart';
import '../param/schedule_param.dart';

class ScheduleFilter extends ConsumerWidget {
  final int projectId;

  const ScheduleFilter({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(managementProvider(projectId));
    ScheduleFilterModel? filterModel;
    ListModel<TeamMemberModel>? teamMembers;

    ref.watch(scheduleProvider(ScheduleProviderParam(
        projectId: projectId, type: ScheduleProviderType.getFilter)));

    if (model is LoadingModel) {
      return SliverToBoxAdapter(child: const CircularProgressIndicator());
    } else if (model is ErrorModel) {
      return SliverToBoxAdapter(child: const Text("error"));
    } else {
      teamMembers = model as ListModel<TeamMemberModel>;
      filterModel = ref.watch(scheduleFilterProvider(projectId));
      log("teamMembers.length ${teamMembers.data.length}");
    }
    log("teamMembers.length ${teamMembers.data.length}");
    ref.listen(scheduleFilterProvider(projectId), (previous, next) {
      final PageParams params = PageParams(page: 1, size: 4, direction: 'DESC');
      ScheduleParams? condition;
      condition = getFilterParam(next, condition);
      ref.read(scheduleFilterFetchProvider(params: params, condition: condition).notifier)
          .getFilter(params: params, condition: condition);
      // ref.read(scheduleProvider(ScheduleProviderParam(
      //     projectId: projectId, type: ScheduleProviderType.getFilter)).notifier)
      //     .getFilter(params: PageParams(page: page, size: 4, direction: 'DESC'), condition: condition);
    });

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(scheduleFilterProvider(projectId).notifier)
                        .selectFilter(filterType: FilterType.ALL);
                  },
                  child: Chip(
                    label: Text(
                      'ALL',
                      style: m_Body_01.copyWith(
                        color: filterModel == null
                            ? GREY_100
                            : filterModel.filterType == FilterType.ALL
                                ? GREY_100
                                : GREEN_400,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: GREEN_200, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(24.r),
                      ),
                    ),
                    backgroundColor: filterModel == null
                        ? GREEN_200
                        : filterModel.filterType == FilterType.ALL
                            ? GREEN_200
                            : GREY_100,
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(scheduleFilterProvider(projectId).notifier)
                        .selectFilter(filterType: FilterType.PLAN);
                  },
                  child: Chip(
                    label: Text(
                      'PLAN',
                      style: m_Body_01.copyWith(
                        color: filterModel?.filterType == FilterType.PLAN
                            ? GREY_100
                            : GREEN_400,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(scheduleFilterProvider(projectId).notifier)
                        .selectFilter(filterType: FilterType.MEETING);
                  },
                  child: Chip(
                    label: Text(
                      'MEETING',
                      style: m_Body_01.copyWith(color: GREY_100),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(scheduleFilterProvider(projectId).notifier)
                        .selectFilter(filterType: FilterType.PREVIOUS);
                  },
                  child: Chip(
                    label: Text(
                      'PREVIOUS',
                      style: m_Body_01.copyWith(color: GREY_100),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: GREEN_200,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '참여자',
                      style: m_Heading_01.copyWith(
                        color: GREY_100,
                      ),
                    ),
                    Wrap(
                      spacing: 8.w,
                      children: [
                        ...teamMembers.data.map((e) {
                          return Chip(
                            label: Text(
                              e.name,
                              style: m_Heading_01.copyWith(
                                color: GREY_100,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
              ),
              child: Container(
                height: 400.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GREY_100,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 20,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 25.h,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '1',
                          style: m_Heading_05.copyWith(
                            color: GREY_500,
                          ),
                        ),
                        Text(
                          'Wed',
                          style: m_Body_01.copyWith(
                            color: GREY_500,
                          ),
                        ),
                        TextButton(onPressed: () {}, child: Text("평가하기")),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: GREY_100,
                          border: Border.all(
                            color: GREEN_200,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 5.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '13 ~ 16',
                                    style: m_Heading_04.copyWith(
                                      color: GREY_500,
                                    ),
                                  ),
                                  Text(
                                    '13 ~ 16',
                                    style: m_Body_01.copyWith(
                                      color: GREY_500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('2021 수정'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Chip(
                                  label: Text(
                                    'd-day',
                                    style: m_Button_03.copyWith(
                                      color: GREEN_400,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "완료하기",
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ScheduleParams getFilterParam(
      ScheduleFilterModel next, ScheduleParams? condition) {
    if (next.filterType == FilterType.PREVIOUS) {
      condition = ScheduleParams(memberId: next.memberId, previous: true);
    } else if (next.filterType == FilterType.ALL) {
      condition = ScheduleParams(memberId: next.memberId);
    } else if (next.filterType == FilterType.PLAN) {
      condition = ScheduleParams(
          memberId: next.memberId,
          scheduleCategory: ScheduleCategory.MILESTONE);
    } else {
      condition = ScheduleParams(
          memberId: next.memberId, scheduleCategory: ScheduleCategory.MEETING);
    }
    return condition;
  }
}
