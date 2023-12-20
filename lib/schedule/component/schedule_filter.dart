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
    ScheduleFilterModel? filterModel =
        ref.watch(scheduleFilterProvider(projectId));
    ListModel<TeamMemberModel>? teamMembers;
    ref.listen(managementProvider(projectId), (previous, next) {
      if (previous is LoadingModel && next is ListModel<TeamMemberModel>) {
        final memberId = next.data.first.memberId;
        log('memberId $memberId');
        ref
            .read(scheduleFilterProvider(projectId).notifier)
            .selectFilter(memberId: memberId, filterType: FilterType.ALL);
      }else if(previous != next){

      }
    });
    ref.listen(scheduleFilterProvider(projectId), (previous, next) {
      log('previous ${previous}');
      log('next ${next}');
      final PageParams params = PageParams(page: 1, size: 4, direction: 'DESC');
      ScheduleParams? condition;
      condition = getFilterParam(next, condition);
      ref
          .read(
              scheduleFilterFetchProvider(params: params, condition: condition)
                  .notifier)
          .getFilter(params: params, condition: condition);
      // ref.read(scheduleProvider(ScheduleProviderParam(
      //     projectId: projectId, type: ScheduleProviderType.getFilter)).notifier)
      //     .getFilter(params: PageParams(page: page, size: 4, direction: 'DESC'), condition: condition);
    });
    if (model is LoadingModel) {
      return const SliverToBoxAdapter(child: CircularProgressIndicator());
    } else if (model is ErrorModel) {
      return const SliverToBoxAdapter(child: Text("error"));
    } else {
      teamMembers = model as ListModel<TeamMemberModel>;
    }
    log("teamMembers.length ${teamMembers.data.length}");

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FilterCategories(
              filterModel: filterModel,
              projectId: projectId,
            ),
            _FilterNames(
              teamMembers: teamMembers,
              projectId: projectId,
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
    // if (next.filterType == FilterType.PREVIOUS) {
    //   condition = ScheduleParams(
    //       memberId: next.memberId, previous: true, projectId: projectId);
    // } else
    if (next.filterType == FilterType.ALL) {
      condition = ScheduleParams(memberId: next.memberId, projectId: projectId);
    } else if (next.filterType == FilterType.PLAN) {
      condition = ScheduleParams(
          memberId: next.memberId,
          scheduleCategory: ScheduleCategory.MILESTONE,
          projectId: projectId);
    } else {
      condition = ScheduleParams(
          memberId: next.memberId,
          scheduleCategory: ScheduleCategory.MEETING,
          projectId: projectId);
    }
    return condition;
  }
}

class _FilterChip extends ConsumerWidget {
  final int projectId;
  final ScheduleFilterModel? filterModel;
  final FilterType filterType;

  const _FilterChip({
    super.key,
    required this.filterModel,
    required this.filterType,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref
            .read(scheduleFilterProvider(projectId).notifier)
            .selectFilter(filterType: filterType);
      },
      child: Chip(
        label: Text(
          filterType.name,
          style: m_Body_01.copyWith(
            color: filterModel == null
                ? GREY_100
                : filterModel!.filterType == filterType
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
            : filterModel!.filterType == filterType
                ? GREEN_200
                : GREY_100,
      ),
    );
  }
}

class _FilterCategories extends StatelessWidget {
  final ScheduleFilterModel? filterModel;
  final int projectId;

  const _FilterCategories(
      {super.key, required this.filterModel, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          filterModel: filterModel,
          filterType: FilterType.ALL,
          projectId: projectId,
        ),
        SizedBox(width: 5.w),
        _FilterChip(
          filterModel: filterModel,
          filterType: FilterType.PLAN,
          projectId: projectId,
        ),
        SizedBox(width: 5.w),
        _FilterChip(
          filterModel: filterModel,
          filterType: FilterType.MEETING,
          projectId: projectId,
        ),
        SizedBox(width: 5.w),
        _FilterChip(
          filterModel: filterModel,
          filterType: FilterType.PREVIOUS,
          projectId: projectId,
        ),
      ],
    );
  }
}

class _FilterNames extends ConsumerWidget {
  final int projectId;
  final ListModel<TeamMemberModel> teamMembers;

  const _FilterNames({
    super.key,
    required this.teamMembers,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterModel = ref.watch(scheduleFilterProvider(projectId));

    return Container(
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
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(scheduleFilterProvider(projectId).notifier)
                          .selectFilter(memberId: e.memberId);
                    },
                    child: Chip(
                      label: Text(
                        e.name,
                        style: m_Heading_01.copyWith(
                          color: filterModel.memberId == e.memberId
                              ? GREY_100
                              : GREEN_400,
                        ),
                      ),
                      backgroundColor: filterModel.memberId == e.memberId
                          ? GREEN_400
                          : GREY_100,
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
