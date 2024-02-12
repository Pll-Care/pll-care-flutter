import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ProfileEvalCardListSkeleton extends StatelessWidget {
  const ProfileEvalCardListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (_, idx) {
          return Container(
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: GREY_500,
            ),
          );
        },
        separatorBuilder: (_, idx) {
          return SizedBox(height: 10.h);
        },
        itemCount: 4);
  }
}
