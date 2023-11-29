import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
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
}

class MemoProviderParam extends Equatable {
  final int? projectId;
  final int? memoId;
  final MemoProviderType type;

  const MemoProviderParam({
    this.projectId,
    required this.memoId,
    required this.type,
  });

  @override
  List<Object?> get props => [projectId, memoId, type];
}

final memoProvider = StateNotifierProvider.family<MemoStateNotifier, BaseModel,
    MemoProviderParam>((ref, param) {
  final repository = ref.watch(memoRepositoryProvider);
  return MemoStateNotifier(repository: repository, param: param);
});

class MemoStateNotifier extends StateNotifier<BaseModel> {
  final MemoRepository repository;
  final MemoProviderParam param;

  MemoStateNotifier({required this.repository, required this.param})
      : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case MemoProviderType.get:
        getMemo();
        break;
      case MemoProviderType.getList:
        getMemoList(param: PageParams(page: 1, size: 4, direction: 'ASC'));
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
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> updateMemo({required MemoParam param}) async {
    state = LoadingModel();
    repository
        .updateMemo(memoId: this.param.memoId!, param: param)
        .then((value) {
      logger.i('memo update!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> deleteMemo({required DeleteMemoParam param}) async {
    state = LoadingModel();
    repository
        .deleteMemo(memoId: this.param.memoId!, param: param)
        .then((value) {
      logger.i('memo delete!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> createMemo({required MemoParam param}) async {
    state = LoadingModel();
    repository.createMemo(param: param).then((value) {
      logger.i('memo create!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> bookmarkMemo({required BookmarkMemoParam param}) async {
    state = LoadingModel();
    repository
        .bookmarkMemo(param: param, memoId: this.param.memoId!)
        .then((value) {
      logger.i('memo bookmark!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> getMemoList({required PageParams param}) async {
    state = LoadingModel();
    repository
        .getMemoList(param: param, projectId: this.param.projectId!)
        .then((value) {
      logger.i('memo list!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> getBookmarkMemoList({required PageParams param}) async {
    state = LoadingModel();
    repository
        .getBookmarkMemoList(param: param, projectId: this.param.projectId!)
        .then((value) {
      logger.i('memo bookmark list!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
