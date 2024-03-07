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
          fontSize: 28.sp),
      headlineMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 22.sp),
      headlineSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 20.sp),
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
                OutlinedButtonThemeData(style: outlinedButtonStyle),
            textButtonTheme: TextButtonThemeData(
              style: textButtonStyle,
            ),
            inputDecorationTheme: textFormFieldStyle,
          ),
          routerConfig: router,
        );
      },
      // child: const HomeScreen(), // LoginScreen(),
    );
  }
}
