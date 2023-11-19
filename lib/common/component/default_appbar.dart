import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/auth/view/login_screen.dart';

import '../../theme.dart';

class DefaultAppbar extends ConsumerWidget {
  // final List<Widget>? actions;
  final List<Map<String, dynamic>>? actions;

  const DefaultAppbar({
    super.key,
    this.actions,
  });

  Widget getLogoIcon() {
    return Image.asset(
      'assets/images/logo2.png',
      width: 80.w,
      height: 20.h,
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
        Container(
          width: 80.w,
          padding: EdgeInsets.symmetric(vertical: 12.h),
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
              isLogin == null ? 'Log In' : 'Log Out',
              style: m_Button_00.copyWith(color: Colors.white),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: GREEN_200,
          ),
        ),
      ],
    );
  }
}
