import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/memo/provider/widget/memo_form_provider.dart';
import 'package:pllcare/theme.dart';

final memoFormKey = GlobalKey<FormState>();

class MemoForm extends StatelessWidget {
  const MemoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5 * 3,
      width: MediaQuery.of(context).size.width / 3 * 2,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          ref.watch(pMemoFormProvider(formType: MemoFormType.create));
          return Form(
            key: memoFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
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
                        .read(pMemoFormProvider(formType: MemoFormType.create)
                            .notifier)
                        .updateFormField(title: val);
                  },
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: TextFormField(
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
                          .read(pMemoFormProvider(formType: MemoFormType.create)
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
