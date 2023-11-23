import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/theme.dart';

final startDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final endDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

class ProjectForm extends ConsumerWidget {
  final FormFieldSetter<String?>? onSavedTitle;
  final FormFieldSetter<String?>? onSavedContent;
  final VoidCallback onSaved;

  const ProjectForm({
    super.key,
    required this.onSavedTitle,
    required this.onSavedContent,
    required this.onSaved,
  });

  void dateDialog({
    required BuildContext context,
    required bool isStartDate,
    required ValueChanged<DateTime> onDateTimeChanged,
    required VoidCallback onPressed,
    required WidgetRef ref,
  }) {
    final now = DateTime.now();
    final minimumDate = DateTime(now.year, now.month, now.day);
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: GREY_100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Material(
                      child: Text(
                        isStartDate ? '프로젝트 시작일자' : '프로젝트 종료일자',
                        style: Heading_06.copyWith(color: GREEN_200),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: isStartDate ? minimumDate : null,
                        onDateTimeChanged: onDateTimeChanged,
                      ),
                    ),
                    TextButton(
                        onPressed: onPressed,
                        child: Text(
                          "선택",
                          style: m_Button_03.copyWith(color: GREY_100),
                        )),
                  ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = ref.watch(startDateProvider);
    final endDate = ref.watch(endDateProvider);
    final dateFormat = DateFormat('yy-MM-dd');
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide.none),
      fillColor: GREY_100,
      filled: true,
      hintText: '내용 입력',
      hintStyle: m_Heading_03.copyWith(
        color: GREY_400,
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.h, bottom: 14.h),
            child: TextFormField(
              decoration: inputDecoration.copyWith(
                  hintText: '프로젝트 이름을 입력하세요',
                  hintStyle: m_Heading_01.copyWith(
                    color: GREY_400,
                  )),
              validator: (val) {
                if (val != null) {
                  return '이름은 필수사항입니다.';
                }
                if (val!.length < 5) {
                  return '이름은 다섯 글자 이상 입력 해주셔야 합니다.';
                }
              },
              onSaved: onSavedTitle,
            ),
          ),
          Container(
            width: 330.w,
            height: 195.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: GREEN_200,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      // backgroundImage: NetworkImage(''),
                      radius: 30,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      height: 30.h,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: GREY_100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48.r))),
                        child: Text(
                          '이미지 업로드',
                          style: m_Button_01.copyWith(color: GREEN_400),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      height: 30.h,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: GREY_100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48.r))),
                        child: Text(
                          '이미지 제거',
                          style: m_Button_01.copyWith(color: GREEN_400),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                            color: GREY_100,
                            borderRadius: BorderRadius.circular(5.r)),
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '진행 기간',
                              style: m_Heading_03.copyWith(color: GREEN_400),
                            ),
                            GestureDetector(
                              onTap: () {
                                dateDialog(
                                  context: context,
                                  isStartDate: true,
                                  onDateTimeChanged: (DateTime value) {
                                    ref
                                        .read(startDateProvider.notifier)
                                        .update((state) => value);

                                    log('value ${ref.read(startDateProvider)}');
                                  },
                                  onPressed: () {
                                    if (ref.read(startDateProvider) == null) {
                                      ref
                                          .read(startDateProvider.notifier)
                                          .update((state) => DateTime.now());
                                    }
                                    context.pop();
                                  },
                                  ref: ref,
                                );
                              },
                              child: Text(
                                startDate == null
                                    ? '시작일자'
                                    : dateFormat.format(startDate).toString(),
                                style: m_Heading_03.copyWith(color: GREEN_400),
                              ),
                            ),
                            Text(
                              ' ~ ',
                              style: m_Heading_03.copyWith(color: GREEN_400),
                            ),
                            GestureDetector(
                              onTap: () {
                                dateDialog(
                                  context: context,
                                  isStartDate: false,
                                  onDateTimeChanged: (DateTime value) {
                                    ref
                                        .read(endDateProvider.notifier)
                                        .update((state) => value);
                                  },
                                  onPressed: () {
                                    if (ref.read(endDateProvider) == null) {
                                      ref
                                          .read(endDateProvider.notifier)
                                          .update((state) => DateTime.now());
                                    }
                                    context.pop();
                                  },
                                  ref: ref,
                                );
                              },
                              child: Text(
                                endDate == null
                                    ? '종료일자'
                                    : dateFormat.format(endDate).toString(),
                                style: m_Heading_03.copyWith(color: GREEN_400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Expanded(
                        child: TextFormField(
                          cursorColor: GREEN_400,
                          maxLines: null,
                          expands: true,
                          decoration: inputDecoration,
                          validator: (val) {
                            if (val != null) {
                              return '내용은 필수사항입니다.';
                            }
                          },
                          onSaved: onSavedContent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 90.w,
                child: TextButton(
                  onPressed: onSaved,
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.r))),
                  child: Text(
                    '작성 완료',
                    style: m_Button_00.copyWith(
                      color: GREY_100,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
