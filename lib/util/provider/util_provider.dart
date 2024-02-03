import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/util/repository/util_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../model/techstack_model.dart';

final utilProvider =
    StateNotifierProvider.autoDispose<UtilStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(utilRepositoryProvider);
  return UtilStateNotifier(repository: repository);
});

class UtilStateNotifier extends StateNotifier<BaseModel> {
  final UtilRepository repository;

  final techStackDebounce =
      Debouncer<String?>(const Duration(milliseconds: 200), initialValue: null);

  UtilStateNotifier({required this.repository}) : super(LoadingModel()) {
    techStackDebounce.values.listen((state) {
      getTechStackDebounce(tech: state as String);
    });
  }

  Future<void> getTechStack({required String title}) async {
    techStackDebounce.setValue(title);
  }

  Future<void> getTechStackDebounce({required String tech}) async {
    await repository.getTechStack(tech: tech).then((value) {
      logger.i('tech list!');
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}
