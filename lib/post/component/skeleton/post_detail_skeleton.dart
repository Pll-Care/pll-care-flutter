import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

class PostDetailSkeleton extends StatelessWidget {
  const PostDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.h,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: GREY_500,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 400.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: GREEN_200, width: 2.w),
                color: GREY_100,
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.1),
                      blurRadius: 30.r,
                      offset: Offset(0, 10.h)),
                ]),
          )
        ],
      ),
    );
  }
}
