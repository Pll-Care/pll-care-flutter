import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/dio/param/param.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/repository/project_repository.dart';

final projectMostLikedProvider =
    StateNotifierProvider<ProjectMostLikedStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectMostLikedStateNotifier(repository: repository);
});

class ProjectMostLikedStateNotifier extends StateNotifier<BaseModel> {
  final ProjectRepository repository;

  ProjectMostLikedStateNotifier({required this.repository})
      : super(LoadingModel()){
   getMostLiked();
  }

  Future<void> getMostLiked() async {
    final resp = await repository.getMostLiked();
    state = ListModel<ProjectMostLiked>(data: resp);
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
      : super(LoadingModel()){
    getCloseDeadline();
  }

  Future<void> getCloseDeadline() async {
    final resp = await repository.getCloseDeadLine();
    state = ListModel<ProjectCloseDeadLine>(data: resp);
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
      : super(LoadingModel()){
    getUpToDate();
  }

  Future<void> getUpToDate() async {
    final resp = await repository.getUpToDate();
    state = ListModel<ProjectUpToDate>(data: resp);
  }
}

final projectListProvider =
StateNotifierProvider<ProjectListStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectListStateNotifier(repository: repository);
});

class ProjectListStateNotifier extends StateNotifier<BaseModel> {
  final ProjectRepository repository;

  ProjectListStateNotifier({required this.repository})
      : super(LoadingModel()){
    getList(params: ProjectParams(page: 0, size: 5, direction: 'ASC', state: [ProjectListType.TBD]));
  }

  Future<void> getList({required ProjectParams params}) async {
    final resp = await repository.getProjectList(params: params);
    state = resp;
  }
}