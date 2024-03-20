import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/common/component/default_flash.dart';

import '../../profile/model/profile_model.dart';
import '../../profile/provider/profile_provider.dart';
import '../../theme.dart';
import '../model/default_model.dart';

class DefaultDrawer extends ConsumerWidget {
  final int memberId;

  const DefaultDrawer({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileIntroProvider(memberId: memberId));
    String name = '';
    String bio = '';
    String imageUrl = '';
    if (profile is ProfileIntroModel) {
      name = profile.name;
      bio = profile.bio;
    }
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: Size.fromRadius(35.r),
            accountName: Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: GREY_100,
                    fontSize: 20.sp,
                  ),
            ),
            accountEmail: Text(
              bio,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: GREY_100),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/main/main1.png') as ImageProvider,
            ),
            decoration: BoxDecoration(
              color: GREEN_200,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  25.r,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextButton(
              onPressed: () async {
                ref.read(tokenProvider.notifier).logout();
                await UserApi.instance.logout();
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text('로그아웃'),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextButton(
              onPressed: () async {
                ref.read(tokenProvider.notifier).logout();
                await UserApi.instance.logout();
                await UserApi.instance.unlink();
                final result =
                    await ref.read(authProvider.notifier).withdrawal();
                if (result is CompletedModel && context.mounted) {
                  context.pop();
                } else if (result is ErrorModel && context.mounted) {
                  DefaultFlash.showFlash(
                      context: context,
                      type: FlashType.fail,
                      content: '회원탈퇴에 실패했습니다.');
                }
              },
              style: TextButton.styleFrom(backgroundColor: TOMATO_500),
              child: const Text('회원탈퇴'),
            ),
          ),
        ],
      ),
    );
  }
}
