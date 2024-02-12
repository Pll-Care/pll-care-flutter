import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ProjectListCardSkeleton extends StatelessWidget {
  const ProjectListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 360.w,
            height: 135.h,
            decoration: BoxDecoration(
              border: Border.all(color: GREEN_200, width: 1),
              color: GREY_500,
              borderRadius: BorderRadius.circular(15.r),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 18.h,
          );
        },
      ),
    );
  }
}
