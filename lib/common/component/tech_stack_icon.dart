import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme.dart';

class TechStackIcon extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double radius;

  const TechStackIcon({
    super.key,
    required this.name,
    required this.imageUrl,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: name,
      textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_100),
      showDuration: const Duration(seconds: 1),
      triggerMode: TooltipTriggerMode.longPress,
      child: CircleAvatar(
        maxRadius: radius.r,
        backgroundColor: Colors.transparent,
        child: imageUrl.endsWith('.svg')
            ? SvgPicture.network(imageUrl)
            : Image.network(imageUrl, scale: 10),
      ),
    );
  }
}
