import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/memo/model/memo_model.dart';
import 'package:pllcare/memo/param/memo_param.dart';
import 'package:pllcare/theme.dart';

import '../../common/model/default_model.dart';
import '../../common/page/param/page_param.dart';
import '../../project/model/project_model.dart';
import '../../project/provider/project_provider.dart';
import '../provider/memo_provider.dart';

class MemoDialogComponent extends ConsumerWidget {
  final int memoId;
  final int projectId;

  const MemoDialogComponent({
    super.key,
    required this.memoId,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(memoProvider(MemoProviderParam(
      type: MemoProviderType.get,
      projectId: projectId,
      memoId: memoId,
    )));
    if (model is LoadingModel) {
      return const CircularProgressIndicator();
    } else if (model is ErrorModel) {
      return const Text('error');
    }
    model as MemoModel;

    return _MemoDetailComponent.fromModel(
      model: model,
      onBookmark: () async {
        final BookmarkMemoParam param = BookmarkMemoParam(projectId: projectId);
        final isComplete = await ref
            .read(memoProvider(MemoProviderParam(
                    type: MemoProviderType.bookmark, memoId: memoId))
                .notifier)
            .bookmarkMemo(param: param);
        if (isComplete is CompletedModel) {
          if (ref.read(memoDropdownProvider) == '즐겨찾기') {
            final param = MemoProviderParam(
                type: MemoProviderType.bookmarkList, projectId: projectId);
            ref.read(memoProvider(param).notifier).getBookmarkMemoList(
                param: PageParams(page: 1, size: 4, direction: 'DESC'));
          }
        } else {}
      },
      projectId: projectId,
    );
  }
}

class _MemoDetailComponent extends ConsumerWidget {
  final int projectId;
  final int memoId;
  final String writeDate;
  final String title;
  final String author;
  final String content;
  final bool deletable;
  final bool editable;
  final bool bookmarked;
  final VoidCallback onBookmark;

  const _MemoDetailComponent({
    super.key,
    required this.memoId,
    required this.writeDate,
    required this.title,
    required this.author,
    required this.content,
    required this.deletable,
    required this.editable,
    required this.bookmarked,
    required this.onBookmark,
    required this.projectId,
  });

  factory _MemoDetailComponent.fromModel(
      {required MemoModel model,
      required VoidCallback onBookmark,
      required int projectId}) {
    final format = DateFormat('yyyy.MM.dd HH:mm');
    late final String writeDate;
    if (model.createdDate == model.modifiedDate) {
      writeDate = format.format(DateTime.parse(model.createdDate));
    } else {
      writeDate = format.format(DateTime.parse(model.modifiedDate));
    }
    return _MemoDetailComponent(
      memoId: model.memoId,
      writeDate: writeDate,
      title: model.title,
      author: model.author,
      content: model.content,
      deletable: model.deletable,
      editable: model.editable,
      bookmarked: model.bookmarked,
      onBookmark: onBookmark,
      projectId: projectId,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCompleted = true;
    final state = ref.watch(projectFamilyProvider(ProjectProviderParam(
        type: ProjectProviderType.isCompleted, projectId: projectId)));
    if (state is ProjectIsCompleted) {
      isCompleted = state.completed;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 5 * 3,
      width: MediaQuery.of(context).size.width / 3 * 2,
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Heading_04.copyWith(color: GREY_500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isCompleted)
                      IconButton(
                        onPressed: onBookmark,
                        icon: Icon(
                          bookmarked ? Icons.bookmark : Icons.bookmark_border,
                        ),
                      )
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Text(
                      author,
                      style: m_Body_01.copyWith(color: GREY_500),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      writeDate,
                      style: m_Body_01.copyWith(color: GREY_500),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2.h,
                  color: GREY_400,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Html(
                    data: content,
                  ),
                )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (editable && !isCompleted)
                TextButton(onPressed: () {}, child: Text('수정하기')),
              if (deletable && !isCompleted) SizedBox(width: 12.w),
              if (deletable && !isCompleted)
                TextButton(
                    onPressed: () async {
                      await _memoDelete(ref, context);
                    },
                    child: Text('삭제하기')),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _memoDelete(WidgetRef ref, BuildContext context) async {
    final param = DeleteMemoParam(projectId: projectId);
    final completeModel = await ref
        .read(memoProvider(MemoProviderParam(
                type: MemoProviderType.delete, memoId: memoId))
            .notifier)
        .deleteMemo(param: param);
    final dropValue = ref.read(memoDropdownProvider);
    if (completeModel is CompletedModel) {
      if (dropValue == '전체') {
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
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
