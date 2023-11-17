import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/common/component/default_appbar.dart';
import 'package:pllcare/common/component/default_layout.dart';

import '../component/project_card.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(appbar: DefaultAppbar(), body: _HomeBody());
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({super.key});

  @override
  Widget build(BuildContext context) {
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
          const ProjectCard(
            cardTitle: '마감 임박 프로젝트',
            title: '우리 팀의 미래를 함께할 팀원을 찾습니다!',
            period: '2023-04-30 ~ 2023-12-23',
            content:
                '저희는 SmartLiving 프로젝트를 시작하게 되었습니다. 이 프로젝트는 최신 기술을 활용하여 스마트 홈 시스템을 개발하고자 합니다. 더 편리하고 효율적인 스마트 라이프를 만들어 갈 팀원을 찾습니다.',
            imageUrl: 'assets/main/main1.png',
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
