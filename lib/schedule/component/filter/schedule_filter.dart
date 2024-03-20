import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/management/provider/management_provider.dart';
import 'package:pllcare/schedule/component/filter/schedule_filter_content.dart';
import 'package:pllcare/schedule/provider/widget_provider.dart';

import '../../../common/model/default_model.dart';
import '../../../management/model/team_member_model.dart';
import '../../../theme.dart';
import '../../param/schedule_param.dart';
import '../skeleton/schedule_filter_skeleton.dart';

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
      } else if (previous != next) {}
    });

    if (model is LoadingModel) {
      return const SliverToBoxAdapter(child: CustomSkeleton(skeleton: ScheduleFilterSkeleton()));
    } else if (model is ErrorModel) {
      return const SliverToBoxAdapter(child: Text("error"));
    } else {
      teamMembers = model as ListModel<TeamMemberModel>;
    }

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
            SizedBox(height: 16.h),
            _FilterNames(
              teamMembers: teamMembers,
              projectId: projectId,
            ),
            ScheduleFilterContent(projectId: projectId),
          ],
        ),
      ),
    );
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
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
              style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(
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
                        style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(
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
