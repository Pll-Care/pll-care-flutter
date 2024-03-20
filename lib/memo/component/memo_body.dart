import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

import 'memo_list_component.dart';

class MemoBody extends StatelessWidget {
  final int projectId;

  const MemoBody({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 650.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.1),
                    blurRadius: 30.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
                color: GREY_100,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: MemoListComponent(
                projectId: projectId,
              ),
            ),
          ),
        )
      ],
    );
  }
}
