import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

class _ScheduleOverViewScreenState extends ConsumerState<ScheduleOverViewBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(scheduleOverviewProvider(widget.projectId).notifier)
    //       .getOverview(projectId: widget.projectId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    log(' GoRouterState.of(context).name ${GoRouterState.of(context).name}');

    log(' MediaQuery.of(context).size.width / 2 ${MediaQuery.of(context).size.width / 2}');

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: 352.w,
                  height: 646.h,
                  decoration: BoxDecoration(
                    color: GREY_100,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 20,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 14,
                        top: 12,
                        child: Text(
                          '주요 일정 미리보기',
                          style: m_Heading_03.copyWith(color: GREEN_400),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Consumer(builder: (_, ref, child) {
                        final bModel = ref.watch(scheduleOverviewProvider(
                            ScheduleProviderParam(
                                projectId: widget.projectId,
                                type: ScheduleProviderType.getOverview)));
                        if (bModel is LoadingModel) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (bModel is ErrorModel) {}
                        final model = bModel as ScheduleOverViewModel;
                        return Container(
                          width: 352.w,
                          height: 646.h,
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: ListView.separated(
                            controller: _scrollController,
                            itemBuilder: (_, idx) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(),
                                  Column(
                                    children: [
                                      if (idx == 0)
                                        Text(
                                          'start',
                                          style: m_Heading_02.copyWith(
                                              color: GREEN_200),
                                        ),
                                      if (idx == 0)
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      Container(
                                        width: 40.w,
                                        height: 40.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: GREEN_200, width: 2),
                                          color: idx % 2 == 0
                                              ? GREY_100
                                              : GREEN_200,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          (idx + 1).toString(),
                                          style: m_Heading_03.copyWith(
                                              color: idx % 2 == 0
                                                  ? GREEN_200
                                                  : GREY_100),
                                        ),
                                      ),
                                      if (idx == model.schedules.length - 1)
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      if (idx == model.schedules.length - 1)
                                        Text(
                                          'end',
                                          style: m_Heading_02.copyWith(
                                              color: GREEN_200),
                                        ),
                                    ],
                                  ),
                                  Container(),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 92,
                                child: VerticalDivider(
                                  thickness: 2,
                                  color: GREEN_200,
                                ),
                              );
                            },
                            itemCount: model.getMaxOrder(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    final startMonth = DateTimeUtil.getMonth(dateTime: startDate);
    final String scheduleRange = dateCategory == DateCategory.MONTH
        ? '${startMonth + order - 1}월'
        : '$order주차 ~ ${order + 1}주차';
    return Container(decoration: BoxDecoration(),);
  }
}
