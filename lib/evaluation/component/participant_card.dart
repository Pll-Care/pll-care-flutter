import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

import '../model/midterm_model.dart';
import '../model/participant_model.dart';

class ParticipantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final List<BadgeModel> badges;
  final int? finalEvalId;
  final bool me;
  final bool isCompleted;

  const ParticipantCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.badges,
    required this.finalEvalId,
    required this.me,
    required this.isCompleted,
  });

  factory ParticipantCard.fromModel(
      {required ParticipantModel model, required bool isCompleted}) {
    return ParticipantCard(
      imageUrl: model.imageUrl,
      name: model.name,
      badges: model.badgeDtos,
      finalEvalId: model.finalEvalId,
      me: model.me,
      isCompleted: isCompleted,
    );
  }

  @override
  Widget build(BuildContext context) {

    final showEvalButtonStyle = TextButton.styleFrom(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ));

    final showEvalTextStyle = m_Button_01;

    final createEvalButtonStyle = TextButton.styleFrom(
      backgroundColor: GREY_100,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: GREEN_200, width: 1)),
    );
    final createEvalTextStyle = m_Button_01.copyWith(color: GREEN_200);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        height: 80.h,
        width: 340.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: GREY_100,
          boxShadow: const [
            BoxShadow(
                spreadRadius: 5,
                blurRadius: 20,
                color: Color.fromRGBO(0, 0, 0, 0.07))
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 28.w),
              child: CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    name,
                    style: Heading_07.copyWith(color: GREY_500),
                  ),
                  Row(
                    children: [
                      ...badges.map((e) => getBadgeIcon(badge: e)).toList(),
                    ],
                  )
                ],
              ),
            ),
            if (!me && isCompleted)
              TextButton(
                onPressed: () {},
                style: finalEvalId != null
                    ? showEvalButtonStyle
                    : createEvalButtonStyle,
                child: Text(
                  finalEvalId != null ? "최종평가 보기" : "최종평가 하기",
                  style: finalEvalId != null
                      ? showEvalTextStyle
                      : createEvalTextStyle,
                ),
              ),
            SizedBox(
              width: 15.w,
            )
          ],
        ),
      ),
    );
  }
  // Icons.local_fire_department
  // Icons.lightbulb
  // Icons.people
  // Icons.handshake
  Widget getBadgeIcon({required BadgeModel badge}) {
    final IconData icon;
    switch (badge.evaluationBadge){
      case BadgeType.PASSIONATE:
        icon = Icons.local_fire_department;
        break;
      case BadgeType.BANK:
        icon = Icons.lightbulb;

        break;
      case BadgeType.LEADER:
        icon = Icons.people;

        break;
      case BadgeType.SUPPORTER:
        icon = Icons.handshake;

        break;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Container(
            width: 30.w,
            height: 30.h,
            child: Icon(
              icon,
              size: 20,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: GREEN_200)),
          ),
        ),
        // Text(
        //   ' · 4',
        //   style: m_Body_01.copyWith(color: GREY_500),
        // )
      ],
    );
  }
}
