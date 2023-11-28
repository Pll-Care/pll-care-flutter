
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../model/apply_model.dart';
import '../model/team_member_model.dart';

class ApplyCard extends ConsumerWidget {
  final String imageUrl;
  final String name;
  final PositionType position;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ApplyCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.onAccept,
    required this.onReject,
  });

  factory ApplyCard.fromModel(
      {required ApplyModel model,
        required VoidCallback onAccept,
        required VoidCallback onReject}) {
    return ApplyCard(
      imageUrl: model.imageUrl,
      name: model.name,
      position: model.position,
      onAccept: onAccept,
      onReject: onReject,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        width: double.infinity,
        height: 70.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: GREEN_200)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: m_Heading_03.copyWith(color: GREY_500),
                  ),
                  Text(
                    position.name,
                    style: m_Body_01.copyWith(color: GREY_500),
                  )
                ],
              ),
            ),
            _ApplyButton(
              title: '수락',
              onPressed: onAccept,
            ),
            SizedBox(
              width: 6.w,
            ),
            _ApplyButton(
              title: '거절',
              onPressed: onReject,
            ),
            SizedBox(
              width: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _ApplyButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48.r))),
      child: Text(
        title,
        style: m_Button_00.copyWith(color: GREY_100),
      ),
    );
  }
}