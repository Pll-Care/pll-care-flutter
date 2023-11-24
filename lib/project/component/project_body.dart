import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/dio/param/param.dart';
import 'package:pllcare/project/component/project_form.dart';
import 'package:pllcare/project/component/project_list_card.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/test_screen.dart';
import 'package:pllcare/theme.dart';
import 'package:collection/collection.dart';

final isSelectAllProvider = StateProvider.autoDispose<bool>((ref) => true);

class ProjectBody extends ConsumerWidget {
  late String? title;
  late String? content;
  final formKey = GlobalKey<FormState>();

  ProjectBody({super.key});

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
                    ref: ref,
                    state: [ProjectListType.ONGOING, ProjectListType.COMPLETE]);
              },
              onTapOnGoing: () {
                _onTapFetch(ref: ref, state: [ProjectListType.ONGOING]);
              },
              onCreate: () {
                _projectCreateForm(context);
              },
            ),
          ),
          const _ProjectList(),
        ],
      ),
    );
  }

  void _onRefresh(WidgetRef ref) {
    ref.read(projectListProvider.notifier).getList(
        params: ProjectParams(
            page: 0,
            size: 5,
            direction: 'ASC',
            state: [ProjectListType.COMPLETE, ProjectListType.ONGOING]));
    ref.read(isSelectAllProvider.notifier).update((state) => true);
  }

  void _projectCreateForm(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ProjectForm(
                    onSavedTitle: (String? newValue) {
                      if (formKey.currentState!.validate()) {
                        title = newValue;
                      }
                    },
                    onSavedContent: (String? newValue) {
                      if (formKey.currentState!.validate()) {
                        content = newValue;
                      }
                    },
                    onSaved: () {
                      formKey.currentState!.save();
                      if (formKey.currentState!.validate()) {
                        context.pop();
                      }
                    },
                  )),
            ),
          );
        });
  }

  void _onTapFetch(
      {required WidgetRef ref, required List<ProjectListType> state}) {
    ref.read(projectListProvider.notifier).getList(
        params:
            ProjectParams(page: 0, size: 5, direction: 'ASC', state: state));
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
    final isSelectAll = ref.watch(isSelectAllProvider);
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
        padding: EdgeInsets.symmetric(horizontal: 12.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '참여 프로젝트',
                  style: m_Heading_01.copyWith(color: GREY_100),
                ),
                SizedBox(
                  width: 8.w,
                ),
                TextButton(
                  onPressed: onCreate,
                  style: buttonStyle.copyWith(
                    minimumSize:
                        MaterialStateProperty.all<Size?>(Size(90.w, 5.h)),
                    maximumSize:
                        MaterialStateProperty.all<Size?>(Size(140.w, 30.h)),
                  ),
                  child: Text(
                    '새 프로젝트 생성',
                    style: m_Button_01.copyWith(color: GREY_500),
                  ),
                )
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: onTapAll,
                  style: buttonStyle.copyWith(
                    minimumSize:
                        MaterialStateProperty.all<Size?>(Size(32.w, 5.h)),
                    maximumSize:
                        MaterialStateProperty.all<Size?>(Size(45.w, 30.h)),
                    backgroundColor: isSelectAll
                        ? MaterialStateProperty.all<Color?>(GREEN_400)
                        : null,
                  ),
                  child: Text(
                    '전체',
                    style: m_Button_01.copyWith(
                        color: isSelectAll ? GREY_100 : GREY_500),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                TextButton(
                  onPressed: onTapOnGoing,
                  style: buttonStyle.copyWith(
                    minimumSize:
                        MaterialStateProperty.all<Size?>(Size(40.w, 5.h)),
                    maximumSize:
                        MaterialStateProperty.all<Size?>(Size(65.w, 30.h)),
                    backgroundColor: isSelectAll
                        ? null
                        : MaterialStateProperty.all<Color?>(GREEN_400),
                  ),
                  child: Text(
                    '진행 중',
                    style: m_Button_01.copyWith(
                        color: isSelectAll ? GREY_500 : GREY_100),
                  ),
                )
              ],
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
    if (modelList is ProjectList) {
      pModelList = modelList as ProjectList;
    } else if (modelList is ErrorModel) {}

    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      sliver: modelList is! LoadingModel
          ? SliverToBoxAdapter(
              child: Column(children: [
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
                // page 수
                _BottomPageCount(
                  pModelList: pModelList,
                ),
              ]),
            )
          : SliverToBoxAdapter(
              child: Container(
                child: Text("로딩"),
              ),
            ),
    );
  }
}

class _BottomPageCount extends StatelessWidget {
  final ProjectList pModelList;

  const _BottomPageCount({super.key, required this.pModelList});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i < pModelList.totalPages! + 1; i++)
              Text(
                i.toString(),
                style: m_Heading_02.copyWith(color: GREY_500),
              )
          ],
        ),
      ),
    );
  }
}
