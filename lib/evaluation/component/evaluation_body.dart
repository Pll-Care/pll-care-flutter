import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/evaluation/component/participant_card.dart';
import 'package:pllcare/evaluation/provider/eval_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/model/default_model.dart';
import '../model/participant_model.dart';
import 'chart_component.dart';

class EvaluationBody extends StatefulWidget {
  final int projectId;

  const EvaluationBody({
    super.key,
    required this.projectId,
  });

  @override
  State<EvaluationBody> createState() => _EvaluationBodyState();
}

class _EvaluationBodyState extends State<EvaluationBody> {
  @override
  Widget build(BuildContext context) {
    final data = [12, 5, 4, 8, 10];
    final barGroups = data.map((e) => BarChartGroupData(x: e)).toList();
    return CustomScrollView(
      slivers: [
        ChartComponent(
          projectId: widget.projectId,
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.only(left: 25.w, bottom: 14.h),
              child: Text(
            '참여자 보기',
            style: m_Heading_02.copyWith(color: GREEN_400),
          )),
        ),
        Consumer(
          builder: (_, ref, __) {
            final model = ref.watch(
                evalProvider(EvalProviderParam(projectId: widget.projectId)));
            if (model is LoadingModel) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text("로딩"),
                ),
              );
            }
            if (model is ListModel<ParticipantModel>) {
              return SliverList.separated(
                  itemBuilder: (_, idx) {
                    return  ParticipantCard.fromModel(model: model.data[idx], isCompleted: false,); // todo completed 가져오기
                  },
                  separatorBuilder: (_, idx) {
                    return SizedBox(
                      height: 15.h,
                    );
                  },
                  itemCount: model.data.length);
            }
            // final pModel = model as ListModel<ParticipantModel>;
            return const SliverToBoxAdapter(child: Text("error"));
          },
        )
      ],
    );
  }
}
