import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/schedule/component/skeleton/schedule_overview_skeleton.dart';
import 'package:pllcare/schedule/model/schedule_overview_model.dart';
import 'package:pllcare/schedule/provider/schedule_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/util.dart';

import '../../common/model/default_model.dart';

class ScheduleOverViewBody extends ConsumerStatefulWidget {
  final int projectId;

  const ScheduleOverViewBody({super.key, required this.projectId});

  @override
  ConsumerState<ScheduleOverViewBody> createState() =>
      _ScheduleOverViewScreenState();
}

final startKey = GlobalKey();
final endKey = GlobalKey();

class _ScheduleOverViewScreenState extends ConsumerState<ScheduleOverViewBody> {
  late final ScrollController _scrollController;
  Offset? start = const Offset(0, 0);
  Offset? end = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final positions = [startKey, endKey].map((key) {
        if (key.currentContext != null) {
          final RenderBox renderBox =
              key.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          return position;
        }
      }).toList();
      start = positions[0];
      end = positions[1];
      for (var position in positions) {
        log('position dx = ${position?.dx} dy = ${position?.dy} ');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log(' GoRouterState.of(context).name ${GoRouterState.of(context).name}');

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 40.h,
          ), //
          sliver: SliverToBoxAdapter(
            child: Consumer(builder: (_, ref, child) {
              final bModel = ref.watch(scheduleOverviewProvider(
                  ScheduleProviderParam(
                      projectId: widget.projectId,
                      type: ScheduleProviderType.getOverview)));
              if (bModel is LoadingModel) {
                return const CustomSkeleton(skeleton: ScheduleOverViewSkeleton());
              } else if (bModel is ErrorModel) {}
              final model = bModel as ScheduleOverViewModel;
              final format = DateFormat('yyyy년 MM월 dd일');
              final startDate =
                  format.format(DateTime.parse(model.startDate));
              final endDate =
                  format.format(DateTime.parse(model.endDate));

              return Container(
                decoration: BoxDecoration(
                  color: GREY_100,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 20.r,
                      spreadRadius: 10.r,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '주요 일정 미리보기',
                        style: m_Heading_02.copyWith(color: GREEN_400),
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          '시작 $startDate',
                          style: m_Heading_01.copyWith(color: GREEN_400),
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                            top: (start?.dy ?? 0).h,
                            left: 13.w,
                            bottom: (end?.dy ?? 0).h,
                            child: VerticalDivider(
                              thickness: 3.w,
                              color: GREEN_200,
                            ),
                          ),
                          ListView.separated(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemBuilder: (_, idx) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    key: idx == 0
                                        ? startKey
                                        : idx == model.getMaxOrder() - 1
                                            ? endKey
                                            : null,
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: GREEN_200, width: 3.w),
                                      color: idx % 2 == 0
                                          ? GREY_100
                                          : GREEN_200,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      (idx + 1).toString(),
                                      style: m_Heading_01.copyWith(
                                          color: idx % 2 == 0
                                              ? GREEN_200
                                              : GREY_100),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Flexible(
                                    child: ScheduleOverviewCard.fromModel(
                                        model: model, order: idx + 1),
                                  )
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 50.h,
                                // child: VerticalDivider(
                                //   thickness: 2.w,
                                //   color: GREEN_200,
                                // ),
                              );
                            },
                            itemCount: model.getMaxOrder(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          '종료 $endDate',
                          style: m_Heading_01.copyWith(color: GREEN_400),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

class ScheduleOverviewCard extends StatelessWidget {
  final DateCategory dateCategory;
  final String startDate;
  final int order;
  final List<Schedule> schedules;

  const ScheduleOverviewCard(
      {super.key,
      required this.dateCategory,
      required this.schedules,
      required this.order,
      required this.startDate});

  factory ScheduleOverviewCard.fromModel({
    required ScheduleOverViewModel model,
    required int order,
  }) {
    final schedules = model.getSchedulesByOrder(order: order);
    return ScheduleOverviewCard(
        dateCategory: model.dateCategory,
        schedules: schedules,
        order: order,
        startDate: model.startDate);
  }

  @override
  Widget build(BuildContext context) {
    final startMonth = DateTimeUtil.getMonth(dateTime: startDate);
    final String scheduleRange = dateCategory == DateCategory.MONTH
        ? '${startMonth + order - 1}월'
        : '${(order * 2) - 1}주차 ~ ${(order * 2)}주차';

    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: GREEN_200,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                scheduleRange,
                style: m_Heading_02.copyWith(color: GREY_100),
              )),
          ...schedules
              .map((e) => _ScheduleCard(
                    title: e.title,
                    startDate: e.startDate,
                    endDate: e.endDate,
                  ))
              .toList(),
          if (schedules.isEmpty)
            const _ScheduleCard(
              isEmpty: true,
            ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String? title;
  final String? startDate;
  final String? endDate;
  final bool isEmpty;

  const _ScheduleCard(
      {super.key,
      this.title,
      this.startDate,
      this.endDate,
      this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: GREY_100,
      ),
      margin: EdgeInsets.only(bottom: 8.h),
      constraints: BoxConstraints(
        minWidth: 250.w,
        maxWidth: 250.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      child: isEmpty
          ? Text(
              '해당 기간에 일정이 없습니다.',
              style: m_Body_01.copyWith(color: GREY_500),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: m_Body_01.copyWith(color: GREY_500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(
                  DateTimeUtil.getDateRange(start: startDate!, end: endDate!),
                  style: m_Body_01.copyWith(color: GREY_500),
                ),
              ],
            ),
    );
  }
}
