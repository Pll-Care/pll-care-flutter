import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomSkeleton extends StatelessWidget {
  final Widget skeleton;
  const CustomSkeleton({super.key, required this.skeleton});

  @override
  Widget build(BuildContext context) {
    int timer = 1000;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      period: Duration(milliseconds: timer),
      child: skeleton,
    );
  }
}
