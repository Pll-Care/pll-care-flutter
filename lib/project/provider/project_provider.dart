import 'package:dio/dio.dart';
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
      logger.e(e);
      state = ErrorModel.respToError(e);
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
      logger.e(e);
      state = ErrorModel.respToError(e);
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
      logger.e(e);
      state = ErrorModel.respToError(e);
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
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}

final projectProvider =
    StateNotifierProvider<ProjectStateNotifier, BaseModel?>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectStateNotifier(repository: repository);
});

class ProjectStateNotifier extends StateNotifier<BaseModel?> {
  final ProjectRepository repository;

  ProjectStateNotifier({required this.repository}) : super(null);

  Future<void> selfOut({required int projectId}) async {
    repository.selfOutProject(projectId: projectId).then((value) {
      logger.i('project selfOut');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> createProject({required ProjectCreateParam param}) async {
    repository.createProject(param: param).then((value) {
      logger.i('project create');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
