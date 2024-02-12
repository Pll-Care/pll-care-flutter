import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ScheduleFilterSkeleton extends StatelessWidget {
  const ScheduleFilterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: [
              Chip(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: GREEN_200, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.r),
                  ),
                ),
                label: const Text('ALL'),
              ),
              SizedBox(width: 5.w),
              Chip(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: GREEN_200, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.r),
                  ),
                ),
                label: const Text('PLAN'),
              ),
              SizedBox(width: 5.w),
              Chip(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: GREEN_200, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.r),
                  ),
                ),
                label: const Text('MEETING'),
              ),
              SizedBox(width: 5.w),
              Chip(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: GREEN_200, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.r),
                  ),
                ),
                label: const Text('PREVIOUS'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: GREEN_200,
            ),
          ),
        ],
      ),
    );
  }
}
