import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

class ProjectHeader extends StatefulWidget {
  final TabController tabController;

  const ProjectHeader({super.key, required this.tabController});

  @override
  State<ProjectHeader> createState() => _ProjectHeaderState();
}

class _ProjectHeaderState extends State<ProjectHeader>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: TabBarDelegate(tabController: widget.tabController),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TabBarDelegate({required this.tabController});

  Widget projectTab({
    required String title,
    double? width,
  }) {
    return Tab(
      child: SizedBox(
        width: width,
        child: Text(
          title,
          style: m_Heading_03.copyWith(color: GREY_500),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        decoration: BoxDecoration(
            color: GREY_100,
            border: Border.all(color: GREEN_200),
            borderRadius: BorderRadius.circular(40.r)),
        child: TabBar(
          controller: tabController,
          labelPadding: EdgeInsets.zero,
          indicatorColor: Colors.transparent,
          labelColor: GREEN_400,
          unselectedLabelColor: GREY_500,
          onTap: (idx) {
            tabController.animateTo(idx);
          },
          tabs: [
            projectTab(title: '개요'),
            projectTab(title: '회의록'),
            projectTab(title: '팀원'),
            projectTab(title: '일정'),
            projectTab(title: '평가'),
            projectTab(title: '관리'),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48.h;

  @override
  double get minExtent => 48.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
