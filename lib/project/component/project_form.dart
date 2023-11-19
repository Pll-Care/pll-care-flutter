import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/theme.dart';

class ProjectForm extends StatelessWidget {
   ProjectForm({super.key});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey ,
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 34.h, bottom: 14.h),
              child: TextFormField(

                decoration: InputDecoration(
                  hintText: '프로젝트 이름을 입력하세요',
                  hintStyle: m_Heading_01.copyWith(
                    color: GREY_400,
                  ),
                ),
                validator: (val){
                  if(val != null) {
                    return '이름은 필수사항입니다.';
                  }
                  if(val!.length < 5) {
                    return '이름은 다섯 글자 이상 입력 해주셔야 합니다.';
                  }
                },
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
                      SizedBox(height: 8.h,),
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
                      SizedBox(height:4.h),
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
                            children: [
                              Text(
                                '진행 기간',
                                style:
                                    m_Heading_03.copyWith(color: GREEN_400),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          cursorColor: GREEN_400,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.r),
                                borderSide: BorderSide.none),
                            fillColor: GREY_100,
                            filled: true,
                            hintText: '내용 입력',
                            hintStyle: m_Heading_03.copyWith(
                              color: GREY_400,
                            ),
                          ),
                          validator: (val){
                            if(val != null) {
                              return '내용은 필수사항입니다.';
                            }

                          },
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
                    onPressed: ()async {
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        context.pop();
                      }
                    },
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
      ),
    );
  }
}
