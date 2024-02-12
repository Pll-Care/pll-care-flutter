import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            color: GREY_500,

          ),
        ),
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
            color: GREY_500,

          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
          ),
        )
      ],
    );
  }
}
