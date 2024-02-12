import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class ProfilePostCardListSkeleton extends StatelessWidget {
  const ProfilePostCardListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: GREEN_200,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10.h);
        },
        itemCount: 4);
  }
}
