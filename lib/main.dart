import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pllcare/auth/view/login_screen.dart';
import 'package:pllcare/common/provider/provider_observer.dart';
import 'package:pllcare/theme.dart';
import 'package:pllcare/main/view/home.dart';

import 'config/router_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '4f2e05ad16de5afc28b263da1980b5a1',
    javaScriptAppKey: 'af256746c2a504b44720df430decd9d3',
  );
  runApp(
    ProviderScope(
      observers: [CustomProviderObserver(),],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // log("MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}");
    // log("MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}");
    final router = ref.read(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(411.42857142857144, 867.4285714285714),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'PLL-CARE',
          theme: ThemeData(
            fontFamily: 'NotoSansKR',
            primaryColor: GREEN_200,
            splashFactory: NoSplash.splashFactory,
            iconTheme: const IconThemeData(color: GREEN_200),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(GREEN_200),
                foregroundColor: MaterialStateProperty.all(GREY_100),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(color: GREY_100)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
              ),
            ),
          ),
          routerConfig: router,
        );
      },
      // child: const HomeScreen(), // LoginScreen(),
    );
  }
}
