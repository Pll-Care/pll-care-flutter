import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ProjectMainCardSkeleton extends StatelessWidget {
  const ProjectMainCardSkeleton({super.key});

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
      ),
    );
  }
}
