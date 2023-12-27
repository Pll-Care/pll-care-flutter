import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/management/provider/management_provider.dart';

import '../../common/model/default_model.dart';
import '../../management/model/team_member_model.dart';
import '../../theme.dart';
import '../model/schedule_detail_model.dart';
import '../provider/widget/schedule_create_form_provider.dart';
import 'calendar_component.dart';

final calendarViewProvider = StateProvider.autoDispose<bool>((ref) => true);

class ScheduleFormComponent extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final FormFieldSetter<String?>? onSavedTitle;
  final FormFieldSetter<String?>? onSavedContent;
  final int projectId;
  final ScheduleDetailModel? model;

  const ScheduleFormComponent({
    super.key,
    required this.projectId,
    required this.formKey,
    required this.onSavedTitle,
    required this.onSavedContent,
    this.model,
  });

  @override
  ConsumerState<ScheduleFormComponent> createState() =>
      _ScheduleFormComponentState();
}

class _ScheduleFormComponentState extends ConsumerState<ScheduleFormComponent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.model != null) {
        final ScheduleForm form = ScheduleForm.fromModel(model: widget.model!);
        ref.read(scheduleCreateFormProvider.notifier).initForm(form: form);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropTextStyle = m_Body_01.copyWith(color: GREEN_400);
    final textStyle = m_Button_00.copyWith(color: GREEN_400);
    final titleTextStyle = Heading_05.copyWith(color: GREY_500);
    final ScheduleForm form = ref.watch(scheduleCreateFormProvider);
    final view = ref.watch(calendarViewProvider);
    final memberList = ref.watch(managementProvider(widget.projectId));


    final format = DateFormat('yy-MM-dd HH:mm');
    List<DropdownMenuItem> categoryItems = [
      DropdownMenuItem<ScheduleCategory>(
        value: ScheduleCategory.MILESTONE,
        child: Text(
          '새 계획 생성',
          style: dropTextStyle,
        ),
      ),
      DropdownMenuItem(
        value: ScheduleCategory.MEETING,
        child: Text(
          '새 회의 생성',
          style: dropTextStyle,
        ),
      )
    ];
    return GestureDetector(
      onPanDown: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: '일정 제목을 입력하세요',
                  hintStyle: titleTextStyle,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                initialValue: widget.model?.title ?? '',
                cursorColor: GREEN_200,
                style: titleTextStyle,
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return '일정 제목은 필수사항입니다.';
                  }
                  if (val.length < 2 || val.length > 20) {
                    return '제목은 2글자 이상 20글자 이하로 입력 해주셔야 합니다.';
                  }
                  return null;
                },
                onSaved: widget.onSavedTitle,
                // onChanged: (value) {
                //   if (widget.formKey.currentState!.validate()) {
                //     ref
                //         .read(scheduleCreateFormProvider.notifier)
                //         .updateForm(form: form.copyWith(title: value));
                //   }
                // },
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: GREEN_200)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 80.w,
                          child: Text(
                            '카테고리',
                            style: textStyle,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: categoryItems,
                            value: form.category,
                            onChanged: (value) {
                              ref
                                  .read(scheduleCreateFormProvider.notifier)
                                  .updateForm(
                                      form: form.copyWith(category: value));
                            },
                            borderRadius: BorderRadius.circular(48.r),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            '진행 기간',
                            style: textStyle,
                          ),
                        ),
                        Column(children: [
                          Row(
                            children: [
                              Text(
                                "시작",
                                style: textStyle,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                format.format(form.startDateTime!),
                                style: Body_01.copyWith(color: GREY_500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("종료", style: textStyle),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                form.endDateTime == null
                                    ? ''
                                    : format.format(form.endDateTime!),
                                style: Body_01.copyWith(color: GREY_500),
                              ),
                            ],
                          ),
                        ]),
                        IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              ref
                                  .read(calendarViewProvider.notifier)
                                  .update((state) => !state);
                            },
                            icon: Icon(
                              view ? Icons.expand_less : Icons.expand_more,
                              size: 24,
                            )),
                      ],
                    ),
                    if (view) const CalendarComponent(),
                    if (form.category == ScheduleCategory.MEETING)
                      Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            child: Text(
                              '모임 위치',
                              style: textStyle,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: '모임 위치',
                                  hintStyle: Body_02.copyWith(
                                    color: GREY_400,
                                  ),
                                  border: const UnderlineInputBorder(
                                      borderSide: BorderSide.none)),
                              cursorColor: GREEN_200,
                              style: Body_02,
                            ),
                          ),
                        ],
                      ),
                    const Divider(
                      color: GREY_400,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 80.w,
                          child: Text(
                            '참여자',
                            style: textStyle,
                          ),
                        ),
                        if (memberList is ListModel<TeamMemberModel>)
                          Expanded(
                            child: Wrap(
                              spacing: 5.w,
                              children: [
                                ...memberList.data.map((e) {
                                  final hasMember = ref
                                      .read(scheduleCreateFormProvider.notifier)
                                      .hasMember(memberId: e.memberId);
                                  return GestureDetector(
                                    onTap: () {
                                      if (hasMember) {
                                        form.memberIds.remove(e.memberId);
                                      } else {
                                        form.memberIds.add(e.memberId);
                                      }
                                      ref
                                          .read(scheduleCreateFormProvider
                                              .notifier)
                                          .updateForm(form: form);
                                      setState(() {});
                                    },
                                    child: Chip(
                                      label: Text(
                                        e.name,
                                        style: m_Button_00.copyWith(
                                            color: hasMember
                                                ? GREY_100
                                                : GREEN_400),
                                      ),
                                      backgroundColor:
                                          hasMember ? GREEN_200 : GREY_100,
                                      side: const BorderSide(
                                          color: GREEN_200, width: 2),
                                    ),
                                  );
                                }).toList()
                              ],
                            ),
                          )
                        else
                          Container(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 200.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: GREEN_200)),
                child: TextFormField(
                  expands: true,
                  maxLength: 500,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: '내용 입력',
                    hintStyle: textStyle,
                    border:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  initialValue: widget.model?.content ?? '',
                  cursorColor: GREEN_200,
                  style: textStyle.copyWith(color: GREY_500),
                  validator: (String? val) {
                    if (val == null || val.isEmpty) {
                      return '내용은 필수사항입니다.';
                    }
                    return null;
                  },
                  // onChanged: (value) {
                  //   log('value $value');
                  //   if (widget.formKey.currentState!.validate()) {
                  //     log('value $value');
                  //     ref
                  //         .read(scheduleCreateFormProvider.notifier)
                  //         .updateForm(form: form.copyWith(content: value));
                  //   }
                  // },
                  onSaved: widget.onSavedContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
