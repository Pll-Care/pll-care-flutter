import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/profile/component/skeleton/profile_eval_chart_skeleton.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

import '../model/profile_eval_chart_model.dart';

class ProfileEvalChart extends StatelessWidget {
  final int memberId;

  const ProfileEvalChart({super.key, required this.memberId});

  BarChartData getChartData(ProfileEvalChartModel model) {
    final BarChartGroupData sincerity =
        BarChartGroupData(barsSpace: 2, x: 1, barRods: [
      BarChartRodData(
          toY: model.score.sincerity.toDouble(),
          color: GREEN_200,
          width: 20.w,
          borderRadius: BorderRadius.zero),
    ]);

    final BarChartGroupData jobPerformance =
        BarChartGroupData(barsSpace: 2, x: 2, barRods: [
      BarChartRodData(
          toY: model.score.jobPerformance.toDouble(),
          color: GREEN_200,
          width: 20.w,
          borderRadius: BorderRadius.zero),
    ]);

    final BarChartGroupData punctuality =
        BarChartGroupData(barsSpace: 2, x: 3, barRods: [
      BarChartRodData(
          toY: model.score.punctuality.toDouble(),
          color: GREEN_200,
          width: 20.w,
          borderRadius: BorderRadius.zero),
    ]);
    final BarChartGroupData communication =
        BarChartGroupData(barsSpace: 2, x: 4, barRods: [
      BarChartRodData(
          toY: model.score.communication.toDouble(),
          color: GREEN_200,
          width: 20.w,
          borderRadius: BorderRadius.zero),
    ]);
    final BarChartData chartData = BarChartData(
        maxY: 5,
        barGroups: [sincerity, jobPerformance, punctuality, communication],
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            drawBelowEverything: false,
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getLeftTitles,
                reservedSize: 30),
          ),
          rightTitles: const AxisTitles(
            drawBelowEverything: false,
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: const Border(
                bottom: BorderSide(
              color: GREY_400,
            ))),
        groupsSpace: 40,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false));
    return chartData;
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    late String title;
    switch (value) {
      case 1:
        title = '성실도';
        break;
      case 2:
        title = '시간 엄수';
        break;
      case 3:
        title = '업무 수행';
        break;
      default:
        title = '의사 소통';
        break;
    }

    final Widget text = Text(title, style: TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        fontSize: 16.sp).copyWith(color: GREY_500));
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    final Widget text = Text(value.toInt().toString(),
        style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16.sp).copyWith(color: GREY_500));
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      return ref.watch(profileEvalChartProvider(memberId: memberId)).when(
          data: (data) {
            final BarChartData chartData = getChartData(data);
            return SliverToBoxAdapter(
                child: Container(
              height: 400.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: GREEN_200,
                  width: 2.w,
                ),
              ),
              child: BarChart(
                chartData,
              ),
            ));
          },
          error: (_, __) {
            return const SliverToBoxAdapter(child: Text('error'));
          },
          loading: () => const SliverToBoxAdapter(
              child: CustomSkeleton(skeleton: ProfileEvalChartSkeleton())));
    });
  }
}
