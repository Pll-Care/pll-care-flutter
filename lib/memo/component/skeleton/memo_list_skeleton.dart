import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class MemoListSkeleton extends StatelessWidget {
  const MemoListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (_, idx) {
          return Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: GREY_100,
                border: Border.all(color: GREEN_200, width: 2.w)),
          );
        },
        separatorBuilder: (_, idx) => SizedBox(height: 10.h),
        itemCount: 4);
  }
}
