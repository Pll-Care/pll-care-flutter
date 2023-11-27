import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/management/component/team_member_card.dart';
import 'package:pllcare/management/model/team_member_model.dart';
import 'package:pllcare/management/param/management_param.dart';
import 'package:pllcare/management/provider/management_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/model/default_model.dart';
import '../model/apply_model.dart';
import 'apply_card.dart';

class ManagementBody extends StatelessWidget {
  final int projectId;

  const ManagementBody({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
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
                TextButton(
                  onPressed: () {},
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
            final bModel = ref.watch(managementProvider(projectId));
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
        Consumer(
          builder: (_, ref, child) {
            final bModel = ref.watch(applyListProvider(projectId));
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
            final model = bModel as ListModel<ApplyModel>;
            return SliverMainAxisGroup(slivers: [
              SliverList.separated(
                itemBuilder: (_, idx) {
                  return ApplyCard.fromModel(
                    model: model.data[idx],
                    onAccept: () {// todo optimise 최적화 필요
                      onAccept(ref, model, idx);
                    },
                    onReject: () {// todo optimise 최적화 필요
                      onReject(ref, model, idx);
                    },
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
        projectId: projectId,
        param: ApplyParam(id: model.data[idx].applyId));
    await ref.read(managementProvider(projectId).notifier).getMemberList();
    await ref.read(applyListProvider(projectId).notifier).getApplyList();
  }

  void onReject(WidgetRef ref, ListModel<ApplyModel> model, int idx) async {
    await ref.read(applyProvider.notifier).applyReject(
        projectId: projectId,
        param: ApplyParam(id: model.data[idx].applyId));
    await ref.read(applyListProvider(projectId).notifier).getApplyList();
  }
}
