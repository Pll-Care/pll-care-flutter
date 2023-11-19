import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/dio/param/param.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/theme.dart';

class ProjectListCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String period;
  final String content;
  final ProjectListType state;

  const ProjectListCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.period,
    required this.state,
  });

  factory ProjectListCard.fromModel({required ProjectListModel model}) {
    return ProjectListCard(
      imageUrl: model.imageUrl ?? '',
      title: model.title,
      content: model.description,
      period: '${model.startDate} ~ ${model.endDate}',
      state: model.state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        radius: 20.r,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: m_Heading_02.copyWith(
                            color: GREEN_500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(state != ProjectListType.COMPLETE)
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration:
                        const BoxDecoration(shape: BoxShape.circle, boxShadow: [
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
                  style: m_Body_02.copyWith(
                    color: GREY_500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
