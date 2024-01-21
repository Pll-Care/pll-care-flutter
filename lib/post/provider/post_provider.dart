import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/logger/custom_logger.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/post/model/post_model.dart';

import '../../common/page/param/page_param.dart';
import '../param/post_param.dart';
import '../repository/post_repository.dart';

enum PostProviderType {
  get,
  getList,
  create,
  update,
  delete,
  like,
  apply,
  applyCancel,
}

class PostProviderParam extends Equatable {
  final PostProviderType type;
  final int? postId;

  const PostProviderParam({
    required this.type,
    this.postId,
  });

  @override
  List<Object?> get props => [type, postId];
}

final postProvider = StateNotifierProvider.family
    .autoDispose<PostStateNotifier, BaseModel, PostProviderParam>((ref, param) {
  final repository = ref.watch(postRepositoryProvider);
  return PostStateNotifier(repository: repository, param: param, ref: ref);
});

class PostStateNotifier extends StateNotifier<BaseModel> {
  final PostProviderParam param;
  final PostRepository repository;
  final AutoDisposeStateNotifierProviderRef ref;

  PostStateNotifier({
    required this.repository,
    required this.param,
    required this.ref,
  }) : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case PostProviderType.get:
        getPost();
        break;
      case PostProviderType.getList:
        getPostList(param: PageParams(page: 1, size: 4, direction: 'DESC'));
        break;
      default:
        break;
    }
  }

  Future<void> getPost() async {
    state = LoadingModel();
    repository.getPost(postId: param.postId!).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getPostList({required PageParams param}) async {
    state = LoadingModel();
    repository.getPostList(param: param).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> createPost({required CreatePostParam param}) async {
    state = LoadingModel();
    repository
        .createPost(postId: this.param.postId!, param: param)
        .then((value) {
      logger.i('post create!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> updatePost({required UpdatePostParam param}) async {
    state = LoadingModel();
    repository
        .updatePost(postId: this.param.postId!, param: param)
        .then((value) {
      logger.i('post update!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> deletePost() async {
    state = LoadingModel();
    repository.deletePost(postId: param.postId!).then((value) {
      logger.i('post delete!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> likePost({required int postId, bool refreshList = true}) async {
    // Optimistic Response
    final pState = refreshList
        ? state as PostList
        : ref.read(postProvider(const PostProviderParam(
            type: PostProviderType.getList,
          ))) as PostList;


    final List<PostListModel> model = pState.data!.map((e) {
      if (e.postId == postId) {
        return e.liked
            ? e.copyWith(liked: false, likeCount: e.likeCount - 1)
            : e.copyWith(liked: true, likeCount: e.likeCount + 1);
      }
      return e;
    }).toList();

    if (refreshList) {
      state = pState.copyWith(data: model);
    } else {
      ref
          .read(postProvider(const PostProviderParam(
            type: PostProviderType.getList,
          )).notifier)
          ._updateList(modelList: model);
      final pState = state as PostModel;
      final prevLike = pState.liked;
      state = pState.copyWith(
        liked: !prevLike,
        likeCount: prevLike ? pState.likeCount - 1 : pState.likeCount + 1,
      );
    }

    log("갱신!");
    // state = LoadingModel();

    repository.likePost(postId: postId).then((value) {
      logger.i('post like!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> applyCancelPost() async {
    state = LoadingModel();
    repository.applyCancelPost(postId: param.postId!).then((value) {
      logger.i('post apply cancel!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> applyPost({required ApplyPostParam param}) async {
    state = LoadingModel();
    repository
        .applyPost(postId: this.param.postId!, param: param)
        .then((value) {
      logger.i('post apply!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  void _updateList({required List<PostListModel> modelList}) {
    final model = state as PostList;
    state = model.copyWith(data: modelList);
  }
}
