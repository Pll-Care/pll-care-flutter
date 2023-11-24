import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/project/param/param.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/project/view/project_management_screen.dart';
import 'package:pllcare/theme.dart';

import '../../common/model/default_model.dart';

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
              padding: EdgeInsets.only(left: 11.w, right: 24.w, top: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          radius: 20.r,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: m_Heading_02.copyWith(
                              color: GREEN_500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state != StateType.COMPLETE)
                    InkWell(
                      onTap: () {
                        customDialog(context, ref);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurStyle: BlurStyle.outer,
                                blurRadius: 20,
                                spreadRadius: 10,
                              )
                            ]),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.exit_to_app,
                              size: 18,
                            ),
                            Text(
                              '팀 나가기',
                              style: m_Button_02.copyWith(color: GREEN_400),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                    style: m_Body_02.copyWith(
                      color: GREY_500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '프로젝트 설명: $content',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: m_Body_02.copyWith(
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



  void customDialog(BuildContext context, WidgetRef ref) {
    final textButtonStyle = TextButton.styleFrom(
      backgroundColor: GREY_100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48.r),
      ),
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            backgroundColor: GREEN_200,
            content: Text(
              '정말 팀 탈퇴하시겠습니까?\n팀 탈퇴 후에는 복구가 불가합니다.',
              style: Heading_06.copyWith(
                color: GREY_100,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsPadding: const EdgeInsets.only(bottom: 24),
            actions: [
              SizedBox(
                height: 35,
                width: 80,
                child: TextButton(
                  onPressed: () {
                    ref
                        .read(projectProvider.notifier)
                        .selfOut(projectId: projectId);
                    context.pop();
                  },
                  style: textButtonStyle,
                  child: Text(
                    '네',
                    style: Button_03.copyWith(color: GREEN_400),
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
                    style: textButtonStyle,
                    child: Text(
                      '아니오',
                      style: Button_03.copyWith(color: GREEN_400),
                    )),
              )
            ],
          );
        });
  }
}
