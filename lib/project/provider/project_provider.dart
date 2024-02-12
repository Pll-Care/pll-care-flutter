import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/logger/custom_logger.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/management/provider/management_provider.dart';
import 'package:pllcare/management/repository/management_repository.dart';
import 'package:pllcare/project/param/param.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/param/project_create_param.dart';
import 'package:pllcare/project/repository/project_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../management/model/leader_model.dart';
import '../component/project_body.dart';

part 'project_provider.g.dart';

@riverpod
Future<ProjectSimpleList> projectSimple(
  ProjectSimpleRef ref,
) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getSimpleProjectList();
}

@Riverpod(keepAlive: false)
class ProjectLeader extends _$ProjectLeader {
  @override
  BaseModel build({required int projectId}) {
    getIsLeader(projectId: projectId);
    return LoadingModel();
  }

  Future<void> getIsLeader({required int projectId}) async {
    final repository = ref.read(managementRepositoryProvider);
    await repository.getIsLeader(projectId: projectId).then((value) {
      state = value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      state = error;
    });
  }

  void loseLeader() {
    state = LeaderModel(leader: false);
  }
}

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

final projectFamilyProvider = StateNotifierProvider.family
    .autoDispose<ProjectStateNotifier, BaseModel?, ProjectProviderParam>(
        (ref, param) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectStateNotifier(repository: repository, param: param, ref: ref);
});

class ProjectStateNotifier extends StateNotifier<BaseModel?> {
  final ProjectRepository repository;
  final ProjectProviderParam param;
  final StateNotifierProviderRef ref;

  ProjectStateNotifier({
    required this.repository,
    required this.param,
    required this.ref,
  }) : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case ProjectProviderType.get:
        // getProject();
        break;
      case ProjectProviderType.getList:
        // getPostList(param: defaultPageParam);
        break;
      case ProjectProviderType.isCompleted:
        log("completed!!");
        getIsCompleted();
        break;
      default:
        break;
    }
  }

  Future<BaseModel> selfOut() async {
    return await repository
        .selfOutProject(projectId: param.projectId!)
        .then<BaseModel>((value) {
      logger.i('project selfOut');
      ref.read(projectListProvider.notifier).getList(
          params: ProjectParams(
              page: 1,
              size: 5,
              direction: 'DESC',
              state: [StateType.COMPLETE, StateType.ONGOING]));
      ref.read(isSelectAllProvider.notifier).update((isSelectAll) {
        return true;
      });
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel?> getProject() async {
    return await repository
        .getProject(projectId: param.projectId!)
        .then<BaseModel>((value) {
      logger.i(value);
      return state = value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel> createProject(
      {required CreateProjectFormParam param}) async {
    return await repository
        .createProject(param: param)
        .then<BaseModel>((value) {
      logger.i('project create');
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel> updateProject(
      {required UpdateProjectFormParam param}) async {
    return await repository
        .updateProject(param: param, projectId: this.param.projectId!)
        .then<BaseModel>((value) {
      logger.i('project update');
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel> completeProject() async {
    return await repository
        .completeProject(projectId: param.projectId!)
        .then<BaseModel>((value) {
      logger.i('project complete');
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel> deleteProject() async {
    return await repository
        .deleteProject(projectId: param.projectId!)
        .then<BaseModel>((value) {
      logger.i('project complete');
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel> getIsCompleted() async {
    state = LoadingModel();
    return await repository
        .getIsCompleted(projectId: param.projectId!)
        .then<BaseModel>((value) {
      logger.i(value);
      state = value;
      return value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }
}
