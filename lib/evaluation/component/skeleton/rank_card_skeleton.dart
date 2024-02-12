import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class RankCardSkeleton extends StatelessWidget {
  const RankCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 32.h),
      child: Container(
        height: 110.h,
        width: 340.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: GREEN_200,
        ),
      ),
    );
  }
}
