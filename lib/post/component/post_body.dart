import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/page/component/bottom_page_count.dart';
import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/post/component/post_card.dart';
import 'package:pllcare/post/model/post_model.dart';
import 'package:pllcare/post/provider/post_provider.dart';

import '../../common/model/default_model.dart';
import '../../project/component/project_body.dart';
import '../../theme.dart';

class PostBody extends ConsumerWidget {
  const PostBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      minimumSize: (Size(40.w, 5.h)),
      maximumSize: Size(65.w, 30.h),
      backgroundColor: GREEN_200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45.r),
      ),
    );
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: RecruitNav(),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 8.w),
          sliver: SliverToBoxAdapter(
            child: TextButton(
              onPressed: () {},
              style: buttonStyle,
              child: Text(
                "작성하기",
                style: m_Button_01.copyWith(color: GREY_100),
              ),
            ),
          ),
        ),
        _RecruitList(),
        // BottomPageCount(pModelList: pModelList, onTapPage: onTapPage),
      ],
    );
  }
}

class RecruitNav extends StatelessWidget {
  const RecruitNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 130.h,
      decoration: BoxDecoration(
        color: GREEN_200,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15.r),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            '모집 중인 프로젝트 목록  Currently Recruiting',
            style: m_Heading_01.copyWith(color: GREY_100),
          ),
        ]),
      ),
    );
  }
}

class _RecruitList extends ConsumerWidget {
  const _RecruitList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final PostList pModelList;
    final modelList = ref.watch(
        postProvider(const PostProviderParam(type: PostProviderType.getList)));

    if (modelList is PostList) {
      pModelList = modelList as PostList;
      log("pModelList.data!.length ${pModelList.data!.length}");
    } else if (modelList is ErrorModel) {}

    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      sliver: modelList is! LoadingModel
          ? SliverMainAxisGroup(slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  childCount: pModelList.data!.length,
                  (_, idx) {
                    return PostCard.fromModel(
                      model: pModelList.data![idx],
                      onTapLike: () {
                        ref
                            .read(
                              postProvider(PostProviderParam(
                                      type: PostProviderType.getList,
                                      postId: pModelList.data![idx].postId))
                                  .notifier,
                            )
                            .likePost();
                      },
                    );
                  },
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 15.w,
                  mainAxisExtent: 300.h,
                ),
              ),
              BottomPageCount<PostListModel>(
                pModelList: pModelList,
                onTapPage: (int page) {
                  _onTapPage(ref, page);
                },
              ),
            ])
          : const SliverToBoxAdapter(
              child: Text("로딩"),
            ),
    );
  }

  void _onTapPage(WidgetRef ref, int page) {
    // todo page 넘어가는지 확인
    log("page = $page");
    ref
        .read(postProvider(
                const PostProviderParam(type: PostProviderType.getList))
            .notifier)
        .getPostList(param: PageParams(page: page, size: 4, direction: 'DESC'));
  }
}