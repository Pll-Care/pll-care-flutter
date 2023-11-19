import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

import '../model/project_model.dart';

class ProjectMainCard extends StatelessWidget {
  final String cardTitle;
  final String imageUrl;
  final String title;
  final String period;
  final String content;
  final int? likeCount;

  const ProjectMainCard({
    super.key,
    required this.cardTitle,
    required this.title,
    required this.period,
    required this.content,
    required this.imageUrl,
    this.likeCount,
  });

  factory ProjectMainCard.fromModel(
      {required ProjectMainModel model, required String cardTitle}) {
    if (model is ProjectMostLiked) {
      model as ProjectMostLiked;
      return ProjectMainCard(
        cardTitle: cardTitle,
        title: model.title,
        period: model.recruitEndDate,
        content: model.description,
        imageUrl: model.projectImageUrl ?? '',
        likeCount: model.likeCount,
      );
    } else {
      return ProjectMainCard(
        cardTitle: cardTitle,
        title: model.title,
        period: model.recruitEndDate,
        content: model.description,
        imageUrl: model.projectImageUrl ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        height: 270.h,
        width: 220.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: GREEN_200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 14.h,
                left: 12.w,
                bottom: 8.h,
              ),
              child: Text(
                cardTitle,
                style: Heading_05.copyWith(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Container(
                height: 195.h,
                width: 195.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: GREY_100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 13.w,
                        right: 13.w,
                        top: 6.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: imageUrl.isNotEmpty
                                ? NetworkImage(
                                    imageUrl,
                                  )
                                : null,
                            radius: 27.r,
                          ),
                          if (likeCount != null)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: GREEN_200, width: 2)),
                              child: Column(
                                children: [
                                  SizedBox(height: 6.h),
                                  const Icon(
                                    Icons.favorite,
                                    color: GREEN_200,
                                    size: 18,
                                  ),
                                  Text(
                                    likeCount.toString(),
                                    style: Body_02.copyWith(color: GREEN_200),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: Heading_05.copyWith(color: GREY_500),
                          ),
                          Text(
                            period,
                            overflow: TextOverflow.ellipsis,
                            style: Body_01.copyWith(color: GREY_500),
                          ),
                          Text(
                            content,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Body_01.copyWith(
                              color: GREY_500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
