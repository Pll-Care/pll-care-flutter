import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/management/model/leader_model.dart';
import 'package:pllcare/memo/component/memo_body.dart';
import 'package:pllcare/project/component/project_header.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/schedule/component/schedule_overview_body.dart';

import '../../common/component/default_appbar.dart';
import '../../evaluation/component/evaluation_body.dart';
import '../../management/component/management_body.dart';
import '../../schedule/component/schedule_body.dart';
import '../component/project_management_body.dart';

class ProjectManagementScreen extends ConsumerStatefulWidget {
  final int projectId;

  static String get routeName => 'projectManagement';

  const ProjectManagementScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<ProjectManagementScreen> createState() =>
      _ProjectManagementScreenState();
}

class _ProjectManagementScreenState
    extends ConsumerState<ProjectManagementScreen>
    with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 5, vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  //todo tabController 개수 설정
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(projectLeaderProvider(projectId: widget.projectId));

    ref.listen(projectLeaderProvider(projectId: widget.projectId), (previous, next) {
      if(previous != next){
        if(next is LeaderModel && next.leader){
          // tabController.dispose();
          tabController = TabController(length: 6, vsync: this);
        }
      }
    });



    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
          ProjectHeader(
            tabController: tabController,
            projectId: widget.projectId,
          ),
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
          if(model is LeaderModel && model.leader)
          ProjectManagementBody(projectId: widget.projectId),
        ],
      ),
    );
  }
}
