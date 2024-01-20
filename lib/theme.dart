import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const GREY_100 = Color(0xfffcfcfc);
const GREY_400 = Color(0xffB4BCBD);
const GREY_500 = Color(0xff373E3B);

const GREEN_200 = Color(0xff01E89E);
const GREEN_400 = Color(0xff00AA72);
const GREEN_500 = Color(0xff003B28);

const TOMATO_100 = Color(0xffFEE7E7);
const TOMATO_500 = Color(0xffC9000C);

const NONE_COLOR = Color(0xff810143);

// - family: IBMPlexSansKR
//
// - family: NotoSansKR

/*
  w100 Thin, the least thick
  w200 Extra-light
  w300 Light
  w400 Normal / regular / plain
  w500 Medium
  w600 Semi-bold
  w700 Bold
  w800 Extra-bold
  w900 Black, the most thick
 */

final TextStyle Heading_01 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w700, fontSize: 46.sp);
final TextStyle Heading_02 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w700, fontSize: 40.sp);
final TextStyle Heading_03 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w700, fontSize: 32.sp);
final TextStyle Heading_04 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w600, fontSize: 28.sp);
final TextStyle Heading_05 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w600, fontSize: 22.sp);
final TextStyle Heading_06 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontWeight: FontWeight.w500,
    fontSize: 20.sp); // -4
final TextStyle Heading_07 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontWeight: FontWeight.w900,
    fontSize: 18.sp); // -4

final TextStyle m_Heading_01 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontWeight: FontWeight.w700,
    fontSize: 16.sp); // -6
final TextStyle m_Heading_02 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w700, fontSize: 20.sp);
final TextStyle m_Heading_03 = TextStyle(
    fontFamily: 'IBMPlexSansKR',
    fontWeight: FontWeight.w600,
    fontSize: 14.sp); //-4
final TextStyle m_Heading_04 = TextStyle(
    fontFamily: 'IBMPlexSansKR',
    fontWeight: FontWeight.w700,
    fontSize: 12.sp); //-3
final TextStyle m_Heading_05 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w700, fontSize: 24.sp);

final TextStyle Button_01 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w600, fontSize: 28.sp);
final TextStyle Button_02 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w600, fontSize: 22.sp);
final TextStyle Button_03 = TextStyle(
    fontFamily: 'IBMPlexSansKR',
    fontWeight: FontWeight.w500,
    fontSize: 16.sp); // -4

final TextStyle m_Button_00 = TextStyle(
    fontFamily: 'IBMPlexSansKR',
    fontWeight: FontWeight.w700,
    fontSize: 14.sp); // -4
final TextStyle m_Button_01 = TextStyle(
    fontFamily: 'IBMPlexSansKR',
    fontWeight: FontWeight.w600,
    fontSize: 10.sp); // -6
final TextStyle m_Button_02 = TextStyle(
    fontFamily: 'IBMPlexSansKR',
    fontWeight: FontWeight.w600,
    fontSize: 7.sp); //-4
final TextStyle m_Button_03 = TextStyle(
    fontFamily: 'IBMPlexSansKR', fontWeight: FontWeight.w600, fontSize: 14.sp);

TextStyle Body_01 = TextStyle(
    fontFamily: 'NotoSansKR',
    fontWeight: FontWeight.w500,
    fontSize: 16.sp); // - 6
TextStyle Body_02 = TextStyle(
    fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500, fontSize: 14.sp);
TextStyle Body_03 = TextStyle(
    fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500, fontSize: 18.sp);
TextStyle Body_04 = TextStyle(
    fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500, fontSize: 30.sp);

TextStyle m_Body_01 = TextStyle(
    fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500, fontSize: 16.sp);
TextStyle m_Body_02 = TextStyle(
    fontFamily: 'NotoSansKR', fontWeight: FontWeight.w500, fontSize: 14.sp);

final textButtonStyle = ButtonStyle(
  minimumSize: MaterialStateProperty.all<Size>(Size(40.w, 5.h)),
  maximumSize: MaterialStateProperty.all<Size>(Size(120.w, 40.h)),
  backgroundColor: MaterialStateProperty.all<Color>(GREEN_200),
  foregroundColor: MaterialStateProperty.all(GREY_100),
  textStyle: MaterialStateProperty.all(const TextStyle(color: GREY_100)),
  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(45.r),
    ),
  ),
);
final formBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(5.r),
  borderSide: BorderSide(color: GREEN_200, width: 2.w),
);

final titleFormTextStyle = m_Heading_02.copyWith(color: GREY_500);
final contentFormTextStyle = m_Heading_01.copyWith(color: GREY_500);
final errorFormTextStyle = m_Heading_04.copyWith(color: TOMATO_500);

final textFormFieldStyle = InputDecorationTheme(
  border: formBorder,
  focusedBorder: formBorder,
  enabledBorder: formBorder,
  errorBorder:
      formBorder.copyWith(borderSide: BorderSide(color: TOMATO_500, width: 2.w)),
  fillColor: GREY_100,
  filled: true,
  errorStyle: errorFormTextStyle,
  hintStyle: contentFormTextStyle.copyWith(color: GREEN_400),
);
