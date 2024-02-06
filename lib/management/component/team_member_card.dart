import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../model/team_member_model.dart';

class TeamMemberCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final PositionType position;
  final double radius;
  final bool requiredPosition;

  const TeamMemberCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    this.radius = 50, required this.requiredPosition,
  });

  factory TeamMemberCard.fromModel(
      {required TeamMemberModel model, double radius = 50, bool requiredPosition = true,}) {
    return TeamMemberCard(
      imageUrl: model.imageUrl,
      name: model.name,
      position: model.position,
      radius: radius,
      requiredPosition: requiredPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width / 3,
      // height: 150.h,
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: radius.r,
          ),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: m_Heading_01.copyWith(color: GREEN_500),
          ),
          if(requiredPosition)
          Text(
            position.name,
            overflow: TextOverflow.ellipsis,
            style: m_Heading_01.copyWith(color: GREEN_500),
          ),
        ],
      ),
    );
  }
}
