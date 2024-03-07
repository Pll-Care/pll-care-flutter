import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/auth/view/login_screen.dart';
import 'package:pllcare/profile/view/profile_screen.dart';

import '../../auth/model/member_model.dart';
import '../../theme.dart';
import '../model/default_model.dart';

class DefaultAppbar extends ConsumerWidget {
  // final List<Widget>? actions;
  // final List<Map<String, dynamic>>? actions;

  const DefaultAppbar({
    super.key,
    // this.actions,
  });

  Widget getLogoIcon() {
    return Image.asset(
      'assets/images/logo.png',
      width: 80.w,
      height: 48.h,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(authProvider);
    return SliverAppBar(
      leading: getLogoIcon(),
      leadingWidth: 160.w,
      backgroundColor: Colors.grey[50],
      foregroundColor: Colors.black,
      centerTitle: true,
      snap: true,
      floating: true,
      elevation: 0,
      actions: [
        if (isLogin == null)
          Container(
            width: 85.w,
            height: 48.h,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: TextButton(
              onPressed: () {
                isLogin == null
                    ? context.pushNamed(LoginScreen.routeName)
                    : ref.read(authProvider.notifier).logout();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              child: Text(
                isLogin == null ? '로그인' : 'Log Out',
                style: m_Button_00.copyWith(color: Colors.white),
              ),
            ),
          ),
        SizedBox(width: 10.w),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final model = ref.watch(memberProvider);
            if (model is MemberModel) {
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: () {
                    final Map<String, String> pathParameters = {
                      'memberId': model.memberId.toString()
                    };
                    context.pushNamed(ProfileScreen.routeName,
                        pathParameters: pathParameters);
                  },
                  child: CircleAvatar(
                    radius: 24.r,
                    backgroundImage: model.imageUrl.isNotEmpty
                        ? NetworkImage(model.imageUrl)
                        : const AssetImage('assets/main/main1.png')
                            as ImageProvider,
                  ),
                ),
              );
            } else if (model is ErrorModel) {
              ref.read(tokenProvider.notifier).logout();
            }
            return Container();
          },
        ),
        if (isLogin != null)
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: GREEN_200,
                size: 40.r,
              ),
            ),
          ),
      ],
    );
  }
}
