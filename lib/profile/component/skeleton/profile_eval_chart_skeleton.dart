import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ProfileEvalChartSkeleton extends StatelessWidget {
  const ProfileEvalChartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: GREY_500,
      ),
    );
  }
}
