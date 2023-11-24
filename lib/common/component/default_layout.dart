import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/main/view/home.dart';
import 'package:pllcare/project/component/project_body.dart';
import 'package:pllcare/project/component/project_header.dart';
import 'package:pllcare/recruit/component/recruit_body.dart';
import 'package:pllcare/theme.dart';

import '../../home_screen.dart';
import '../../project/view/project_list_screen.dart';
import '../../recruit/view/recruit_screen.dart';
import 'default_appbar.dart';

class DefaultLayout extends ConsumerStatefulWidget {
  final bool hasInfiniteScroll;
  final Widget body;

  // final PaginationParams? paginationParams;
  // final StateNotifierProvider<PaginationProvider, CursorPaginationBase>? provider;

  static String get routeName => 'default';

  const DefaultLayout({
    super.key,
    required this.body,
    this.hasInfiniteScroll = false,
    // this.paginationParams,
    // this.provider,
  });

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout>
    with TickerProviderStateMixin {
  int _currentIdx = 1;
  late ScrollController _scrollController;
  late final TabController tabController;
  var _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {});
      });

    _scrollController = ScrollController();
    if (widget.hasInfiniteScroll) {
      _scrollController.addListener(listener);
      _scrollController.addListener(bottomHideListener);
    }
  }

  void listener() {
    // PaginationUtils.paginate(
    //     controller: _scrollController,
    //     provider: ref.read(widget.provider!.notifier),
    //     paginationParams: widget.paginationParams!);
  }

  void bottomHideListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (widget.hasInfiniteScroll) {
      _scrollController.removeListener(listener);
      _scrollController.removeListener(bottomHideListener);
    }
    super.dispose();
  }

  int getIndex(BuildContext context) {
    if (GoRouterState.of(context).matchedLocation == '/management') {
      return 0;
    } else if (GoRouterState.of(context).matchedLocation == '/home') {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: widget.body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            context.goNamed(ProjectListScreen.routeName);
          } else if (index == 1) {
            context.goNamed(HomeScreen.routeName);
          } else {
            context.goNamed(RecruitScreen.routeName);
          }
        },
        currentIndex: getIndex(context),
        selectedItemColor: GREEN_200,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.workspaces),
            label: '프로젝트 관리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '인원 모집',
          ),
        ],
      ),
    );
  }
}
