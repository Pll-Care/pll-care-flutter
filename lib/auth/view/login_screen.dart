import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/common/login_platform.dart';

const kakaoException =
    'KakaoClientException: authentication token doesn\'t exist.';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';

  LoginScreen({Key? key}) : super(key: key);

  LoginPlatform _loginPlatform = LoginPlatform.none;

  AuthParameter getSignUpParam({required User userProfile}) {
    return AuthParameter(
      email: userProfile.kakaoAccount?.email ?? '',
      imageUrl: userProfile.kakaoAccount?.profile?.thumbnailImageUrl ?? '',
      name: userProfile.kakaoAccount?.profile?.nickname ?? '',
      nickName: userProfile.kakaoAccount?.profile?.nickname ?? '',
      oauth2Id: 'kakao_${userProfile.id}',
    );
  }

  void checkToken() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print(
            '토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn} ${tokenInfo.toString()}');
        final User userProfile = await UserApi.instance.me();
        log("userProfile = ${userProfile}");
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }

        try {
          // 카카오계정으로 로그인
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('로그인 성공 ${token.accessToken}');
        } catch (error) {
          print('로그인 실패 $error');
        }
      }
    } else {
      print('발급된 토큰 없음');
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('로그인 실패 $error');
      }
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }
  }

  void restApiLogin(
      {required WidgetRef ref, required BuildContext context}) async {
    // 카카오 로그인 구현 예제
    log("rest api login");
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        if (context.mounted) {
          await getTokenByOauth2Token(ref, context);
        }
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          if (context.mounted) {
            await getTokenByOauth2Token(ref, context);
          }
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        if (context.mounted) {
          await getTokenByOauth2Token(ref, context);
        }
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  restApiLogin(ref: ref, context: context);
                },
                child: Container(
                  width: 300.w,
                  height: 150.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/login/kakao_login.png'),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> getTokenByOauth2Token(
      WidgetRef ref, BuildContext context) async {
    final User userProfile = await UserApi.instance.me();
    final param = getSignUpParam(userProfile: userProfile);
    log("userProfile = ${userProfile}");
    log('param $param');
    await ref.read(authProvider.notifier).signUp(param: param);
    if (context.mounted) {
      context.goNamed('home');
    }
  }

}


