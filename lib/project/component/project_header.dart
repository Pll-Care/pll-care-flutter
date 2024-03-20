import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/management/model/leader_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';

class ProjectHeader extends StatefulWidget {
  final TabController tabController;
  final int projectId;

  const ProjectHeader(
      {super.key, required this.tabController, required this.projectId});

  @override
  State<ProjectHeader> createState() => _ProjectHeaderState();
}

class _ProjectHeaderState extends State<ProjectHeader>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: TabBarDelegate(
          tabController: widget.tabController, projectId: widget.projectId),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final int projectId;
  final TabController tabController;

  TabBarDelegate({
    required this.tabController,
    required this.projectId,
  });

  Widget projectTab({
    required String title,
    required BuildContext context,
    double? width,
  }) {
    return Tab(
      child: SizedBox(
        width: width,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
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
              labelColor: GREEN_200,
              unselectedLabelColor: GREY_500,
              onTap: (idx) {
                tabController.animateTo(idx);
              },
              tabs: [
                projectTab(title: '오버뷰', context: context),
                projectTab(title: '회의록', context: context),
                projectTab(title: '일정', context: context),
                projectTab(title: '평가', context: context),
                projectTab(title: '팀관리', context: context),
                projectTab(title: '관리', context: context),
              ],
            ),
          ),
        );
      },
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
