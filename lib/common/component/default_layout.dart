import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

class DefaultLayout extends ConsumerStatefulWidget {
  final Widget appbar;
  final bool hasInfiniteScroll;
  final Widget body;

  // final PaginationParams? paginationParams;
  // final StateNotifierProvider<PaginationProvider, CursorPaginationBase>? provider;

  static String get routeName => 'default';

  const DefaultLayout({
    super.key,
    required this.appbar,
    required this.body,
    this.hasInfiniteScroll = false,
    // this.paginationParams,
    // this.provider,
  });

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout>
    with SingleTickerProviderStateMixin {
  int _currentIdx = 0;
  late ScrollController _scrollController;
  var _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = true;

    if (widget.hasInfiniteScroll) {
      _scrollController = ScrollController();
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
    if (widget.hasInfiniteScroll) {
      _scrollController.removeListener(listener);
      _scrollController.removeListener(bottomHideListener);
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: NestedScrollView(
          // controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              widget.appbar,
            ];
          },
          body: widget.body,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            _currentIdx = index;
          });
        },
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
        currentIndex: _currentIdx,
      ),
    );
  }
}
