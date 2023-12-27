import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/schedule/component/filter/schedule_filter_card.dart';

import '../../../common/model/default_model.dart';
import '../../../common/page/component/bottom_page_count.dart';
import '../../../common/page/param/page_param.dart';
import '../../../evaluation/component/mid_eval_card.dart';
import '../../../project/model/project_model.dart';
import '../../../theme.dart';
import '../../../util/custom_dialog.dart';
import '../../model/schedule_daily_model.dart';
import '../../model/schedule_detail_model.dart';
import '../../model/schedule_filter_model.dart';
import '../../param/schedule_param.dart';
import '../../provider/schedule_provider.dart';
import '../../provider/widget_provider.dart';
import '../schedule_dialog_component.dart';

class ScheduleFilterContent extends ConsumerStatefulWidget {
  final int projectId;

  const ScheduleFilterContent({super.key, required this.projectId});

  @override
  ConsumerState<ScheduleFilterContent> createState() =>
      _ScheduleFilterContentState();
}

class _ScheduleFilterContentState extends ConsumerState<ScheduleFilterContent> {
  int cardCnt = 0;
  ScheduleParams? condition;

  @override
  Widget build(BuildContext context) {
    ref.listen(scheduleFilterProvider(widget.projectId),
            (previous, next) async {
          final PageParams params = PageParams(
              page: 1, size: 4, direction: 'DESC');
          condition = getFilterParam(next);
          await ref
              .read(scheduleFilterFetchProvider(condition: condition!).notifier)
              .getFilter(params: params, condition: condition!);
          // ref.read(scheduleProvider(ScheduleProviderParam(
          //     projectId: projectId, type: ScheduleProviderType.getFilter)).notifier)
          //     .getFilter(params: PageParams(page: page, size: 4, direction: 'DESC'), condition: condition);
        });
    final filter = ref.watch(scheduleFilterProvider(widget.projectId));
    condition = getFilterParam(filter);
    final model = ref.watch(scheduleFilterFetchProvider(condition: condition!));
    final isCompleted = ref.watch(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.isCompleted, projectId: widget.projectId)));
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 740.h, minHeight: 140.h),
        // todo 개수에 맞게 높이 조절
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: GREY_100,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurStyle: BlurStyle.outer,
              blurRadius: 20,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 25.h,
        ),
        child:
        // ScheduleFilterCard.fromModel(model: modelList[0])
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            if (model is LoadingModel) {
              return CircularProgressIndicator();
            } else if (model is ErrorModel) {
              return Text("error");
            }
            final pModelList = (model as PaginationModel<ScheduleFilter>);
            final modelList = pModelList.data!;
            cardCnt = modelList.length;
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverList.separated(
                  itemBuilder: (_, idx) {
                    return ScheduleFilterCard.fromModel(
                      model: modelList[idx],
                      isCompleted: (isCompleted is ProjectIsCompleted)
                          ? isCompleted.completed
                          : false,
                      onTap: () {
                        CustomDialog.showCustomDialog(
                          context: context,
                          backgroundColor: GREY_100,
                          content: ScheduleDialogComponent(
                            projectId: widget.projectId,
                            scheduleId: modelList[idx].scheduleId,
                          ),
                        );
                      },
                      onComplete: () {
                        onComplete(context, modelList, idx);
                      },
                      onEval: () {
                        CustomDialog.showCustomDialog(
                            context: context,
                            backgroundColor: GREEN_200,
                            content: MidEvalCard.fromModel(model: modelList[idx])
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, idx) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: modelList.length,
                ),
                BottomPageCount<ScheduleFilter>(
                  pModelList: pModelList,
                  onTapPage: (int page) {
                    _onTapPage(ref, page, widget.projectId);
                  },
                ),
              ],
            );
          },
        ),
        // Column(
        //   children: [
        //     Expanded(
        //       child: ListView.separated(
        //           physics: const NeverScrollableScrollPhysics(),
        //           itemBuilder: (_, idx) {
        //             return ScheduleFilterCard.fromModel(
        //                 model: modelList[idx]);
        //           },
        //           separatorBuilder: (_, idx) {
        //             return SizedBox(
        //               height: 10.h,
        //             );
        //           },
        //           itemCount: modelList.length),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Future<void> onPressed(WidgetRef ref, List<ScheduleFilter> modelList, int idx,
      BuildContext context) async {
    await ref
        .read(scheduleProvider(ScheduleProviderParam(
        projectId: widget.projectId,
        type: ScheduleProviderType.updateState,
        scheduleId: modelList[idx].scheduleId))
        .notifier)
        .updateState(
        param: ScheduleStateUpdateParam(
            projectId: widget.projectId, state: StateType.COMPLETE));
    if (context.mounted) {
      context.pop();
    }
  }

  void onComplete(BuildContext context, List<ScheduleFilter> modelList,
      int idx) {
    final String content =
    DateTime.now().isBefore(DateTime.parse(modelList[idx].endDate))
        ? '예정된 종료 일자보다 먼저 일정이 완료되었습니까?'
        : '일정을 완료하시겠습니까?';
    CustomDialog.showCustomDialog(
        context: context,
        backgroundColor: GREEN_200,
        content: Text(
          content,
          style: Body_01.copyWith(color: GREY_100),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await onPressed(ref, modelList, idx, context);
            },
            style: CustomDialog.textButtonStyle,
            child: Text(
              '네',
              style: m_Button_00.copyWith(color: GREEN_200),
            ),
          ),
          TextButton(
              onPressed: () => context.pop(),
              style: CustomDialog.textButtonStyle,
              child: Text('아니오', style: m_Button_00.copyWith(color: GREEN_200)))
        ]);
  }

  void _onTapPage(WidgetRef ref, int page, int projectId) {
    log("page = $page");
    final PageParams params =
    PageParams(page: page, size: 4, direction: 'DESC');
    ScheduleParams? condition;
    final filter = ref.read(scheduleFilterProvider(projectId));
    condition = getFilterParam(filter);
    ref
        .read(scheduleFilterFetchProvider(condition: condition).notifier)
        .getFilter(params: params, condition: condition);
  }

  ScheduleParams getFilterParam(ScheduleFilterModel next) {
    final ScheduleParams condition;
    if (next.filterType == FilterType.PREVIOUS) {
      condition = ScheduleParams(
          memberId: next.memberId, previous: true, projectId: widget.projectId);
    } else if (next.filterType == FilterType.ALL) {
      condition =
          ScheduleParams(memberId: next.memberId, projectId: widget.projectId);
    } else if (next.filterType == FilterType.PLAN) {
      condition = ScheduleParams(
          memberId: next.memberId,
          scheduleCategory: ScheduleCategory.MILESTONE,
          projectId: widget.projectId);
    } else {
      condition = ScheduleParams(
          memberId: next.memberId,
          scheduleCategory: ScheduleCategory.MEETING,
          projectId: widget.projectId);
    }
    return condition;
  }
}
