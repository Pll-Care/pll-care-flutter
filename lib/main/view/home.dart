import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pllcare/common/common_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 88.w,
        toolbarHeight: 100,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Image.asset(
            'assets/images/logo2.png',
            width: 80.w,
            height: 20.h,
            fit: BoxFit.fitWidth,
          ),
        ),
        actions: [
          Container(
            height: 50,
            color: Colors.black,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Container(
                color: Colors.red,
                child: Text(
                  'Log In',
                  style: m_Button_00.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Image.asset(
              'assets/menu/menu1.png',
              width: 20.w,
              height: 20.h,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SvgPicture.asset('assets/main/main1.svg'),
        ],
      ),
    );
  }
}
