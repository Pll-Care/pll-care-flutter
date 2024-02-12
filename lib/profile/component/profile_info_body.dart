import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

class ProfileInfoBody extends StatelessWidget {
  final int memberId;
  const ProfileInfoBody({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: GREEN_200, width: 2.w));
    final padding = EdgeInsets.symmetric(vertical: 13.h, horizontal: 12.w);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          sliver: SliverMainAxisGroup(slivers: [
            SliverToBoxAdapter(
              child: Text(
                '개인정보',
                style: m_Heading_02.copyWith(color: GREEN_500),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: padding,
                decoration: decoration,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '연락처',
                          style: m_Heading_02.copyWith(color: GREEN_500),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '수정',
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'E-mail',
                          style: m_Heading_01,
                        ),
                        Expanded(child: TextFormField()),
                        Text(
                          '@',
                          style: m_Heading_01,
                        ),
                        Expanded(child: TextFormField()),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(),
            ),
          ]),
        ),
      ],
    );
  }
}
