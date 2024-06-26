import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/custom_dialog.dart';
import 'package:pllcare/util/custom_form_bottom_sheet.dart';

import '../../common/model/default_model.dart';
import '../../management/model/leader_model.dart';
import '../view/project_list_screen.dart';

enum ManageType {
  DELETE,
  COMPLETE,
  UPDATE,
}

typedef OnTapDialog = void Function(
    {required BuildContext context, required WidgetRef ref});

class ProjectManagementBody extends ConsumerWidget {
  final int projectId;

  const ProjectManagementBody({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complete = ref.watch(projectFamilyProvider(ProjectProviderParam(
      type: ProjectProviderType.isCompleted,
      projectId: projectId,
    )));
    final leader = ref.watch(projectLeaderProvider(projectId: projectId));
    return Stack(children: [
      Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _ManageCard(
            type: ManageType.COMPLETE,
            onTap: onTapComplete,
          ),
          _ManageCard(
            type: ManageType.DELETE,
            onTap: onTapDelete,
          ),
          _ManageCard(
            type: ManageType.UPDATE,
            onTap: onTapUpdate,
          ),
        ]),
      ),
      if (leader is LeaderModel && !leader.leader ||
          complete is ProjectIsCompleted && complete.completed)
        AbsorbPointer(
          child: Align(
            alignment: Alignment.center,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(),
            ),
          ),
        ),
    ]);
  }

  void onTapComplete({required BuildContext context, required WidgetRef ref}) {
    CustomDialog.showCustomDialog(
        context: context,
        backgroundColor: GREEN_200,
        content: Text(
          '정말 완료하시겠습니까?\n완료 후에는 복구가 불가합니다.',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            color: GREY_100,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(projectFamilyProvider(ProjectProviderParam(
                          type: ProjectProviderType.complete,
                          projectId: projectId))
                      .notifier)
                  .completeProject();
              final state = ref.read(projectFamilyProvider(ProjectProviderParam(
                  type: ProjectProviderType.complete, projectId: projectId)));
              if (context.mounted && state is! ErrorModel) {
                context.pop();
                context.goNamed(ProjectListScreen.routeName);
              }
            },
            style: CustomDialog.textButtonStyle,
            child: Text(
              "네",
              style: Theme.of(context)
                    .textTheme
                    .displayLarge!.copyWith(color: GREEN_400),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            style: CustomDialog.textButtonStyle,
            child: Text(
              "아니오",
              style: Theme.of(context)
                    .textTheme
                    .displayLarge!.copyWith(color: GREEN_400),
            ),
          )
        ]);
  }

  void onTapDelete({required BuildContext context, required WidgetRef ref}) {
    CustomDialog.showCustomDialog(
        context: context,
        backgroundColor: GREEN_200,
        content: Text(
          '정말 삭제하시겠습니까?\n삭제 후에는 복구가 불가합니다.',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            color: GREY_100,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(projectFamilyProvider(ProjectProviderParam(
                          type: ProjectProviderType.delete,
                          projectId: projectId))
                      .notifier)
                  .deleteProject();
              final state = ref.read(projectFamilyProvider(ProjectProviderParam(
                  type: ProjectProviderType.delete, projectId: projectId)));
              if (context.mounted && state is! ErrorModel) {
                context.pop();
                context.goNamed(ProjectListScreen.routeName);
              }
            },
            style: CustomDialog.textButtonStyle,
            child: Text(
              "네",
              style: Theme.of(context)
                    .textTheme
                    .displayLarge!.copyWith(color: GREEN_400),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            style: CustomDialog.textButtonStyle,
            child: Text(
              "아니오",
              style: Theme.of(context)
                    .textTheme
                    .displayLarge!.copyWith(color: GREEN_400),
            ),
          )
        ]);
  }

  void onTapUpdate(
      {required BuildContext context, required WidgetRef ref}) async {
    await ref
        .watch(projectFamilyProvider(ProjectProviderParam(
                type: ProjectProviderType.get, projectId: projectId))
            .notifier)
        .getProject();

    final bModel = ref.read(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.get, projectId: projectId)));

    if (bModel is ProjectModel) {
      if (context.mounted) {
        CustomFormBottomSheet.showCustomFormBottomSheet(
            context: context, ref: ref, isCreate: false, projectId: projectId);
      }
    }
  }
}

class _ManageCard extends ConsumerWidget {
  final ManageType type;
  final OnTapDialog onTap;

  const _ManageCard({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = _getTitle(type: type);

    return GestureDetector(
      onTap: () {
        onTap(context: context, ref: ref);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundImage: const AssetImage('assets/main/main1.png'),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_500),
          )
        ],
      ),
    );
  }

  String _getTitle({required ManageType type}) {
    switch (type) {
      case ManageType.DELETE:
        return '프로젝트 삭제';
      case ManageType.COMPLETE:
        return '프로젝트 완료';
      case ManageType.UPDATE:
        return '프로젝트 수정';
    }
  }
}
