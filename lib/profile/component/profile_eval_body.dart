import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/profile/component/profile_eval_chart.dart';
import 'package:pllcare/profile/component/skeleton/profile_eval_card_list_skeleton.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/page/component/bottom_page_count.dart';
import '../../evaluation/param/evaluation_param.dart';
import '../model/profile_eval_model.dart';
import '../view/profile_eval_detail_screen.dart';

class ProfileEvalBody extends StatelessWidget {
  final int memberId;

  const ProfileEvalBody({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  '평가 종합 차트',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 20.sp,
                    color: GREEN_500,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14.h)),
              ProfileEvalChart(
                memberId: memberId,
              ),
              SliverToBoxAdapter(child: SizedBox(height: 28.h)),
              SliverToBoxAdapter(
                child: Text(
                  '받은 평가',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 20.sp,
                    color: GREEN_500,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14.h)),
              _ProfileEvalListComponent(
                memberId: memberId,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ProfileEvalListComponent extends ConsumerStatefulWidget {
  final int memberId;

  const _ProfileEvalListComponent({
    super.key,
    required this.memberId,
  });

  @override
  ConsumerState<_ProfileEvalListComponent> createState() =>
      _ProfileEvalListComponentState();
}

class _ProfileEvalListComponentState
    extends ConsumerState<_ProfileEvalListComponent> {
  PageParams param = PageParams(page: 1, size: 4, direction: 'DESC');

  void _onTapPage(WidgetRef ref, int page) {
    log("page = $page");
    setState(() {
      param = PageParams(page: page, size: 4, direction: 'DESC');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(profileEvalListProvider(memberId: widget.memberId, param: param))
        .when(
            data: (model) {
              if (model.data!.isEmpty) {
                return SliverToBoxAdapter(
                  child: Text(
                    '받은 평가가 없습니다.',
                    style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_500),
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  SliverList.separated(
                      itemBuilder: (_, idx) {
                        return ProfileEvalCard.fromModel(
                          model: model.data![idx],
                          onTap: () {
                            onTap(model, idx, context);
                          },
                        );
                      },
                      separatorBuilder: (_, idx) {
                        return SizedBox(height: 10.h);
                      },
                      itemCount: model.data!.length),
                  BottomPageCount(
                    pModelList: model,
                    onTapPage: (int page) {
                      _onTapPage(ref, page);
                    },
                    onPageStart: () => _onTapPage(ref, 1),
                    onPageLast: () => _onTapPage(ref, model.totalPages!),
                  ),
                ],
              );
            },
            error: (_, __) {
              return const SliverToBoxAdapter(child: Text('error'));
            },
            loading: () => const SliverToBoxAdapter(
                child:
                    CustomSkeleton(skeleton: ProfileEvalCardListSkeleton())));
  }

  void onTap(ProfileEvalList model, int idx, BuildContext context) {
    final Map<String, String> pathParameters = {
      'projectId': model.data![idx].projectId.toString(),
      'memberId': widget.memberId.toString(),
    };
    final String projectName = model.data![idx].title ?? '';
    context.pushNamed(
      ProfileEvalDetailScreen.routeName,
      pathParameters: pathParameters,
      extra: projectName,
    );
  }
}

class ProfileEvalCard extends StatelessWidget {
  final int projectId;
  final String imageUrl;
  final String title;
  final ScoreModel score;
  final VoidCallback onTap;

  const ProfileEvalCard(
      {super.key,
      required this.projectId,
      required this.imageUrl,
      required this.title,
      required this.score,
      required this.onTap});

  factory ProfileEvalCard.fromModel(
      {required ProfileEvalListModel model, required VoidCallback onTap}) {
    return ProfileEvalCard(
      projectId: model.projectId,
      imageUrl: model.imageUrl ?? '',
      title: model.title ?? '',
      score: model.score,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: GREEN_200,
            width: 2.w,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/main/main1.png')
                          as ImageProvider,
                  radius: 15.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '성실도',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREY_500),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: GREEN_200,
                                )),
                            padding: EdgeInsets.all(4.r),
                            child: Text(
                              score.sincerity.toString(),
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREEN_200),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '업무 수행 능력',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREY_500),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: GREEN_200,
                              ),
                            ),
                            padding: EdgeInsets.all(4.r),
                            child: Text(
                              score.jobPerformance.toString(),
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREEN_200),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '시간 엄수',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREY_500),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: GREEN_200,
                                )),
                            padding: EdgeInsets.all(4.r),
                            child: Text(
                              score.punctuality.toString(),
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREEN_200),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '의사 소통',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREY_500),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: GREEN_200,
                              ),
                            ),
                            padding: EdgeInsets.all(4.r),
                            child: Text(
                              score.communication.toString(),
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREEN_200),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
