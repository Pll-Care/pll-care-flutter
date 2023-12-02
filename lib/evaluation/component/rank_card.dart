import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/model/default_model.dart';

import '../../project/model/project_model.dart';
import '../../project/provider/project_provider.dart';
import '../../theme.dart';
import '../model/chart_rank_model.dart';
import '../model/finalterm_model.dart';
import '../model/midterm_model.dart';
import '../param/evaluation_param.dart';
import '../provider/finalterm_provider.dart';
import '../provider/midterm_provider.dart';

class RankCard extends ConsumerWidget {
  final int projectId;

  const RankCard({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FinalChartRankModel<ScoreModel, FinalTermRankModel>? finalRankModel;
    MidChartRankModel<ChartBadgeModel, MidTermRankModel>? midRankModel;
    final pModel = ref.watch(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.isCompleted, projectId: projectId)));
    if (pModel is LoadingModel) {
      return const SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else if (pModel is ErrorModel) {
      return const SliverToBoxAdapter(
        child: Text("ERROR"),
      );
    }

    bool isCompleted = (pModel as ProjectIsCompleted).completed;

    final model = isCompleted
        ? ref.watch(finalEvalProvider(FinalEvalProviderParam(
            projectId: projectId, type: FinalProviderType.getChart)))
        : ref.watch(midEvalProvider(MidEvalProviderParam(
            projectId: projectId, type: MidProviderType.getChart)));

    if (model is LoadingModel) {
      return const SliverToBoxAdapter(child: CircularProgressIndicator());
    } else if (model is ErrorModel) {
      return const SliverToBoxAdapter(
        child: Text("error"),
      );
    }

    if (isCompleted) {
      finalRankModel =
          (model as FinalChartRankModel<ScoreModel, FinalTermRankModel>);
    } else {
      midRankModel =
          (model as MidChartRankModel<ChartBadgeModel, MidTermRankModel>);
    }

    final List<RankModel> midRank =
        !isCompleted ? midRankModel!.ranks : finalRankModel!.ranks;

    if (finalRankModel != null && !finalRankModel.evaluation ||
        midRankModel != null && !midRankModel.evaluation) {
      return const SliverToBoxAdapter(
        child: Text("평가가 없습니다."),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 32.h),
        child: Container(
          height: 110.h,
          width: 340.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: GREEN_200,
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(0.1),
                blurStyle: BlurStyle.outer,
                blurRadius: 30,
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Container(
                    width: 100.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: GREY_100,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${midRank[index].rank}위',
                          style: m_Heading_03.copyWith(color: GREEN_200),
                        ),
                        Text(
                          midRank[index].name,
                          style: Heading_07.copyWith(color: GREEN_200),
                        ),
                        SizedBox(height: 5.h,),
                        Text(
                          !isCompleted
                              ? '${midRank[index].quantity}개'
                              : '전체 평점 ${midRank[index].quantity.toStringAsFixed(1)} / 5.0',
                          style: !isCompleted
                              ? m_Button_00.copyWith(color: GREY_500)
                              : m_Button_01.copyWith(color: GREY_500),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 10.w,
                );
              },
              itemCount: midRank.length,
            ),
          ),
        ),
      ),
    );
  }
}
