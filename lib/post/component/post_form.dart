import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/component/drop_down_button.dart';
import 'package:pllcare/project/component/project_form.dart';
import 'package:pllcare/theme.dart';

import '../../management/model/team_member_model.dart';
import '../model/post_model.dart';

class PostFormComponent extends StatelessWidget {
  const PostFormComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 2.h,
      color: GREY_400,
      height: 30.h,
    );
    return SliverToBoxAdapter(
      child: Form(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              style: titleFormTextStyle,
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return '제목은 필수사항입니다.';
                }
              },
              decoration: InputDecoration(
                hintText: '제목을 입력해주세요.',
                hintStyle: titleFormTextStyle.copyWith(
                  color: GREEN_400,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: GREEN_200, width: 2.w),
                  color: GREY_100,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.1),
                        blurRadius: 30.r,
                        offset: Offset(0, 10.h)),
                  ]),
              child: Column(
                children: [
                  _PostFormField(
                    fieldName: '프로젝트 선택',
                    dropItems: [
                      '123123123123123123123123123',
                      '456',
                      '789',
                      '10'
                    ],
                  ),
                  SizedBox(height: 24.h),
                  const DateForm(
                    title: '모집 기간',
                  ),
                  SizedBox(height: 24.h),
                  _PostFormField(
                    fieldName: '지역',
                    dropItems: Region.values.map((e) => e.name).toList(),
                  ),
                  divider,
                  _PostPositionForm(),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class _PostFormField extends StatelessWidget {
  final String fieldName;
  final List<String> dropItems;

  const _PostFormField(
      {super.key, required this.fieldName, required this.dropItems});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            fieldName,
            style: m_Heading_01.copyWith(color: GREEN_400),
          ),
        ),
        CustomDropDownButton(onChanged: (value) {}, items: dropItems),
      ],
    );
  }
}

class _PostPositionForm extends StatelessWidget {
  const _PostPositionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '포지션',
            style: m_Heading_01.copyWith(color: GREEN_400),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PositionTextForm(
              title: PositionType.BACKEND.name,
            ),
            _PositionTextForm(
              title: PositionType.FRONTEND.name,
            ),
            _PositionTextForm(
              title: PositionType.PLANNER.name,
            ),
            _PositionTextForm(
              title: PositionType.DESIGN.name,
            ),
          ],
        )
      ],
    );
  }
}

class _PositionTextForm extends StatelessWidget {
  final String title;

  const _PositionTextForm({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(48.r),
      borderSide: BorderSide(color: GREEN_200, width: 2.w),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            title,
            style: m_Heading_01.copyWith(color: GREEN_400),
            textAlign: TextAlign.left,
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.remove,
              color: GREEN_400,
            )),
        SizedBox(
          width: 60.w,
          child: TextFormField(
            initialValue: '0',
            style: m_Heading_01.copyWith(color: GREEN_400),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                border: border,
                focusedBorder: border,
                enabledBorder: border,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                constraints: BoxConstraints.loose(Size(60.w, 40.h))),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              color: GREEN_400,
            ))
      ],
    );
  }
}
