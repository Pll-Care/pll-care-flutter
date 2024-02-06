import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/model/member_model.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/management/component/team_member_card.dart';
import 'package:pllcare/management/model/team_member_model.dart';
import 'package:pllcare/management/param/management_param.dart';
import 'package:pllcare/management/provider/management_provider.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/component/default_flash.dart';
import '../../common/model/default_model.dart';
import '../../dio/error/error_type.dart';
import '../model/apply_model.dart';
import '../model/leader_model.dart';
import '../provider/widget/management_form_provider.dart';
import 'apply_card.dart';

class ManagementBody extends ConsumerStatefulWidget {
  final int projectId;

  const ManagementBody({super.key, required this.projectId});

  @override
  ConsumerState<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends ConsumerState<ManagementBody> {
  @override
  Widget build(BuildContext context) {
    bool isCompleted = true;
    final state = ref.watch(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.isCompleted, projectId: widget.projectId)));
    if (state is ProjectIsCompleted) {
      isCompleted = state.completed;
    }
    final leaderModel =
        ref.watch(projectLeaderProvider(projectId: widget.projectId));

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '팀원 관리',
                  style: m_Heading_02.copyWith(color: GREEN_400),
                ),
                if (!isCompleted &&
                    leaderModel is LeaderModel &&
                    leaderModel.leader)
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          showDragHandle: true,
                          isScrollControlled: true,
                          constraints: BoxConstraints.loose(
                              Size(double.infinity, 750.h)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24.r))),
                          builder: (_) {
                            return TeamMemberUpdateComponent(
                              projectId: widget.projectId,
                            );
                          });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: GREY_100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.r),
                          side: const BorderSide(color: GREEN_200, width: 2)),
                    ),
                    child: Text(
                      '수정',
                      style: m_Body_01.copyWith(color: GREEN_400),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final bModel = ref.watch(managementProvider(widget.projectId));
            if (bModel is LoadingModel) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (bModel is ErrorModel) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text("에러"),
                ),
              );
            }
            final model = bModel as ListModel<TeamMemberModel>;
            return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: model.data.length,
                  (_, idx) {
                    return TeamMemberCard.fromModel(model: model.data[idx]);
                  },
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15.h,
                  mainAxisExtent: 160.h,
                ));
          },
        ),
        if (!isCompleted)
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '지원 현황',
                    style: m_Heading_02.copyWith(color: GREEN_400),
                  ),
                ],
              ),
            ),
          ),
        if (!isCompleted)
          Consumer(
            builder: (_, ref, child) {
              final bModel = ref.watch(applyListProvider(widget.projectId));
              if (bModel is LoadingModel) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (bModel is ErrorModel) {
                // bModel.code == ProjectErrorType.message;
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("에러"),
                  ),
                );
              }
              final model = bModel as ListModel<ApplyModel>;

              return SliverMainAxisGroup(slivers: [
                SliverList.separated(
                  itemBuilder: (_, idx) {
                    return ApplyCard.fromModel(
                      model: model.data[idx],
                      onAccept: () {
                        // todo optimise 최적화 필요
                        onAccept(ref, model, idx);
                      },
                      onReject: () {
                        // todo optimise 최적화 필요
                        onReject(ref, model, idx);
                      },
                      projectId: widget.projectId,
                    );
                  },
                  separatorBuilder: (_, idx) {
                    return SizedBox(
                      height: 8.h,
                    );
                  },
                  itemCount: model.data.length,
                ),
                child!
              ]);
            },
            child: SliverToBoxAdapter(
                child: SizedBox(
              height: 16.h,
            )),
          ),
      ],
    );
  }

  void onAccept(WidgetRef ref, ListModel<ApplyModel> model, int idx) async {
    await ref.read(applyProvider.notifier).applyAccept(
        projectId: widget.projectId,
        param: ApplyParam(id: model.data[idx].applyId));
    // await ref
    //     .read(managementProvider(widget.projectId).notifier)
    //     .getMemberList();
    // await ref.read(applyListProvider(widget.projectId).notifier).getApplyList();
  }

  void onReject(WidgetRef ref, ListModel<ApplyModel> model, int idx) async {
    await ref.read(applyProvider.notifier).applyReject(
        projectId: widget.projectId,
        param: ApplyParam(id: model.data[idx].applyId));
    // await ref.read(applyListProvider(widget.projectId).notifier).getApplyList();
  }
}

class TeamMemberUpdateComponent extends ConsumerWidget {
  final int projectId;

  const TeamMemberUpdateComponent({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(teamMemberTypeProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TeamMemberUpdateButton(
                title: '포지션',
                imageUrl: 'assets/icon/position_change.png',
                type: TeamMemberUpdateType.position,
              ),
              TeamMemberUpdateButton(
                title: '추방',
                imageUrl: 'assets/icon/ban_user.png',
                type: TeamMemberUpdateType.ban,
              ),
              TeamMemberUpdateButton(
                title: '위임',
                imageUrl: 'assets/icon/leader_exchange.png',
                type: TeamMemberUpdateType.leader,
              ),
            ],
          ),
          TeamMemberComponent(
            projectId: projectId,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(
              thickness: 2.h,
              color: GREY_400,
              height: 30.h,
            ),
          ),
          TeamUpdateComponent(
            projectId: projectId,
          ),
        ],
      ),
    );
  }
}

class TeamMemberUpdateButton extends ConsumerWidget {
  final String title;
  final String imageUrl;
  final TeamMemberUpdateType type;

  const TeamMemberUpdateButton({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamType = ref.watch(teamMemberTypeProvider);
    return InkWell(
      onTap: () {
        ref.read(teamMemberTypeProvider.notifier).update((state) => type);
        ref.read(teamMemberProvider.notifier).clear();
      },
      child: Container(
        width: 80.r,
        height: 80.r,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: type == teamType
              ? Border.all(color: GREEN_200, width: 3.w)
              : Border.all(color: GREY_400, width: 3.w),
        ),
        child: Column(
          children: [
            Container(
              width: 25.r,
              height: 25.r,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: m_Body_01.copyWith(
                  color: GREEN_400, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMemberComponent extends ConsumerWidget {
  final int projectId;

  const TeamMemberComponent({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bModel = ref.watch(managementProvider(projectId));
    final model = bModel as ListModel<TeamMemberModel>;
    final type = ref.watch(teamMemberTypeProvider);
    final memberModel = ref.watch(memberProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '팀원 선택',
            style: m_Heading_02.copyWith(color: GREEN_400),
          ),
          SizedBox(height: 12.h),
          Wrap(
            runSpacing: 15.h,
            spacing: 25.w,
            children: [
              ...model.data
                  .where((e) {
                    if (type == TeamMemberUpdateType.position) {
                      return true;
                    }
                    if (memberModel is MemberModel &&
                        e.memberId == memberModel.memberId) {
                      return false;
                    }
                    return true;
                  })
                  .map((e) => InkWell(
                        onTap: () {
                          ref
                              .read(teamMemberProvider.notifier)
                              .update(teamMember: e);
                        },
                        child: TeamMemberCard.fromModel(
                          model: e,
                          radius: 25,
                          requiredPosition: false,
                        ),
                      ))
                  .toList()
            ],
          ),
        ],
      ),
    );
  }
}

class TeamUpdateComponent extends ConsumerWidget {
  final int projectId;

  const TeamUpdateComponent({
    super.key,
    required this.projectId,
  });

  Widget _getUpdateComponent({
    required TeamMemberUpdateType type,
    required TeamMemberUpdateModel model,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    switch (type) {
      case TeamMemberUpdateType.position:
        return Column(
          children: [
            _getPositionWidget(model, ref),
            _getPositionButton(ref, context),
          ],
        );
      case TeamMemberUpdateType.ban:
        return Column(
          children: [
            _getKickOutWidget(model),
            _getKickOutButton(ref, context),
          ],
        );
      case TeamMemberUpdateType.leader:
        return Column(
          children: [
            _getLeaderWidget(model),
            _getLeaderButton(ref, context),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(teamMemberTypeProvider);
    final model = ref.watch(teamMemberProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: _getUpdateComponent(
        type: type,
        model: model,
        ref: ref,
        context: context,
      ),
    );
  }

  Align _getPositionButton(WidgetRef ref, BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final model = ref.read(teamMemberProvider);
          if (model.teamMember == null) {
            return;
          }
          final param = ChangePositionParam(
              id: model.teamMember!.memberId, position: model.position!);
          final result = await ref.read(
              changePositionProvider(projectId: projectId, param: param)
                  .future);
          log(' result type = ${result.runtimeType}');

          if (result is CompletedModel && context.mounted) {
            log('성공');
            context.pop();
          } else if (result is ErrorModel && context.mounted) {
            DefaultFlash.showFlash(
                context: context,
                type: FlashType.fail,
                content: result.message);
          }
        },
        child: const Text('포지션 변경'),
      ),
    );
  }

  Widget _getKickOutWidget(TeamMemberUpdateModel model) {
    if (model.teamMember != null) {
      return SizedBox(
        height: 150.h,
        child: TeamMemberCard.fromModel(
          model: model.teamMember!,
          radius: 50,
          requiredPosition: false,
        ),
      );
    }
    return SizedBox(
      height: 150.h,
      child: Center(
        child: Text(
          '추방할 팀원을\n선택해주세요.',
          style: m_Heading_01,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getKickOutButton(WidgetRef ref, BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final teamMember = ref.read(teamMemberProvider);
          if (teamMember.teamMember == null) {
            return;
          }
          final param = KickOutParam(id: teamMember.teamMember!.memberId);
          final result = await ref
              .read(kickOutProvider(projectId: projectId, param: param).future);
          if (result is CompletedModel && context.mounted) {
            log('성공');
            context.pop();
          } else if (result is ErrorModel && context.mounted) {
            DefaultFlash.showFlash(
                context: context,
                type: FlashType.fail,
                content: result.message);
          }
        },
        child: const Text('추방하기'),
      ),
    );
  }
  Widget _getLeaderButton(WidgetRef ref, BuildContext context){
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final teamMember = ref.read(teamMemberProvider);
          if (teamMember.teamMember == null) {
            return;
          }
          final param = ChangeLeaderParam(id: teamMember.teamMember!.memberId);
          final result = await ref
              .read(changeLeaderProvider(projectId: projectId, param: param).future);
          if (result is CompletedModel && context.mounted) {
            log('성공');
            context.pop();
          } else if (result is ErrorModel && context.mounted) {
            DefaultFlash.showFlash(
                context: context,
                type: FlashType.fail,
                content: result.message);
          }
        },
        child: const Text('위임하기'),
      ),
    );
  }

  Widget _getLeaderWidget(TeamMemberUpdateModel model){
    if (model.teamMember != null) {
      return SizedBox(
        height: 150.h,
        child: TeamMemberCard.fromModel(
          model: model.teamMember!,
          radius: 50,
          requiredPosition: false,
        ),
      );
    }
    return SizedBox(
      height: 150.h,
      child: Center(
        child: Text(
          '리더를 위윔할\n팀원을\n선택해주세요.',
          style: m_Heading_01,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Row _getPositionWidget(TeamMemberUpdateModel model, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (model.teamMember != null)
          SizedBox(
            width: 150.w,
            child: TeamMemberCard.fromModel(
              model: model.teamMember!,
              radius: 25,
            ),
          )
        else
          SizedBox(
            width: 150.w,
            child: Text(
              '포지션을 변경할\n팀원을\n선택해주세요.',
              style: m_Heading_01,
              textAlign: TextAlign.center,
            ),
          ),
        Icon(
          Icons.arrow_right_alt,
          size: 60.r,
        ),
        SizedBox(
          width: 130.w,
          child: Column(
            children: [
              ...PositionType.values
                  .where((e) => e != PositionType.NONE)
                  .map(
                    (e) => ListTile(
                      title: Text(
                        e.name,
                        style: m_Heading_01.copyWith(
                          color: e == model.position ? GREY_100 : GREEN_500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      tileColor: e == model.position
                          ? Colors.teal.withOpacity(.5)
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r)),
                      onTap: () {
                        ref
                            .read(teamMemberProvider.notifier)
                            .update(position: e);
                      },
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
