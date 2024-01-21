import 'package:pllcare/memo/provider/memo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_form_provider.g.dart';


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
  MemoFormModel build() {
    return MemoFormModel(title: '', content: '');
  }

  void updateFormField({String? title, String? content}) {
    state = state.copyWith(title: title, content: content);
  }
}
