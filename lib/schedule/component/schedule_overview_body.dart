import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/schedule/model/schedule_overview_model.dart';
import 'package:pllcare/schedule/provider/schedule_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/model/default_model.dart';

class ScheduleOverViewBody extends ConsumerStatefulWidget {
  final int projectId;

  const ScheduleOverViewBody({super.key, required this.projectId});

  @override
  ConsumerState<ScheduleOverViewBody> createState() =>
      _ScheduleOverViewScreenState();
}

class _ScheduleOverViewScreenState extends ConsumerState<ScheduleOverViewBody> {
  @override
  void initState() {
    super.initState();
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
    final bModel = ref.watch(scheduleOverviewProvider(
        ScheduleProviderParam(projectId: widget.projectId)));
    if (bModel is LoadingModel) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (bModel is ErrorModel) {}
    final model = bModel as ScheduleOverViewModel;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: 352,
                  height: 646,
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
                      Positioned(
                        // right: 10,
                        child: const VerticalDivider(
                          thickness: 2,
                          color: GREEN_200,
                          indent: 10,
                          endIndent: 0,
                        ),
                      ),
                      // Positioned(
                      //   child: Container(
                      //     width: 2,
                      //     height: 500,
                      //     color: GREEN_200,
                      //     alignment: Alignment.center,
                      //   ),
                      //   left: MediaQuery.of(context).size.width,
                      // ),
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
