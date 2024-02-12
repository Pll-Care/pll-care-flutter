import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ParticipantCardListSkeleton extends StatelessWidget {
  const ParticipantCardListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (_, idx) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Container(
              height: 100.h,
              width: 340.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: GREY_100,
              ),
            ),
          );
        },
        separatorBuilder: (_, idx) {
          return SizedBox(
            height: 15.h,
          );
        },
        itemCount: 4);
  }
}
