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
  }

  @override
  Widget build(BuildContext context) {
    log(' GoRouterState.of(context).name ${GoRouterState.of(context).name}');

    log(' MediaQuery.of(context).size.width / 2 ${MediaQuery.of(context).size.width / 2}');

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: 352.w,
                  height: 646.h,
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
                  child: Stack(
                    children: [
                      Positioned(
                        left: 14.w,
                        top: 12.h,
                        child: Text(
                          '주요 일정 미리보기',
                          style: m_Heading_02.copyWith(color: GREEN_400),
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
                          padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
                          child: Stack(children: [
                            // if(model.schedules.isNotEmpty)
                            // Positioned(
                            //   left: 39.w,
                            //     top: 60.h,
                            //     bottom: 60.h,
                            //     child: SizedBox(
                            //       height: double.infinity,
                            //       width: 4.w,
                            //       child: VerticalDivider(
                            //         thickness: 4.w,
                            //         color: GREEN_200,
                            //       ),
                            //     )),
                            ListView.separated(
                              controller: _scrollController,
                              itemBuilder: (_, idx) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        if (idx == model.getMaxOrder() - 1)
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                        if (idx == model.getMaxOrder() - 1)
                                          Text(
                                            'end',
                                            style: m_Heading_02.copyWith(
                                                color: GREEN_200),
                                          ),
                                      ],
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
                          ]),
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

class RainyEffect extends StatefulWidget {
  @override
  _RainyEffectState createState() => _RainyEffectState();
}

class _RainyEffectState extends State<RainyEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Stack(
        children: [
          CustomPaint(
            painter: RainyPainter(_animationController),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class RainyPainter extends CustomPainter {
  final AnimationController animationController;

  RainyPainter(this.animationController) : super(repaint: animationController);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red[800]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    final double progress = animationController.value;

    for (double i = 0; i < size.width; i += 10) {
      if (i % 20 == 0) {
        canvas.drawLine(
          Offset(i, progress * size.height),
          Offset(i, (progress + 0.1) * size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
