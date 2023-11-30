import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/util/repository/util_repository.dart';

import '../model/techstack_model.dart';

class UtilStateNotifier extends StateNotifier<BaseModel> {
  final UtilRepository repository;

  final techStackDebounce = Debouncer(const Duration(milliseconds: 200),
      initialValue: null);

  UtilStateNotifier({required this.repository}) : super(LoadingModel()) {
    techStackDebounce.values.listen((event) {
      // getTechStack(tech: );
    });
  }

  Future<TechStackList> getTechStack({required String tech}) async {
    return state = await repository.getTechStack(tech: tech);
  }
}
