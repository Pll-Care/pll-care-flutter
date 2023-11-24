import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/common/login_platform.dart';

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

  void signInWithKakao() async {
    // 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
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
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void restApiLogin() async {
    // 카카오 로그인 구현 예제
    log("rest api login");

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
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
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              ? _logoutButton()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _loginButton(
                      'kakao_logo',
                      restApiLogin,
                      // signInWithKakao,
                    ),
                    Card(
                      elevation: 5.0,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: Ink.image(
                        image: AssetImage('assets/images/login/kakao_logo.png'),
                        width: 60,
                        height: 60,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(35.0),
                          ),
                          onTap: () async {
                            final User userProfile = await UserApi.instance.me();
                            final param = getSignUpParam(userProfile: userProfile);
                            log("userProfile = ${userProfile}");
                            log('param $param');
                            await ref.read(authProvider.notifier).signUp(param: param);
                            if(context.mounted) {
                              context.goNamed('home');
                            }

                            // if (await AuthApi.instance.hasToken()) {
                            //   try {
                            //     AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
                            //     print(
                            //         '토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn} ${tokenInfo.toString()}');

                            //   } catch (error) {
                            //     if (error is KakaoException && error.isInvalidTokenError()) {
                            //       print('토큰 만료 $error');
                            //     } else {
                            //       print('토큰 정보 조회 실패 $error');
                            //     }
                            //
                            //     try {
                            //       // 카카오계정으로 로그인
                            //       OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
                            //       print('로그인 성공 ${token.accessToken}');
                            //     } catch (error) {
                            //       print('로그인 실패 $error');
                            //     }
                            //   }
                            // } else {
                            //   print('발급된 토큰 없음');
                            //   try {
                            //     OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
                            //     print('로그인 성공 ${token.accessToken}');
                            //   } catch (error) {
                            //     print('로그인 실패 $error');
                            //   }
                            // }
                          },
                        ),
                      ),
                    )

                  ],
                )),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('assets/images/login/$path.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}

const redirectUri = "http://59.6.152.30:8080/api/login/oauth2/kakao";
const requestUrl = "http://59.6.152.30:8080/api/oauth2/authorization/kakao";
const clientId = "0561aec6f0dfa0b45d48e2bc97941e06";
