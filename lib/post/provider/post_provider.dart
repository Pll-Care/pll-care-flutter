import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/logger/custom_logger.dart';
import 'package:pllcare/common/model/default_model.dart';

import '../../common/page/param/page_param.dart';
import '../../common/provider/default_provider_type.dart';
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

class PostStateNotifier extends StateNotifier<BaseModel> {
  final PostProviderParam param;
  final PostRepository repository;

  PostStateNotifier({required this.repository, required this.param})
      : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case PostProviderType.get:
        getPost();
        break;
      case PostProviderType.getList:
        getPostList(param: PageParams(page: 0, size: 6, direction: 'DESC'));
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
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> getPostList({required PageParams param}) async {
    state = LoadingModel();
    repository.getPostList(param: param).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> createPost({required CreatePostParam param}) async {
    state = LoadingModel();
    repository
        .createPost(postId: this.param.postId!, param: param)
        .then((value) {
      logger.i('post create!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> updatePost({required UpdatePostParam param}) async {
    state = LoadingModel();
    repository
        .updatePost(postId: this.param.postId!, param: param)
        .then((value) {
      logger.i('post update!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> deletePost() async {
    state = LoadingModel();
    repository.deletePost(postId: param.postId!).then((value) {
      logger.i('post delete!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> likePost() async {
    state = LoadingModel();
    repository.likePost(postId: param.postId!).then((value) {
      logger.i('post like!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> applyCancelPost() async {
    state = LoadingModel();
    repository.applyCancelPost(postId: param.postId!).then((value) {
      logger.i('post apply cancel!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> applyPost({required ApplyPostParam param}) async {
    state = LoadingModel();
    repository
        .applyPost(postId: this.param.postId!, param: param)
        .then((value) {
      logger.i('post apply!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
