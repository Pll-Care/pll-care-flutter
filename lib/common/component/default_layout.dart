import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/model/member_model.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/common/component/default_drawer.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

import '../../home_screen.dart';
import '../../post/view/post_screen.dart';
import '../../profile/model/profile_model.dart';
import '../../project/view/project_list_screen.dart';
import '../model/default_model.dart';

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

  Widget? _getDraw(BaseModel? model, WidgetRef ref) {
    if (model is MemberModel) {
      return DefaultDrawer(
        memberId: model.memberId,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(memberProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: false,
      endDrawer: _getDraw(model, ref),
      body: SafeArea(
        child: widget.body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            final isLogin =
            ref.read(memberProvider.notifier).checkLogin(context);
            if(!isLogin){
              return;
            }
            context.goNamed(ProjectListScreen.routeName);
          } else if (index == 1) {
            context.goNamed(HomeScreen.routeName);
          } else {
            context.goNamed(PostScreen.routeName);
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
