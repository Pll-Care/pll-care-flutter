import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/memo/provider/widget/memo_form_provider.dart';
import 'package:pllcare/theme.dart';

final memoFormKey = GlobalKey<FormState>();

class MemoForm extends ConsumerStatefulWidget {
  final String? title;
  final String? content;

  const MemoForm({super.key, this.title, this.content});

  @override
  ConsumerState<MemoForm> createState() => _MemoFormState();
}

class _MemoFormState extends ConsumerState<MemoForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(pMemoFormProvider.notifier).updateFormField(
          title: widget.title, content: widget.content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height / 5 * 3,
      width: MediaQuery
          .of(context)
          .size
          .width / 3 * 2,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          ref.watch(pMemoFormProvider);
          return Form(
            key: memoFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.title,
                  decoration: InputDecoration(
                      hintText: '회의록 제목을 입력해주세요.',
                      hintStyle: titleFormTextStyle.copyWith(
                        color: GREEN_400,
                      )),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: titleFormTextStyle,
                  validator: (String? val) {
                    if (val == null || val.isEmpty) {
                      return '제목은 필수사항입니다.';
                    }
                  },
                  onChanged: (val) {
                    ref
                        .read(pMemoFormProvider
                        .notifier)
                        .updateFormField(title: val);
                  },
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.content,
                    decoration:
                    const InputDecoration(hintText: '회의록 내용을 입력해주세요.'),
                    expands: true,
                    maxLines: null,
                    maxLength: 500,
                    textInputAction: TextInputAction.newline,
                    cursorColor: GREEN_200,
                    style: contentFormTextStyle,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    validator: (String? val) {
                      if (val == null || val.isEmpty) {
                        return '내용은 필수사항입니다.';
                      }
                    },
                    onChanged: (val) {
                      ref
                          .read(pMemoFormProvider
                          .notifier)
                          .updateFormField(content: val);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
