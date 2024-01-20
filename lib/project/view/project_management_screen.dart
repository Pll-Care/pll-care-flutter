import 'package:flutter/material.dart';
import 'package:pllcare/memo/component/memo_body.dart';
import 'package:pllcare/project/component/project_header.dart';
import 'package:pllcare/schedule/component/schedule_overview_body.dart';

import '../../common/component/default_appbar.dart';
import '../../evaluation/component/evaluation_body.dart';
import '../../management/component/management_body.dart';
import '../../schedule/component/schedule_body.dart';
import '../component/project_management_body.dart';

class ProjectManagementScreen extends StatefulWidget {
  final int projectId;

  static String get routeName => 'projectManagement';

  const ProjectManagementScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectManagementScreen> createState() => _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<ProjectManagementScreen>
    with TickerProviderStateMixin {
  late final TabController  tabController= TabController(length: 6, vsync: this);
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
           ProjectHeader(tabController: tabController,),
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: [
          ScheduleOverViewBody(projectId: widget.projectId),
          MemoBody(projectId: widget.projectId),
          ScheduleBody(projectId: widget.projectId),
          EvaluationBody(projectId: widget.projectId),
          ManagementBody(projectId: widget.projectId),
          ProjectManagementBody(projectId: widget.projectId),
        ],
      ),
    );
  }
}
