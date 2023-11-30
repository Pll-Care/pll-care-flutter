import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/model/default_model.dart';

import '../../theme.dart';
import '../model/chart_rank_model.dart';
import '../model/midterm_model.dart';
import '../provider/midterm_provider.dart';

class RankCard extends ConsumerWidget {
  final int projectId;

  const RankCard({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(midEvalProvider(MidEvalProviderParam(
        projectId: projectId, type: MidProviderType.getChart)));
    if(model is LoadingModel){
      return const SliverToBoxAdapter(child: CircularProgressIndicator());
    }else if(model is ErrorModel){
      return const SliverToBoxAdapter(child: Text("error"),);
    }
    final chartRankModel =  (model as MidChartRankModel<ChartBadgeModel, MidTermRankModel>);
    final rankModel =chartRankModel.ranks;
    if(!chartRankModel.evaluation) {
      return SliverToBoxAdapter(child: Text("평가 없음"),);
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
                          '${rankModel[index].rank}위',
                          style: m_Heading_03.copyWith(color: GREEN_200),
                        ),
                        Text(
                          rankModel[index].name,
                          style: Heading_07.copyWith(color: GREEN_200),
                        ),
                        Text(
                          '${rankModel[index].quantity} 개',
                          style: m_Button_01.copyWith(color: GREY_500),
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
              itemCount: rankModel.length,
            ),
          ),
        ),
      ),
    );
  }
}
