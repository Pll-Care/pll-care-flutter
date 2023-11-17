import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/repository/project_repository.dart';

class ProjectMostLikedStateNotifier extends StateNotifier<List<ModelBase>> {
  final ProjectRepository repository;

  ProjectMostLikedStateNotifier({required this.repository})
      : super(ModelLoading());

  Future<void> getMostLiked() async {
    state = repository.getMostLiked();
  }
}
