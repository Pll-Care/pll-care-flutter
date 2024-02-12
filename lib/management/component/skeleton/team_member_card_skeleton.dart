import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamMemberCardSkeleton extends StatelessWidget {
  const TeamMemberCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
        ),
        SizedBox(height: 8.h),
        Container(color: Colors.grey, width: 50.w, height: 15.h,),
        SizedBox(height: 8.h),
        Container(color: Colors.grey, width: 50.w, height: 15.h,),

      ],
    );
  }
}
