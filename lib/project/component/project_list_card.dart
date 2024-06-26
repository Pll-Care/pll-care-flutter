import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/project/view/project_management_screen.dart';
import 'package:pllcare/theme.dart';

import '../../common/component/default_flash.dart';
import '../../common/model/default_model.dart';
import '../../util/custom_dialog.dart';

class ProjectListCard extends ConsumerWidget {
  final int projectId;
  final String imageUrl;
  final String title;
  final String period;
  final String content;
  final StateType state;

  const ProjectListCard({
    super.key,
    required this.projectId,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.period,
    required this.state,
  });

  factory ProjectListCard.fromModel({required ProjectListModel model}) {
    return ProjectListCard(
      projectId: model.projectId,
      imageUrl: model.imageUrl ?? '',
      title: model.title,
      content: model.description,
      period: '${model.startDate} ~ ${model.endDate}',
      state: model.state,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final pathParam = {'projectId': projectId.toString()};
        context.pushNamed(ProjectManagementScreen.routeName,
            pathParameters: pathParam);
      },
      child: Container(
        width: 360.w,
        height: 125.h,
        decoration: BoxDecoration(
          border: Border.all(color: GREEN_200, width: 1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 15.h, bottom: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/main/main1.png') as ImageProvider,
                          radius: 20.r,
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              fontSize: 20.sp,
                              color: GREEN_500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // todo 백엔드 처리 x
                  // if (state != StateType.COMPLETE)
                  //   InkWell(
                  //     onTap: () {
                  //       onTapSelfOut(context: context, ref: ref);
                  //     },
                  //     child: Container(
                  //       width: 30,
                  //       height: 30,
                  //       decoration: const BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Color.fromRGBO(0, 0, 0, 0.1),
                  //               blurStyle: BlurStyle.outer,
                  //               blurRadius: 20,
                  //               spreadRadius: 10,
                  //             )
                  //           ]),
                  //       child: Column(
                  //         children: [
                  //           const Icon(
                  //             Icons.exit_to_app,
                  //             size: 18,
                  //           ),
                  //           Text(
                  //             '팀 나가기',
                  //             style: m_Button_02.copyWith(color: GREEN_400),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
            SizedBox(
              width: 250.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '진행 기간: $period',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: GREY_500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '프로젝트 설명: $content',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: GREY_500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapSelfOut({required BuildContext context, required WidgetRef ref}) {
    CustomDialog.showCustomDialog(
        context: context,
        backgroundColor: GREEN_200,
        content: Text(
          '정말 팀 탈퇴하시겠습니까?\n팀 탈퇴 후에는 복구가 불가합니다.',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            color: GREY_100,
          ),
        ),
        actions: [
          SizedBox(
            height: 35,
            width: 80,
            child: TextButton(
              onPressed: () async {
                final result = await ref
                    .read(projectFamilyProvider(ProjectProviderParam(
                            type: ProjectProviderType.selfOut,
                            projectId: projectId))
                        .notifier)
                    .selfOut();
                if(result is CompletedModel && context.mounted){
                  context.pop();
                }else if(result is ErrorModel && context.mounted){
                  DefaultFlash.showFlash(
                      context: context,
                      type: FlashType.fail,
                      content: result.message);
                }
              },
              style: CustomDialog.textButtonStyle,
              child: Text(
                '네',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!.copyWith(color: GREEN_400),
              ),
            ),
          ),
          SizedBox(
            height: 35,
            width: 80,
            child: TextButton(
                onPressed: () {
                  context.pop();
                },
                style: CustomDialog.textButtonStyle,
                child: Text(
                  '아니오',
                  style: Theme.of(context)
                    .textTheme
                    .displayLarge!.copyWith(color: GREEN_400),
                )),
          )
        ]);
  }
}
