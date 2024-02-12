import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/common/component/default_drawer.dart';
import 'package:pllcare/profile/component/profile_appbar.dart';
import 'package:pllcare/profile/component/profile_apply_body.dart';
import 'package:pllcare/profile/component/profile_eval_body.dart';
import 'package:pllcare/profile/component/profile_favorite_body.dart';
import 'package:pllcare/profile/component/profile_info_body.dart';

import '../../theme.dart';

class ProfileScreen extends StatefulWidget {
  final int memberId;

  static String get routeName => 'profile';

  const ProfileScreen({super.key, required this.memberId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DefaultDrawer(
        memberId: widget.memberId,
      ),
      body: SafeArea(
        child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (_, __) {
              return [
                ProfileAppBar(
                  memberId: widget.memberId,
                  scrollController: _scrollController,
                  tabController: _tabController,
                ),
                SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: ProfileTabBarDelegate(
                      tabController: _tabController,
                    )),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                ProfileInfoBody(memberId: widget.memberId),
                ProfileEvalBody(memberId: widget.memberId),
                ProfileApplyBody(memberId: widget.memberId),
                ProfileFavoriteBody(memberId: widget.memberId),
              ],
            )),
      ),
    );
  }
}
