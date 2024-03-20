import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/schedule/component/schedule_create_form.dart';
import 'package:pllcare/schedule/model/schedule_detail_model.dart';
import 'package:pllcare/schedule/provider/schedule_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/custom_dialog.dart';

import '../../project/provider/project_provider.dart';
import '../param/schedule_param.dart';
import '../provider/widget/schedule_create_form_provider.dart';

class ScheduleDialogComponent extends ConsumerWidget {
  final int projectId;
  final int scheduleId;

  const ScheduleDialogComponent({
    super.key,
    required this.projectId,
    required this.scheduleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCompleted = true;
    final state = ref.watch(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.isCompleted, projectId: projectId)));
    if (state is ProjectIsCompleted) {
      isCompleted = state.completed;
    }

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context)
        .textTheme
        .labelLarge!.copyWith(color: GREY_500);
    final model = ref.watch(scheduleProvider(ScheduleProviderParam(
        projectId: projectId,
        type: ScheduleProviderType.getSchedule,
        scheduleId: scheduleId)));
    if (model is LoadingModel) {
      return SizedBox(
        width: size.width / 5 * 4,
        height: size.height / 3 * 2,
        // child: const CircularProgressIndicator(),
      );
    } else if (model is ErrorModel) {
      return SizedBox(
        width: size.width / 5 * 4,
        height: size.height / 3 * 2,
        child: const Text('error'),
      );
    }
    model as ScheduleDetailModel;
    final remainingDay =
        DateTime.parse(model.startDate).difference(DateTime.now()).inDays;
    final format = DateFormat('MM-dd E HH:mm', 'ko_KR');

    String title = '';
    String content = '';
    void onSavedTitle(String? newValue) {
      title = newValue!;
    }

    void onSavedContent(String? newValue) {
      content = newValue!;
    }

    void updateSchedule(WidgetRef ref, projectId) {
      final formKey = GlobalKey<FormState>();
      final textButtonStyle = TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48.r)));
      CustomDialog.showCustomDialog(
          context: context,
          backgroundColor: GREY_100,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: GREY_100,
            ),
            width: MediaQuery.of(context).size.width / 10 * 8,
            child: ScheduleFormComponent(
              projectId: projectId,
              formKey: formKey,
              onSavedTitle: onSavedTitle,
              onSavedContent: onSavedContent,
              model: model,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    // todo detail 캐시 값 변경
                    final form = ref.read(scheduleCreateFormProvider);
                    log('formKey.currentState!.validate() ${formKey.currentState!.validate()}');
                    log(' form.memberIds.isNotEmpty ${form.memberIds.isNotEmpty}');
                    formKey.currentState!.save();
                    if (formKey.currentState!.validate() &&
                        form.memberIds.isNotEmpty) {
                      final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
                      final state = DateTime.now().isAfter(form.startDateTime!)
                          ? StateType.ONGOING
                          : StateType.TBD;
                      log('state ${state}');
                      final ScheduleUpdateParam param = ScheduleUpdateParam(
                          projectId: projectId,
                          startDate: format.format(form.startDateTime!),
                          endDate: format.format(form.endDateTime!),
                          category: form.category,
                          memberIds: form.memberIds,
                          title: title,
                          content: content,
                          address: form.address,
                          state: state);
                      await ref
                          .read(scheduleProvider(ScheduleProviderParam(
                                  projectId: projectId,
                                  type: ScheduleProviderType.create,
                                  scheduleId: scheduleId))
                              .notifier)
                          .updateSchedule(param: param);

                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                  style: textButtonStyle,
                  child: Text(
                    '수정완료',
                    style: Theme.of(context)
                    .textTheme
                    .displayMedium!.copyWith(color: GREY_100),
                  ),
                ),
                SizedBox(width: 12.w),
                TextButton(
                    onPressed: () => context.pop(),
                    style: textButtonStyle,
                    child: Text('취소',
                        style: Theme.of(context)
                    .textTheme
                    .displayMedium!.copyWith(color: GREY_100))),
                SizedBox(width: 20.w),
              ],
            )
          ]);
    }

    return SingleChildScrollView(
      child: Container(
        width: size.width / 5 * 4,
        height: size.height / 3 * 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: GREEN_200, width: 2)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    model.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: GREY_500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Chip(
                  label: Text(
                    remainingDay == 0
                        ? 'd-day'
                        : remainingDay > 0
                            ? 'd-$remainingDay'
                            : 'd+${remainingDay.abs()}',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GREEN_400,
                    ),
                  ),
                  backgroundColor: GREY_100,
                  elevation: 3,
                  shadowColor: Colors.black54,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            SizedBox(
              height: 23.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    '진행 일시',
                    style: textStyle,
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "시작",
                          style: textStyle,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          format.format(DateTime.parse(model.startDate)),
                          style: textStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "종료",
                          style: textStyle,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          format.format(DateTime.parse(model.endDate)),
                          style: textStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    '참여자',
                    style: textStyle,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8.w,
                    children: [
                      ...model.members.where((e) => e.isIn).map((e) {
                        return Text(
                          e.name,
                          style: textStyle,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      '내용',
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    model.content,
                    style: textStyle,
                  )),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            if (model.scheduleCategory == ScheduleCategory.MEETING)
              Row(
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      '위치',
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(model.address ?? '')
                ],
              ),
            SizedBox(height: 10.h),
            if (!isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (model.deleteAuthorization)
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(scheduleProvider(ScheduleProviderParam(
                                    projectId: projectId,
                                    type: ScheduleProviderType.delete,
                                    scheduleId: scheduleId))
                                .notifier)
                            .deleteSchedule();
                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: GREY_100,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.r),
                        ),
                      ),
                      child: Text(
                        '삭제하기',
                        style: Theme.of(context)
                    .textTheme
                    .displayMedium!.copyWith(color: GREEN_400),
                      ),
                    ),
                  SizedBox(
                    width: 12.w,
                  ),
                  TextButton(
                    onPressed: () {
                      updateSchedule(ref, projectId);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: GREEN_200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48.r),
                      ),
                    ),
                    child: Text(
                      '수정하기',
                      style: Theme.of(context)
                    .textTheme
                    .displayMedium!.copyWith(color: GREY_100),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
