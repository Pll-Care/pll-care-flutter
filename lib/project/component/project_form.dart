import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/schedule/provider/date_range_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/util.dart';

final imageUrlProvider = StateProvider.autoDispose<String?>((ref) => null);
typedef ImagePick = Function(WidgetRef ref);

class ProjectForm extends ConsumerWidget {
  final FormFieldSetter<String?>? onSavedTitle;
  final FormFieldSetter<String?>? onSavedDesc;
  final VoidCallback onSaved;
  final ImagePick pickImage;
  final ImagePick deleteImage;

  const ProjectForm({
    super.key,
    required this.onSavedTitle,
    required this.onSavedDesc,
    required this.onSaved,
    required this.pickImage,
    required this.deleteImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                log('title value ${val}');
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
                    Consumer(
                      builder: (_, ref, __) {
                        final imageUrl = ref.watch(imageUrlProvider);
                        return CircleAvatar(
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/default/')
                                  as ImageProvider,
                          //todo image 변경
                          radius: 30,
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    _CustomButton(
                      title: '이미지 업로드',
                      onPressed: pickImage(ref),
                    ),
                    SizedBox(height: 4.h),
                    _CustomButton(
                      title: '이미지 제거',
                      onPressed: deleteImage(ref),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                            color: GREY_100,
                            borderRadius: BorderRadius.circular(5.r)),
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: const DateForm(),
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
                            log('desc value ${val}');
                            if (val != null) {
                              return '내용은 필수사항입니다.';
                            }
                          },
                          onSaved: onSavedDesc,
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

class DateForm extends ConsumerWidget {
  const DateForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);
    final dateFormat = DateFormat('yy-MM-dd');
    return Column(
      children: [
        Row(
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
                        .read(dateRangeProvider.notifier)
                        .updateDate(startDate: value);

                    log('value ${ref.read(dateRangeProvider).startDate}');
                  },
                  onPressed: () {
                    if (ref.read(dateRangeProvider).startDate == null) {
                      final dateTime =
                          DateTimeUtil.getyMd(dateTime: DateTime.now());
                      ref
                          .read(dateRangeProvider.notifier)
                          .updateDate(startDate: dateTime);
                    }
                    context.pop();
                  },
                  ref: ref,
                );
              },
              child: Text(
                dateRange.startDate == null
                    ? '시작일자'
                    : dateFormat.format(dateRange.startDate!).toString(),
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
                        .read(dateRangeProvider.notifier)
                        .updateDate(endDate: value);
                  },
                  onPressed: () {
                    if (ref.read(dateRangeProvider).endDate == null) {
                      final dateTime =
                          DateTimeUtil.getyMd(dateTime: DateTime.now());
                      ref
                          .read(dateRangeProvider.notifier)
                          .updateDate(endDate: dateTime);
                    }
                    context.pop();
                  },
                  ref: ref,
                );
              },
              child: Text(
                dateRange.endDate == null
                    ? '종료일자'
                    : dateFormat.format(dateRange.endDate!).toString(),
                style: m_Heading_03.copyWith(color: GREEN_400),
              ),
            ),
          ],
        ),
        if (ref.watch(dateRangeProvider.notifier).isValidate())
          Text(
            "시작일자가 종료일자가 같거나 이후 일 수 없습니다.",
            style: m_Heading_03.copyWith(color: Colors.red),
          ),
      ],
    );
  }

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
}

class _CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _CustomButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textButtonStyle = TextButton.styleFrom(
        backgroundColor: GREY_100,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(48.r)));

    return SizedBox(
      height: 30.h,
      child: TextButton(
        onPressed: onPressed,
        style: textButtonStyle,
        child: Text(
          '이미지 제거',
          style: m_Button_01.copyWith(color: GREEN_400),
        ),
      ),
    );
  }
}
