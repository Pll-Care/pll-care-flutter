import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/common_style.dart';

import 'main/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // log("MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}");
    // log("MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}");
    return ScreenUtilInit(
      designSize: const Size(411.42857142857144, 867.4285714285714),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PLL-CARE',
          theme: ThemeData(
            fontFamily: 'NotoSansKR',
            primaryColor: GREEN_200,
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(GREEN_200),
                textStyle: MaterialStateProperty.all(TextStyle(color: GREY_100)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
            ),
          ),
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}
