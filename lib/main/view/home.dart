import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/common/component/default_appbar.dart';
import 'package:pllcare/common/component/default_layout.dart';

import '../../project/component/project_main_card.dart';

// class HomeScreen extends StatelessWidget {
//
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const DefaultLayout( body: HomeBody());
//   }
// }

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              'assets/main/main1.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 42.h,
          ),
          Padding(
              padding: EdgeInsets.only(left: 33.w),
              child: Text(
                '프로젝트 관리 서비스, 풀케어',
                style: m_Heading_05.copyWith(color: GREEN_500),
              )),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 37.w, right: 37.w),
            child: Text(
              '유구한 역사와 전통에 빛나는 우리 대한국민은 3ㆍ1운동으로 건립된 대한민국임시정부의 법통과 불의에 항거한 4ㆍ19민주이념을 계승하고, 조국의 민주개혁과 평화적 통일의 사명에 입각하여 정의ㆍ인도와 동포애로써 민족의 단결을 공고히 하고, 모든 사회적 폐습과 불의를 타파하며, ',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: m_Body_01.copyWith(color: GREY_500),
            ),
          ),
          SizedBox(
            height: 41.h,
          ),
          const _MainContent(),
        ],
      ),
    );
  }
}

class _MainContent extends ConsumerWidget {
  const _MainContent({super.key});

  Widget getCloseDeadline({required BaseModel model}) {
    if (model is LoadingModel) {
      return Center(
        child: Text("loading"),
      );
    } else if (model is ErrorModel) {
      return Center(
        child: Text("error"),
      );
    }
    model as ListModel<ProjectCloseDeadLine>;
    return ProjectMainCard.fromModel(
        model: model.data.first, cardTitle: '마감 임박 프로젝트');
  }

  Widget getMostLike({required BaseModel model}) {
    if (model is LoadingModel) {
      return Center(
        child: Text("loading"),
      );
    } else if (model is ErrorModel) {
      return Center(
        child: Text("error"),
      );
    }
    model as ListModel<ProjectMostLiked>;
    return ProjectMainCard.fromModel(
        model: model.data.first, cardTitle: '실시간 인기 프로젝트');
  }

  Widget getUpToDate({required BaseModel model}) {
    if (model is LoadingModel) {
      return Center(
        child: Text("loading"),
      );
    } else if (model is ErrorModel) {
      return Center(
        child: Text("error"),
      );
    }
    model as ListModel<ProjectUpToDate>;
    return ProjectMainCard.fromModel(
        model: model.data.first, cardTitle: '최근 올라온 프로젝트');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mostLike = ref.watch(projectMostLikedProvider);
    final closeDeadline = ref.watch(projectCloseDeadLineProvider);
    final upToDate = ref.watch(projectUpToDateProvider);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
          color: const Color(0x00fbfbfb),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurStyle: BlurStyle.outer,
              blurRadius: 20,
              spreadRadius: 10,
            )
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 38.h,
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                getMostLike(model: mostLike),
                getCloseDeadline(model: closeDeadline),
                getUpToDate(model: upToDate),
              ],
            ),
          ),
          SizedBox(height: 43.h),
          const Divider(
            thickness: 2,
            color: GREY_400,
            indent: 26,
            endIndent: 26,
          ),
          SizedBox(height: 24.h),
          const _HomeFooter(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo2.png',
          width: 100.w,
          height: 30.h,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(
          height: 8.h,
        ),
        Text('풀케어 : FULL CARE, Project Manager',
            style: m_Body_02.copyWith(color: GREY_500)),
        SizedBox(
          height: 3.h,
        ),
        Text(
          'Copyright 2023. Team Full-Care. All rights reserved',
          style: m_Body_02.copyWith(color: GREY_500),
        ),
      ],
    );
  }
}
