import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/schedule/provider/date_range_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/util/util.dart';

import '../model/project_model.dart';

final imageUrlProvider = StateProvider.autoDispose<String?>((ref) => null);
final checkDateValidateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

typedef ImagePick = Future<void> Function(WidgetRef ref);

class ProjectForm extends ConsumerWidget {
  final FormFieldSetter<String?>? onSavedTitle;
  final FormFieldSetter<String?>? onSavedDesc;
  final VoidCallback onSaved;
  final ImagePick pickImage;
  final ImagePick deleteImage;
  final int? projectId;

  const ProjectForm({
    super.key,
    required this.onSavedTitle,
    required this.onSavedDesc,
    required this.onSaved,
    required this.pickImage,
    required this.deleteImage,
    this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProjectModel? projectModel;
    if (projectId != null) {
      final bModel = ref.watch(projectFamilyProvider(projectId!));

      if (bModel is ProjectModel) {
        projectModel = bModel as ProjectModel;
        // ref
        //     .read(imageUrlProvider.notifier)
        //     .update((state) => projectModel!.imageUrl);
        // final startDate = DateTime.parse(projectModel.startDate);
        // final endDate = DateTime.parse(projectModel.endDate);
        // ref
        //     .read(dateRangeProvider.notifier)
        //     .updateDate(startDate: startDate, endDate: endDate);
      }
    }

    final inputFormBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(color: GREEN_200, width: 2.0),
    );
    final inputDecoration = InputDecoration(
      border: inputFormBorder,
      focusedBorder: inputFormBorder,
      enabledBorder: inputFormBorder,
      fillColor: GREY_100,
      filled: true,
      hintText: '내용 입력',
      hintStyle: m_Heading_03.copyWith(
        color: GREY_400,
      ),
      errorStyle: m_Heading_04.copyWith(color: Colors.red),
    );
    ref.watch(dateRangeProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 34.h, bottom: 14.h),
            child: TextFormField(
              maxLength: 20,
              initialValue: projectModel != null ? projectModel.title : null,
              decoration: inputDecoration.copyWith(
                hintText: '프로젝트 이름을 입력하세요',
                hintStyle: m_Heading_01.copyWith(
                  color: GREY_400,
                ),
              ),
              cursorColor: GREEN_400,
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return '이름은 필수사항입니다.';
                }
                if (val.length < 5) {
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
                              : const AssetImage('assets/main/main1.png')
                                  as ImageProvider,
                          //todo image 변경
                          radius: 30,
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    _CustomButton(
                      title: '이미지 업로드',
                      onPressed: () {
                        log("이미지 업로드!");
                        pickImage(ref);
                      },
                    ),
                    SizedBox(height: 4.h),
                    _CustomButton(
                      title: '이미지 제거',
                      onPressed: () {
                        deleteImage(ref);
                      },
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                            color: GREY_100,
                            borderRadius: BorderRadius.circular(5.r)),
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: const DateForm(),
                      ),
                      if (!ref.watch(dateRangeProvider.notifier).isValidate())
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "시작일자가 종료일자가 같거나 이후 일 수 없습니다.",
                            style: m_Heading_04.copyWith(color: Colors.red),
                          ),
                        ),
                      if (!ref
                              .watch(dateRangeProvider.notifier)
                              .isSaveValidate() &&
                          ref.watch(checkDateValidateProvider))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            style: m_Heading_04.copyWith(color: Colors.red),
                            "시작일자와 종료일자를 선택해주세요.",
                          ),
                        ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Expanded(
                        child: TextFormField(
                          cursorColor: GREEN_400,
                          initialValue: projectModel != null ? projectModel.description : null,

                          maxLines: null,
                          maxLength: 500,
                          expands: true,
                          decoration: inputDecoration,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
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
                    projectId == null ? '작성 완료' : '수정 완료',
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
      mainAxisAlignment: MainAxisAlignment.center,
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
          title,
          style: m_Button_01.copyWith(color: GREEN_400),
        ),
      ),
    );
  }
}
