import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/common/page/component/bottom_page_count.dart';
import 'package:pllcare/profile/component/profile_post_card.dart';
import 'package:pllcare/profile/component/skeleton/profile_post_card_list_skeleton.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

import '../../auth/model/member_model.dart';
import '../../common/page/param/page_param.dart';
import '../../post/view/post_screen.dart';
import '../model/profile_apply_model.dart';
import '../model/profile_post_model.dart';

class ProfileApplyBody extends StatelessWidget {
  final int memberId;

  const ProfileApplyBody({super.key, required this.memberId});

  void _onTap(BuildContext context, int postId) {
    Map<String, String> pathParameters = {'postId': postId.toString()};
    context.goNamed(PostDetailScreen.routeName, pathParameters: pathParameters);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _ProfileRecruitComponent(
          onTap: _onTap,
          memberId: memberId,
        ),
        _ProfileApplyComponent(
          onTap: _onTap,
          memberId: memberId,
        ),
      ],
    );
  }
}

class _ProfileRecruitComponent extends StatelessWidget {
  final int memberId;
  final ProfilePostTap onTap;

  const _ProfileRecruitComponent(
      {super.key, required this.onTap, required this.memberId});

  void _onTapPage(WidgetRef ref, int page, int memberId) {
    log("page = $page");
    ref
        .read(profilePostProvider(
                type: ProfileProviderType.apply, memberId: memberId)
            .notifier)
        .getApplyPost(
            param: PageParams(page: page, size: 4, direction: 'DESC'),
            memberId: memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final memberModel = ref.watch(memberProvider);
      if (memberModel == null ||
          memberModel is MemberModel && memberModel.memberId != memberId) {
        return SliverToBoxAdapter(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(),
          ),
        );
      }
      final member = memberModel as MemberModel;

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        sliver: SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
                child: Text(
              '내가 모집하는 프로젝트',
              style: m_Heading_02.copyWith(
                color: GREEN_500,
              ),
            )),
            SliverToBoxAdapter(child: SizedBox(height: 14.h)),
            Consumer(builder: (_, ref, __) {
              final model = ref.watch(profilePostProvider(
                  type: ProfileProviderType.recruit,
                  memberId: member.memberId));
              if (model is LoadingModel) {
                return const SliverToBoxAdapter(
                  child:
                      CustomSkeleton(skeleton: ProfilePostCardListSkeleton()),
                );
              } else if (model is ErrorModel) {
                return const SliverToBoxAdapter(
                  child: Text('error'),
                );
              }
              final pModelList = model as ProfilePostList;
              return SliverMainAxisGroup(slivers: [
                if (pModelList.data!.isEmpty)
                  SliverToBoxAdapter(
                      child: Center(
                          child: Text(
                    '모집하는 프로젝트가 없습니다.',
                    style: m_Heading_01.copyWith(color: GREEN_500),
                  ))),
                SliverList.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final model = pModelList.data![index];
                    return ProfilePostCard.fromModel(
                      model: model,
                      onTap: (context, postId) => onTap(context, postId),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.h);
                  },
                  itemCount: pModelList.data!.length,
                ),
                BottomPageCount(
                    pModelList: pModelList,
                    onTapPage: (int page) {
                      _onTapPage(ref, page, member.memberId);
                    },
                    onPageStart: () => _onTapPage(ref, 1, member.memberId),
                    onPageLast: () => _onTapPage(
                        ref, pModelList.totalPages!, member.memberId)),
              ]);
            }),
          ],
        ),
      );
    });
  }
}

class _ProfileApplyComponent extends StatelessWidget {
  final int memberId;
  final ProfilePostTap onTap;

  const _ProfileApplyComponent(
      {super.key, required this.onTap, required this.memberId});

  void _onTapPage(WidgetRef ref, int page, int memberId) {
    log("page = $page");
    ref
        .read(profilePostProvider(
                type: ProfileProviderType.apply, memberId: memberId)
            .notifier)
        .getApplyPost(
            param: PageParams(page: page, size: 4, direction: 'DESC'),
            memberId: memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final memberModel = ref.watch(memberProvider);
      if (memberModel == null ||
          memberModel is MemberModel && memberModel.memberId != memberId) {
        return SliverFillRemaining(
          child: Center(
              child: Text(
            '본인만 볼 수 있습니다.',
            style: Heading_05.copyWith(color: GREEN_500),
          )),
        );
      }
      final member = memberModel as MemberModel;
      final model = ref.watch(profilePostProvider(
          type: ProfileProviderType.apply, memberId: member.memberId));

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        sliver: SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
                child: Text(
              '지원한 프로젝트',
              style: m_Heading_02.copyWith(
                color: GREEN_500,
              ),
            )),
            SliverToBoxAdapter(child: SizedBox(height: 14.h)),
            Consumer(builder: (_, ref, __) {
              if (model is LoadingModel) {
                return const SliverToBoxAdapter(
                  child: CustomSkeleton(skeleton: ProfilePostCardListSkeleton()),
                );
              } else if (model is ErrorModel) {
                return const SliverToBoxAdapter(
                  child: Text('error'),
                );
              }

              final pModelList = model as ProfileApplyList;
              return SliverMainAxisGroup(slivers: [
                if (pModelList.data!.isEmpty)
                  SliverToBoxAdapter(
                      child: Center(
                          child: Text(
                    '지원한 프로젝트가 없습니다.',
                    style: m_Heading_01.copyWith(color: GREEN_500),
                  ))),
                SliverList.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final model = pModelList.data![index];
                    return ProfilePostCard.fromModel(
                      model: model,
                      onTap: (context, postId) => onTap(context, postId),
                      isApplyCard: true,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.h);
                  },
                  itemCount: pModelList.data!.length,
                ),
                BottomPageCount(
                    pModelList: pModelList,
                    onTapPage: (int page) {
                      _onTapPage(ref, page, member.memberId);
                    },
                    onPageStart: () => _onTapPage(ref, 1, member.memberId),
                    onPageLast: () => _onTapPage(
                        ref, pModelList.totalPages!, member.memberId)),
              ]);
            }),
          ],
        ),
      );
    });
  }
}
