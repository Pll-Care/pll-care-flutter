import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/profile/model/profile_model.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

import '../../auth/model/member_model.dart';
import '../../auth/provider/auth_provider.dart';
import '../../auth/view/login_screen.dart';
import '../../common/model/default_model.dart';
import '../view/profile_screen.dart';

class ProfileAppBar extends ConsumerStatefulWidget {
  final int memberId;
  final ScrollController scrollController;
  final TabController tabController;

  const ProfileAppBar({
    super.key,
    required this.memberId,
    required this.scrollController,
    required this.tabController,
  });

  @override
  ConsumerState<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends ConsumerState<ProfileAppBar> {
  bool lastStatus = true;
  double height = 150.h;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    widget.scrollController.dispose();
    super.dispose();
  }

  bool get _isShrink {
    return widget.scrollController.hasClients &&
        widget.scrollController.offset > (height - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(authProvider);

    return SliverAppBar(
      expandedHeight: 200.h,
      backgroundColor: GREEN_200,
      flexibleSpace:
          !_isShrink ? _ProfileInfo(memberId: widget.memberId) : null,
      actions: [
        if (isLogin == null)
          Container(
            width: 85.w,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: TextButton(
              onPressed: () {
                isLogin == null
                    ? context.pushNamed(LoginScreen.routeName)
                    : ref.read(authProvider.notifier).logout();
              },
              style: TextButton.styleFrom(
                backgroundColor: GREY_100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              child: Text(
                isLogin == null ? 'Log In' : 'Log Out',
                style: m_Button_00.copyWith(color: GREEN_200),
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
                    radius: 18.r,
                    backgroundImage: NetworkImage(model.imageUrl),
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
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  visualDensity: VisualDensity.compact),
              icon: Icon(
                Icons.menu,
                color: GREY_100,
                size: 40.r,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileInfo extends ConsumerWidget {
  final int memberId;

  const _ProfileInfo({
    super.key,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final model = ref.watch(profileIntroProvider(memberId: memberId));
        if (model is ProfileIntroModel) {
          return FlexibleSpaceBar(
            titlePadding:
                EdgeInsets.symmetric(vertical: 22.h, horizontal: 20.w),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(model.imageUrl),
                ),
                SizedBox(width: 14.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: m_Heading_01.copyWith(color: GREY_100),
                    ),
                    Row(
                      children: [
                        Text(
                          model.bio,
                          style: m_Heading_03.copyWith(color: GREY_100),
                        ),
                        SizedBox(width: 12.w),
                        // SizedBox(
                        //   height: 25.h,
                        //   width: 45.w,
                        //   child: OutlinedButton(
                        //     onPressed: () {},
                        //     style: OutlinedButton.styleFrom(
                        //       backgroundColor: GREEN_200,
                        //       side: BorderSide(color: GREY_100, width: 2.w),
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 8.w, vertical: 2.h),
                        //       maximumSize: Size(60.w, 30.h),
                        //     ),
                        //     child: Text(
                        //       '수정',
                        //       style: m_Heading_04.copyWith(color: GREY_100),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  ProfileTabBarDelegate({
    required this.tabController,
  });

  Widget _profileTabBar({required IconData icon, required bool isSelected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isSelected ? 60.r : 40.r,
      width: isSelected ? 60.r : 40.r,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
          color: isSelected ? GREEN_500 : GREEN_200,
          borderRadius: BorderRadius.circular(
        12.r,
      )),
      child: Container(
        decoration: BoxDecoration(
            // color: isSelected ? GREEN_500 : GREEN_200,
            borderRadius: BorderRadius.circular(
          12.r,
        )),
        child: Icon(
          icon,
          color: GREY_100,
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Container(
          color: GREEN_200,
          child: Container(
            decoration: BoxDecoration(
              color: GREY_100,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.r),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              onTap: (idx) {
                tabController.animateTo(idx);
              },
              tabs: [
                _profileTabBar(
                    isSelected: tabController.index == 0, icon: Icons.person),
                _profileTabBar(
                    isSelected: tabController.index == 1,
                    icon: Icons.layers_outlined),
                _profileTabBar(
                    isSelected: tabController.index == 2, icon: Icons.star),
                _profileTabBar(
                    isSelected: tabController.index == 3, icon: Icons.favorite),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 70.h;

  @override
  double get minExtent => 70.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
