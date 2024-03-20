import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pllcare/common/provider/provider_observer.dart';
import 'package:pllcare/theme.dart';

import 'config/router_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '4f2e05ad16de5afc28b263da1980b5a1',
    javaScriptAppKey: 'af256746c2a504b44720df430decd9d3',
  );
  await initializeDateFormatting('ko');
  runApp(
    ProviderScope(
      observers: [
        CustomProviderObserver(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  TextTheme _getTextTheme() {
    return TextTheme(
      headlineLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 22.sp),
      headlineMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16.sp),
      headlineSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 14.sp),
      titleLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w900,
          fontSize: 18.sp),
      titleMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16.sp),
      titleSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 20.sp),
      labelLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp),
      labelMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      labelSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 12.sp),
      displayLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp),
      displayMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 14.sp),
      displaySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 10.sp),
    );
  }

  ButtonStyle _getTextButtonStyle() {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(Size(48.w, 48.h)),
      maximumSize: MaterialStateProperty.all<Size>(Size(120.w, 48.h)),
      backgroundColor: MaterialStateProperty.all<Color>(GREEN_200),
      foregroundColor: MaterialStateProperty.all(GREY_100),
      textStyle: MaterialStateProperty.all(TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: GREY_100)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.r),
        ),
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle() {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(Size(48.w, 48.h)),
      maximumSize: MaterialStateProperty.all<Size>(Size(120.w, 48.h)),
      backgroundColor: MaterialStateProperty.all<Color>(GREY_100),
      foregroundColor: MaterialStateProperty.all(GREEN_200),
      textStyle: MaterialStateProperty.all(TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: GREEN_200)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h)),
      side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: GREEN_200, width: 2.w)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.r),
          side: BorderSide(color: GREEN_200, width: 2.w),
        ),
      ),
    );
  }

  InputDecorationTheme _getInputDecorationTheme() {
    final formBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide(color: GREEN_200, width: 2.w),
    );
    return InputDecorationTheme(
      border: formBorder,
      focusedBorder: formBorder,
      enabledBorder: formBorder,
      errorBorder: formBorder.copyWith(
          borderSide: BorderSide(color: TOMATO_500, width: 2.w)),
      fillColor: GREY_100,
      filled: true,
      errorStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
        fontSize: 12.sp,
        color: TOMATO_500,
      ),
      hintStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: GREEN_400),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // log("MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}");
    // log("MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}");
    final router = ref.read(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(432, 960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'PLL-CARE',
          theme: ThemeData(
            fontFamily: 'Pretendard',
            primaryColor: GREEN_200,
            splashFactory: NoSplash.splashFactory,
            textTheme: _getTextTheme(),
            iconTheme: const IconThemeData(color: GREEN_200),
            outlinedButtonTheme:
                OutlinedButtonThemeData(style: _getOutlinedButtonStyle()),
            textButtonTheme: TextButtonThemeData(
              style: _getTextButtonStyle(),
            ),
            inputDecorationTheme: _getInputDecorationTheme(),
          ),
          routerConfig: router,
        );
      },
      // child: const HomeScreen(), // LoginScreen(),
    );
  }
}
