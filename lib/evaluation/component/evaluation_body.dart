import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/evaluation/component/participant_card.dart';
import 'package:pllcare/evaluation/component/rank_card.dart';
import 'package:pllcare/evaluation/component/skeleton/participant_card_list_skeleton.dart';
import 'package:pllcare/evaluation/provider/eval_provider.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/model/default_model.dart';
import '../../profile/view/profile_screen.dart';
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.only(left: 25.w, top: 14.h, bottom: 14.h),
              child: Text(
                '뱃지 개수 차트',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 20.sp,
                      color: GREEN_200,
                    ),
              )),
        ),
        ChartComponent(
          projectId: widget.projectId,
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.only(left: 25.w, bottom: 14.h, top: 25.h),
              child: Text(
                '기여도 랭킹',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20.sp,
                  color: GREEN_400,
                ),
              )),
        ),
        RankCard(
          projectId: widget.projectId,
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.only(left: 25.w, bottom: 14.h),
              child: Text(
                '참여자 보기',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20.sp,
                  color: GREEN_400,
                ),
              )),
        ),
        Consumer(
          builder: (_, ref, __) {
            final model = ref.watch(
                evalProvider(EvalProviderParam(projectId: widget.projectId)));
            final pModel = ref.watch(projectFamilyProvider(ProjectProviderParam(
                type: ProjectProviderType.isCompleted,
                projectId: widget.projectId)));

            if (model is LoadingModel) {
              return const SliverToBoxAdapter(
                child: CustomSkeleton(skeleton: ParticipantCardListSkeleton()),
              );
            }
            if (model is ListModel<ParticipantModel> &&
                pModel is ProjectIsCompleted) {
              return SliverList.separated(
                  itemBuilder: (_, idx) {
                    if (model.data.length > idx) {
                      return InkWell(
                        onTap: () {
                          final Map<String, String> pathParameters = {
                            'memberId': model.data[idx].memberId.toString()
                          };
                          context.pushNamed(ProfileScreen.routeName,
                              pathParameters: pathParameters);
                        },
                        child: ParticipantCard.fromModel(
                          model: model.data[idx],
                          isCompleted: pModel.completed,
                          projectId: widget.projectId,
                        ),
                      );
                    }
                    return null;
                  },
                  separatorBuilder: (_, idx) {
                    return SizedBox(
                      height: 15.h,
                    );
                  },
                  itemCount: model.data.length + 1);
            }
            return const SliverToBoxAdapter(child: Text("error"));
          },
        )
      ],
    );
  }
}
