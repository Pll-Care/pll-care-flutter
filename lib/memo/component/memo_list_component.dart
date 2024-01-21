import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/memo/component/memo_dialog_component.dart';
import 'package:pllcare/memo/component/memo_form.dart';
import 'package:pllcare/memo/model/memo_model.dart';
import 'package:pllcare/memo/param/memo_param.dart';
import 'package:pllcare/memo/provider/memo_provider.dart';
import 'package:pllcare/memo/provider/widget/memo_form_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/custom_dialog.dart';

import '../../common/component/drop_down_button.dart';
import '../../common/model/default_model.dart';
import '../../common/page/component/bottom_page_count.dart';
import '../../common/page/param/page_param.dart';
import '../../project/model/project_model.dart';
import '../../project/provider/project_provider.dart';

class MemoListComponent extends ConsumerWidget {
  final int projectId;

  const MemoListComponent({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropValue = ref.watch(memoDropdownProvider);
    ref.listen(memoDropdownProvider, (previous, next) {
      if (next == '전체') {
        final param = MemoProviderParam(
            type: MemoProviderType.getList, projectId: projectId);
        ref.read(memoProvider(param).notifier).getMemoList(
            param: PageParams(page: 1, size: 4, direction: 'DESC'));
      } else {
        final param = MemoProviderParam(
            type: MemoProviderType.bookmarkList, projectId: projectId);
        ref.read(memoProvider(param).notifier).getBookmarkMemoList(
            param: PageParams(page: 1, size: 4, direction: 'DESC'));
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dropValue,
              style: m_Heading_02.copyWith(color: GREY_500),
            ),
            const Spacer(),
            CustomDropDownButton(
              items: const ['전체', '즐겨찾기'],
              onChanged: (value) {
                ref
                    .read(memoDropdownProvider.notifier)
                    .update((state) => value!);
              },
            ),
            SizedBox(width: 10.w),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final isCompleted = ref.watch(projectFamilyProvider(
                    ProjectProviderParam(
                        type: ProjectProviderType.isCompleted,
                        projectId: projectId)));

                if (isCompleted is ProjectIsCompleted &&
                    !isCompleted.completed) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: TextButton(
                        onPressed: () {
                          CustomDialog.showCustomDialog(
                            context: context,
                            backgroundColor: GREY_100,
                            content: const MemoForm(),
                            actions: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        final form = ref.read(pMemoFormProvider);
                                        if (memoFormKey.currentState!
                                            .validate()) {
                                          final param = MemoParam(
                                              projectId: projectId,
                                              title: form.title,
                                              content: form.content);
                                          final model = await ref
                                              .read(memoProvider(
                                                      const MemoProviderParam(
                                                          type: MemoProviderType
                                                              .create))
                                                  .notifier)
                                              .createMemo(param: param);
                                          if (model is CompletedModel) {
                                            // ref.read(memoProvider(
                                            //     MemoProviderParam(
                                            //         type: MemoProviderType
                                            //             .getList,
                                            //         projectId: projectId)));
                                            if (context.mounted) {
                                              context.pop();
                                            }
                                          }
                                        }
                                      },
                                      child: const Text('작성완료'),
                                    ),
                                    SizedBox(width: 12.w),
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: const Text('취소'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        child: const Text('작성하기')),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            bool isBookmarkList = dropValue == '즐겨찾기';
            final model = isBookmarkList
                ? ref.watch(memoProvider(MemoProviderParam(
                    type: MemoProviderType.bookmarkList, projectId: projectId)))
                : ref.watch(memoProvider(MemoProviderParam(
                    type: MemoProviderType.getList, projectId: projectId)));
            if (model is LoadingModel) {
              return const CircularProgressIndicator();
            } else if (model is ErrorModel) {
              return const Text("error");
            }
            final pModelList = (model as PaginationModel<MemoListModel>);
            final modelList = pModelList.data!;
            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, idx) {
                          return _MemoListCard.fromModel(
                            model: modelList[idx],
                            onTap: () {
                              showMemoDetail(context, modelList, idx);
                            },
                          );
                        },
                        separatorBuilder: (_, idx) => SizedBox(height: 10.h),
                        itemCount: modelList.length),
                  ),
                  BottomPageCount<MemoListModel>(
                    pModelList: pModelList,
                    onTapPage: (int page) {
                      _onTapPage(ref, page, projectId, isBookmarkList);
                    },
                    isSliver: false,
                    onPageStart: () =>
                        _onTapPage(ref, 1, projectId, isBookmarkList),
                    onPageLast: () => _onTapPage(
                        ref, pModelList.totalPages!, projectId, isBookmarkList),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void showMemoDetail(
      BuildContext context, List<MemoListModel> modelList, int idx) {
    CustomDialog.showCustomDialog(
        context: context,
        backgroundColor: GREY_100,
        content: MemoDialogComponent(
          memoId: modelList[idx].memoId,
          projectId: projectId,
        ),
       );
  }

  void _onTapPage(WidgetRef ref, int page, int projectId, bool isBookmarkList) {
    log("page = $page");
    if (isBookmarkList) {
      final param = MemoProviderParam(
          type: MemoProviderType.bookmarkList, projectId: projectId);
      ref.read(memoProvider(param).notifier).getBookmarkMemoList(
          param: PageParams(page: page, size: 4, direction: 'DESC'));
    } else {
      final param = MemoProviderParam(
          type: MemoProviderType.getList, projectId: projectId);
      ref.read(memoProvider(param).notifier).getMemoList(
          param: PageParams(page: page, size: 4, direction: 'DESC'));
    }
  }
}

class _MemoListCard extends ConsumerWidget {
  final int memoId;
  final String title;
  final String createdDate;
  final String author;
  final VoidCallback onTap;

  const _MemoListCard({
    super.key,
    required this.memoId,
    required this.title,
    required this.createdDate,
    required this.author,
    required this.onTap,
  });

  factory _MemoListCard.fromModel(
      {required MemoListModel model, required VoidCallback onTap}) {
    final format = DateFormat('yyyy.MM.dd');
    final createdDate = format.format(DateTime.parse(model.createdDate));

    return _MemoListCard(
      memoId: model.memoId,
      title: model.title,
      createdDate: createdDate,
      author: model.author,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: GREY_100,
            border: Border.all(color: GREEN_200, width: 2.w)),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              createdDate,
              style: m_Body_02.copyWith(color: GREY_500),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: m_Heading_01.copyWith(color: GREY_500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Text(
              author,
              style: m_Body_02.copyWith(color: GREY_500),
            ),
          ],
        ),
      ),
    );
  }
}
