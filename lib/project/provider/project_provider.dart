import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/logger/custom_logger.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/project/param/param.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/param/project_create_param.dart';
import 'package:pllcare/project/repository/project_repository.dart';

final projectMostLikedProvider =
    StateNotifierProvider<ProjectMostLikedStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectMostLikedStateNotifier(repository: repository);
});

class ProjectMostLikedStateNotifier extends StateNotifier<BaseModel> {
  final ProjectRepository repository;

  ProjectMostLikedStateNotifier({required this.repository})
      : super(LoadingModel()) {
    getMostLiked();
  }

  Future<void> getMostLiked() async {
    state = LoadingModel();

    repository.getMostLiked().then((value) {
      logger.i(value);
      state = ListModel<ProjectMostLiked>(data: value);
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}

final projectCloseDeadLineProvider =
    StateNotifierProvider<ProjectCloseDeadLineStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectCloseDeadLineStateNotifier(repository: repository);
});

class ProjectCloseDeadLineStateNotifier extends StateNotifier<BaseModel> {
  final ProjectRepository repository;

  ProjectCloseDeadLineStateNotifier({required this.repository})
      : super(LoadingModel()) {
    getCloseDeadline();
  }

  Future<void> getCloseDeadline() async {
    state = LoadingModel();

    repository.getCloseDeadLine().then((value) {
      logger.i(value);
      state = ListModel<ProjectCloseDeadLine>(data: value);
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}

final projectUpToDateProvider =
    StateNotifierProvider<ProjectUpToDateStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectUpToDateStateNotifier(repository: repository);
});

class ProjectUpToDateStateNotifier extends StateNotifier<BaseModel> {
  final ProjectRepository repository;

  ProjectUpToDateStateNotifier({required this.repository})
      : super(LoadingModel()) {
    getUpToDate();
  }

  Future<void> getUpToDate() async {
    state = LoadingModel();

    repository.getUpToDate().then((value) {
      logger.i(value);
      state = ListModel<ProjectUpToDate>(data: value);
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}

final projectListProvider =
    StateNotifierProvider<ProjectListStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectListStateNotifier(repository: repository);
});

class ProjectListStateNotifier extends StateNotifier<BaseModel> {
  final ProjectRepository repository;

  ProjectListStateNotifier({required this.repository}) : super(LoadingModel()) {
    getList(
        params: ProjectParams(
            page: 1,
            size: 5,
            direction: 'DESC',
            state: [StateType.ONGOING, StateType.COMPLETE]));
  }

  Future<void> getList({required ProjectParams params}) async {
    state = LoadingModel();
    repository.getProjectList(params: params).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}

enum ProjectProviderType {
  get,
  getList,
  create,
  update,
  delete,
  selfOut,
  complete,
  isCompleted,
}

class ProjectProviderParam extends Equatable {
  final ProjectProviderType type;
  final int? projectId;

  const ProjectProviderParam({
    required this.type,
    this.projectId,
  });

  @override
  List<Object?> get props => [type, projectId];
}

final projectFamilyProvider = StateNotifierProvider.family.autoDispose<ProjectStateNotifier,
    BaseModel?, ProjectProviderParam>((ref, param) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectStateNotifier(repository: repository, param: param);
});

class ProjectStateNotifier extends StateNotifier<BaseModel?> {
  final ProjectRepository repository;
  final ProjectProviderParam param;

  ProjectStateNotifier({
    required this.repository,
    required this.param,
  }) : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case ProjectProviderType.get:
        // getProject();
        break;
      case ProjectProviderType.getList:
        // getPostList(param: PageParams(page: 1, size: 4, direction: 'DESC'));
        break;
      case ProjectProviderType.isCompleted:
        log("completed!!");
        getIsCompleted();
        break;
      default:
        break;
    }
  }

  Future<void> selfOut() async {
    repository.selfOutProject(projectId: param.projectId!).then((value) {
      logger.i('project selfOut');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<BaseModel?> getProject() async {
    await repository.getProject(projectId: param.projectId!).then((value) {
      logger.i(value);
      return state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> createProject({required CreateProjectFormParam param}) async {
    repository.createProject(param: param).then((value) {
      logger.i('project create');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> updateProject({required UpdateProjectFormParam param}) async {
    repository
        .updateProject(param: param, projectId: this.param.projectId!)
        .then((value) {
      logger.i('project update');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> completeProject() async {
    repository.completeProject(projectId: param.projectId!).then((value) {
      logger.i('project complete');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> deleteProject() async {
    repository.deleteProject(projectId: param.projectId!).then((value) {
      logger.i('project complete');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getIsCompleted() async {
    state = LoadingModel();
    repository.getIsCompleted(projectId: param.projectId!).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}
