import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ScheduleOverViewSkeleton extends StatelessWidget {
  const ScheduleOverViewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600.h,
      decoration: BoxDecoration(
        color: GREY_100,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
