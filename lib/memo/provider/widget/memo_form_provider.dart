import 'package:pllcare/memo/provider/memo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_form_provider.g.dart';

enum MemoFormType {
  create,
  update,
}

class MemoFormModel {
  final String title;
  final String content;

  MemoFormModel({
    required this.title,
    required this.content,
  });

  MemoFormModel copyWith({
    String? title,
    String? content,
  }) {
    return MemoFormModel(
      title: title ?? this.title, content: content ?? this.content,);
  }
}

@Riverpod()
class PMemoForm extends _$PMemoForm {
  @override
  MemoFormModel build({required MemoFormType formType, int? projectId}) {
    // final baseModel = ref.read(memoProvider(MemoProviderParam(type: MemoProviderType.get, projectId: projectId)));

    return MemoFormModel(title: '', content: '');
  }

  void updateFormField({String? title, String? content}) {
    state = state.copyWith(title: title, content: content);
  }
}
