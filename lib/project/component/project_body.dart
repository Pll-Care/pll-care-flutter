import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/project/component/skeleton/project_list_card_skeleton.dart';
import 'package:pllcare/project/param/param.dart';
import 'package:pllcare/project/component/project_list_card.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';

import '../../common/page/component/bottom_page_count.dart';
import '../../util/custom_form_bottom_sheet.dart';

final isSelectAllProvider = StateProvider.autoDispose<bool>((ref) => true);

class ProjectBody extends ConsumerWidget {
  const ProjectBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        _onRefresh(ref);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProjectListNav(
              onTapAll: () {
                _onTapFetch(
                    ref: ref, state: [StateType.ONGOING, StateType.COMPLETE]);
              },
              onTapOnGoing: () {
                _onTapFetch(ref: ref, state: [StateType.ONGOING]);
              },
              onCreate: () {
                _projectCreateForm(context: context, ref: ref);
              },
            ),
          ),
          const _ProjectList(),
        ],
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    ref.read(projectListProvider.notifier).getList(
        params: ProjectParams(
            page: 1,
            size: 5,
            direction: 'DESC',
            state: [StateType.COMPLETE, StateType.ONGOING]));
    ref.read(isSelectAllProvider.notifier).update((state) => true);
  }

  void _projectCreateForm({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    CustomFormBottomSheet.showCustomFormBottomSheet(
        context: context, ref: ref, isCreate: true);
  }

  void _onTapFetch({required WidgetRef ref, required List<StateType> state}) {
    ref.read(projectListProvider.notifier).getList(
        params:
            ProjectParams(page: 1, size: 5, direction: 'DESC', state: state));
    ref.read(isSelectAllProvider.notifier).update((isSelectAll) {
      return state.length == 1 ? false : true;
    });
  }
}

class ProjectListNav extends ConsumerWidget {
  final VoidCallback onCreate;
  final VoidCallback onTapAll;
  final VoidCallback onTapOnGoing;

  const ProjectListNav(
      {super.key,
      required this.onTapAll,
      required this.onTapOnGoing,
      required this.onCreate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      backgroundColor: GREY_100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45.r),
      ),
    );

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
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '참여 프로젝트',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: GREY_100, fontSize: 18.sp),
                ),
                SizedBox(
                  width: 8.w,
                ),
                TextButton(
                  onPressed: onCreate,
                  style: buttonStyle.copyWith(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h)),
                    minimumSize:
                        MaterialStateProperty.all<Size?>(Size(90.w, 48.h)),
                    maximumSize:
                        MaterialStateProperty.all<Size?>(Size(140.w, 48.h)),
                  ),
                  child: Text(
                    '새 프로젝트 생성',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: GREY_500),
                  ),
                )
              ],
            ),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final isSelectAll = ref.watch(isSelectAllProvider);
                return Row(
                  children: [
                    TextButton(
                      onPressed: onTapAll,
                      style: buttonStyle.copyWith(
                        minimumSize:
                            MaterialStateProperty.all<Size?>(Size(48.w, 48.h)),
                        maximumSize:
                            MaterialStateProperty.all<Size?>(Size(120.w, 48.h)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h)),
                        backgroundColor: isSelectAll
                            ? MaterialStateProperty.all<Color?>(GREEN_400)
                            : null,
                      ),
                      child: Text(
                        '전체',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: isSelectAll ? GREY_100 : GREY_500),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    TextButton(
                      onPressed: onTapOnGoing,
                      style: buttonStyle.copyWith(
                        minimumSize:
                            MaterialStateProperty.all<Size?>(Size(48.w, 48.h)),
                        maximumSize:
                            MaterialStateProperty.all<Size?>(Size(120.w, 48.h)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h)),
                        backgroundColor: isSelectAll
                            ? null
                            : MaterialStateProperty.all<Color?>(GREEN_400),
                      ),
                      child: Text(
                        '진행 중',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: isSelectAll ? GREY_500 : GREY_100),
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _ProjectList extends ConsumerWidget {
  const _ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ProjectList pModelList;

    final modelList = ref.watch(projectListProvider);
    log("projectList build!");
    if (modelList is ProjectList) {
      pModelList = modelList as ProjectList;
    } else if (modelList is ErrorModel) {}

    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      sliver: modelList is! LoadingModel
          ? SliverMainAxisGroup(slivers: [
              if(pModelList.data!.isNotEmpty)
                SliverList.separated(
                    itemBuilder: (context, index) {
                      return ProjectListCard.fromModel(
                          model: pModelList.data![index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 18.h,
                      );
                    },
                    itemCount: pModelList.data!.length),
              if (pModelList.data!.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      '참여한 프로젝트가 없습니다.',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            color: GREEN_400,
                          ),
                    ),
                  ),
                ),
              // page 수
              BottomPageCount<ProjectListModel>(
                pModelList: pModelList,
                onTapPage: (int page) {
                  _onTapPage(ref, page);
                },
                onPageStart: () => _onTapPage(ref, 1),
                onPageLast: () => _onTapPage(ref, pModelList.totalPages!),
              ),
            ])
          : const SliverToBoxAdapter(
              child: CustomSkeleton(skeleton: ProjectListCardSkeleton()),
            ),
    );
  }

  void _onTapPage(WidgetRef ref, int page) {
    log("page = $page");
    final List<StateType> state = ref.read(isSelectAllProvider)
        ? [StateType.COMPLETE, StateType.ONGOING]
        : [StateType.ONGOING];
    ref.read(projectListProvider.notifier).getList(
        params: ProjectParams(
            page: page, size: 5, direction: 'DESC', state: state));
  }
}
