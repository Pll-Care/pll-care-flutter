
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';
import '../model/team_member_model.dart';

class TeamMemberCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final PositionType position;

  const TeamMemberCard(
      {super.key,
        required this.imageUrl,
        required this.name,
        required this.position});

  factory TeamMemberCard.fromModel({required TeamMemberModel model}) {
    return TeamMemberCard(
        imageUrl: model.imageUrl, name: model.name, position: model.position);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: 110,
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 50.r,
            ),
            Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: m_Heading_01.copyWith(color: GREEN_500),
            ),
            Text(
              position.name,
              overflow: TextOverflow.ellipsis,
              style: m_Heading_01.copyWith(color: GREEN_500),
            ),
          ],
        ),
      ),
    );
  }
}
