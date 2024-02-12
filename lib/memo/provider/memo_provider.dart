import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/memo/model/memo_model.dart';
import 'package:pllcare/memo/repository/memo_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/page/param/page_param.dart';
import '../param/memo_param.dart';

enum MemoProviderType {
  get,
  getList,
  create,
  update,
  delete,
  bookmark,
  bookmarkList,
}

class MemoProviderParam extends Equatable {
  final int? projectId;
  final int? memoId;
  final MemoProviderType type;

  const MemoProviderParam({
    this.projectId,
    this.memoId,
    required this.type,
  });

  @override
  List<Object?> get props => [projectId, memoId, type];
}

final memoDropdownProvider = StateProvider.autoDispose((ref) => '전체');

final memoProvider = StateNotifierProvider.family<MemoStateNotifier,
    BaseModel,
    MemoProviderParam>((ref, param) {
  final repository = ref.watch(memoRepositoryProvider);
  return MemoStateNotifier(repository: repository, param: param, ref: ref);
});

class MemoStateNotifier extends StateNotifier<BaseModel> {
  final MemoRepository repository;
  final MemoProviderParam param;
  final StateNotifierProviderRef ref;

  MemoStateNotifier(
      {required this.repository, required this.param, required this.ref})
      : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case MemoProviderType.get:
        getMemo();
        break;
      case MemoProviderType.getList:
        getMemoList(param: defaultPageParam);
        break;
      case MemoProviderType.bookmarkList:
        getBookmarkMemoList(
            param: defaultPageParam);
        break;
      default:
        break;
    }
  }

  Future<void> getMemo() async {
    state = LoadingModel();
    repository
        .getMemo(memoId: param.memoId!, projectId: param.projectId!)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<BaseModel> updateMemo({required MemoParam param}) async {
    state = LoadingModel();
    return await repository
        .updateMemo(memoId: this.param.memoId!, param: param)
        .then((value) {
      logger.i('memo update!');
      ref.read(memoProvider(MemoProviderParam(type: MemoProviderType.get,
          memoId: this.param.memoId!,
          projectId: this.param.projectId)).notifier).getMemo();
      state = CompletedModel();
      return state;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return state;
    });
  }

  Future<BaseModel> deleteMemo({required DeleteMemoParam param}) async {
    state = LoadingModel();
    return await repository
        .deleteMemo(memoId: this.param.memoId!, param: param)
        .then((value) {
      logger.i('memo delete!');
      state = CompletedModel();
      return state;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return state;
    });
  }

  Future<BaseModel> createMemo({required MemoParam param}) async {
    state = LoadingModel();
    return await repository.createMemo(param: param).then((value) {
      logger.i('memo create!');
      state = CompletedModel();
      final pageParam = defaultPageParam;
      ref
          .read(memoProvider(MemoProviderParam(
          type: MemoProviderType.getList, projectId: param.projectId))
          .notifier)
          .getMemoList(param: pageParam);
      return state;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return state;
    });
  }

  Future<BaseModel> bookmarkMemo({required BookmarkMemoParam param}) async {
    ref
        .read(memoProvider(MemoProviderParam(
        type: MemoProviderType.get,
        memoId: this.param.memoId!,
        projectId: param.projectId))
        .notifier)
        ._updateBookmark();
    state = LoadingModel();
    return await repository
        .bookmarkMemo(param: param, memoId: this.param.memoId!)
        .then((value) {
      logger.i('memo bookmark!');
      state = CompletedModel();
      return state;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return state;
    });
  }

  Future<void> getMemoList({required PageParams param}) async {
    state = LoadingModel();
    repository
        .getMemoList(param: param, projectId: this.param.projectId!)
        .then((value) {
      state = value;
      logger.i('memo list!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getBookmarkMemoList({required PageParams param}) async {
    state = LoadingModel();
    repository
        .getBookmarkMemoList(param: param, projectId: this.param.projectId!)
        .then((value) {
      state = value;
      logger.i('memo bookmark list!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }


  // optimistic response
  void _updateBookmark() {
    final model = state as MemoModel;
    state = model.copyWith(bookmarked: !model.bookmarked);
  }
}
