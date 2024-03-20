import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/evaluation/component/skeleton/chart_skeleton.dart';
import 'package:pllcare/evaluation/provider/finalterm_provider.dart';
import 'package:pllcare/evaluation/provider/midterm_provider.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';

import '../../project/model/project_model.dart';
import '../model/chart_rank_model.dart';
import '../model/finalterm_model.dart';
import '../model/midterm_model.dart';
import 'package:collection/collection.dart';

import '../param/evaluation_param.dart';

class ChartComponent extends ConsumerStatefulWidget {
  final int projectId;

  const ChartComponent({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<ChartComponent> createState() => _ChartComponentState();
}

class _ChartComponentState extends ConsumerState<ChartComponent> {
  final double width = 10;
  late List<BarChartGroupData> showingBarGroups;
  late List<String> titles;
  late bool isCompleted;

  double maxY = 0;
  double chartWidth = 0;

  @override
  Widget build(BuildContext context) {
    FinalChartRankModel<ScoreModel, FinalTermRankModel>? finalChartModel;
    MidChartRankModel<ChartBadgeModel, MidTermRankModel>? midChartModel;
    final pModel = ref.watch(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.isCompleted, projectId: widget.projectId)));

    if (pModel is LoadingModel) {
      return const SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else if (pModel is ErrorModel) {
      return const SliverToBoxAdapter(
        child: Text("ERROR"),
      );
    }
    isCompleted = (pModel as ProjectIsCompleted).completed;
    log('isCompleted = $isCompleted');
    final model = isCompleted
        ? ref.watch(finalEvalProvider(FinalEvalProviderParam(
            projectId: widget.projectId, type: FinalProviderType.getChart)))
        : ref.watch(midEvalProvider(MidEvalProviderParam(
            projectId: widget.projectId, type: MidProviderType.getChart)));

    if (model is LoadingModel) {
      return const SliverToBoxAdapter(
        child: CustomSkeleton(skeleton: ChartSkeleton()),
      );
    } else if (model is ErrorModel) {
      return const SliverToBoxAdapter(
        child: Text("ERROR"),
      );
    }
    if (isCompleted) {
      finalChartModel =
          (model as FinalChartRankModel<ScoreModel, FinalTermRankModel>);
    } else {
      midChartModel =
          (model as MidChartRankModel<ChartBadgeModel, MidTermRankModel>);
    }

    if (finalChartModel != null && !finalChartModel.evaluation ||
        midChartModel != null && !midChartModel.evaluation) {
      return const _EmptyChart();
    }

    setMidChart(midChartModel);

    setFinalChart(finalChartModel);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Container(
          height: 300.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: GREEN_200)),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartWidth,
                  child: BarChart(
                    BarChartData(
                      maxY: (maxY * 1.4).toInt().toDouble(),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          fitInsideVertically: true,
                          tooltipBgColor: Colors.grey,
                          maxContentWidth: 500,
                          getTooltipItem: getToolTipItem,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: topTitles,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: leftTitles,
                            reservedSize: 50,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: const Border(
                              bottom: BorderSide(
                            color: GREY_400,
                          ))),
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: false),
                      groupsSpace: 20,
                      // alignment: BarChartAlignment.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setMidChart(
      MidChartRankModel<ChartBadgeModel, MidTermRankModel>? midChartModel) {
    if (midChartModel != null) {
      final midChart = midChartModel.charts;
      for (var e in midChart) {
        maxY = max(maxY, e.evaluation.supporterCnt.toDouble());
        maxY = max(maxY, e.evaluation.passionateCnt.toDouble());
        maxY = max(maxY, e.evaluation.leaderCnt.toDouble());
        maxY = max(maxY, e.evaluation.bankCnt.toDouble());
      }
      setMidChartData(midChart);
      titles = midChart.map((e) => e.name).toList();
      chartWidth = midChart.length * 80;
    }
  }

  void setFinalChart(
      FinalChartRankModel<ScoreModel, FinalTermRankModel>? finalChartModel) {
    if (finalChartModel != null) {
      final finalChart = finalChartModel.charts;
      for (var e in finalChart) {
        final score = e.evaluation.first;
        maxY = max(maxY, score.jobPerformance.toDouble());
        maxY = max(maxY, score.sincerity.toDouble());
        maxY = max(maxY, score.punctuality.toDouble());
        maxY = max(maxY, score.communication.toDouble());
      }
      setFinalChartData(finalChart);
      titles = finalChart.map((e) => e.name).toList();
      chartWidth = finalChart.length * 80;
    }
  }

  BarTooltipItem? getToolTipItem(BarChartGroupData group, gIdx, rod, rIdx) {
    // log('group $group');
    // log('gIdx $gIdx');
    // log('rod $rod');
    // log('rIdx $rIdx');
    late String toolTip;
    group.barRods.forEachIndexed((index, element) {
      switch (index) {
        case 0:
          toolTip = !isCompleted
              ? '열정적인 참여자: ${element.toY.toInt()}개\n'
              : '성실도: ${element.toY.toDouble().toStringAsFixed(1)}점\n';
          break;
        case 1:
          toolTip += !isCompleted
              ? '아이디어 뱅크: ${element.toY.toInt()}개\n'
              : '업무 수행 능력: ${element.toY.toDouble().toStringAsFixed(1)}점\n';
          break;
        case 2:
          toolTip += !isCompleted
              ? '탁월한 리더: ${element.toY.toInt()}개\n'
              : '시간 엄수: ${element.toY.toDouble().toStringAsFixed(1)}점\n';
          break;
        default:
          toolTip += !isCompleted
              ? '최고의 서포터: ${element.toY.toInt()}개'
              : '의사 소통: ${element.toY.toDouble().toStringAsFixed(1)}점';
          break;
      }
    });

    return BarTooltipItem(toolTip, Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_100));
  }

  void setMidChartData(List<MidChartModel<ChartBadgeModel>> chartModel) {
    showingBarGroups = chartModel
        .toList()
        .mapIndexed((index, c) => makeGroupData(
            index,
            c.evaluation.passionateCnt.toDouble(),
            c.evaluation.bankCnt.toDouble(),
            c.evaluation.leaderCnt.toDouble(),
            c.evaluation.supporterCnt.toDouble()))
        .toList();
  }

  void setFinalChartData(List<FinalChartModel<ScoreModel>> finalChart) {
    showingBarGroups = finalChart.mapIndexed((idx, e) {
      return makeGroupData(
          idx,
          e.evaluation.first.sincerity.toDouble(),
          e.evaluation.first.jobPerformance.toDouble(),
          e.evaluation.first.punctuality.toDouble(),
          e.evaluation.first.communication.toDouble());
    }).toList();
  }

  Widget topTitles(double value, TitleMeta meta) {
    return Container();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
      child: Text(
        meta.formattedValue,
        style: m_Body_01.copyWith(color: GREY_500),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
      child: Text(
        meta.formattedValue,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_500),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text =
        Text(titles[value.toInt()], style: Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_500));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
      int x, double y1, double y2, double y3, double y4) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: GREEN_200,
          width: width,
          borderRadius: BorderRadius.zero,
        ),
        BarChartRodData(
            toY: y2,
            color: GREEN_400,
            width: width,
            borderRadius: BorderRadius.zero),
        BarChartRodData(
            toY: y3,
            color: GREY_400,
            width: width,
            borderRadius: BorderRadius.zero),
        BarChartRodData(
            toY: y4,
            color: GREEN_500,
            width: width,
            borderRadius: BorderRadius.zero),
      ],
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: ClipRRect(
          child: Container(
            height: 300.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                border: Border.all(color: GREEN_200, width: 2.w),
                color: GREEN_200.withOpacity(.2)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Center(
                child: Text(
                  '평가를 진행해 주세요.',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.sp,
                        color: GREEN_400,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
