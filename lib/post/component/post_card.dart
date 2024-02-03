import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/post/view/post_screen.dart';

import '../../common/component/tech_stack_icon.dart';
import '../../post/model/post_model.dart';
import '../../theme.dart';
import '../../util/model/techstack_model.dart';

class PostCard extends StatelessWidget {
  final int postId;
  final String imageUrl;
  final String title;
  final String startDate;
  final String endDate;
  final List<TechStackModel> techStackList;
  final List<RecruitModel> recruitInfoList;
  final int likeCount;
  final bool liked;
  final VoidCallback onTapLike;

  const PostCard({
    super.key,
    required this.postId,
    required this.imageUrl,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.techStackList,
    required this.recruitInfoList,
    required this.likeCount,
    required this.liked,
    required this.onTapLike,
  });

  factory PostCard.fromModel(
      {required PostListModel model, required VoidCallback onTapLike}) {
    return PostCard(
      postId: model.postId,
      imageUrl: model.projectImageUrl ?? '',
      title: model.title ?? '',
      startDate: model.recruitStartDate ?? '',
      endDate: model.recruitEndDate ?? '',
      techStackList: model.techStackList,
      recruitInfoList: model.recruitInfoList,
      likeCount: model.likeCount,
      liked: model.liked,
      onTapLike: onTapLike,
    );
  }

  @override
  Widget build(BuildContext context) {
    String position = recruitInfoList
        .where((e) => e.currentCnt < e.totalCnt)
        .map((e) => e.position.name)
        .reduce((value, element) => '$value, $element');
    log("title ${title}");
    log("liked ${liked}");

    return GestureDetector(
      onTap: () {
        Map<String, String> pathParameters = {'postId': postId.toString()};
        context.pushNamed(PostDetailScreen.routeName,
            pathParameters: pathParameters);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/main/main1.png')
                          as ImageProvider,
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
          ),
          Container(
            height: 180.h,
            // width: double.infinity,
            decoration: BoxDecoration(
                color: GREY_100,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.25),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 10.r,
                      // spreadRadius: 5,
                      offset: Offset(0.0, 4.h))
                ],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...getTechAvatars(),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        title,
                        style: m_Heading_04.copyWith(color: GREY_500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                      GestureDetector(
                        onTap: onTapLike,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(
                            width: 45.w,
                            height: 45.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: GREEN_200, width: 2.w)),
                            child: Column(
                              children: [
                                SizedBox(height: 2.h),
                                Icon(
                                  liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: GREEN_200,
                                  size: 15.w,
                                ),
                                Text(
                                  likeCount.toString(),
                                  style: Body_02.copyWith(color: GREEN_200),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    '모집기간 : \n$startDate ~ $endDate',
                    style: m_Button_01.copyWith(color: GREY_500),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    '모집 포지션 :\n$position',
                    style: m_Button_01.copyWith(color: GREY_500),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Padding> getTechAvatars() {
    final List<TechStackModel> techAvatars;
    if (techStackList.length > 5) {
      techAvatars = techStackList.sublist(0, 5);
    } else {
      techAvatars = techStackList;
    }
    return techAvatars.map((e) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        child: TechStackIcon(
          name: e.name,
          imageUrl: e.imageUrl,
        ),
      );
    }).toList();
  }
}
