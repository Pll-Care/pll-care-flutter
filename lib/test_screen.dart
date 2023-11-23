import 'package:flutter/material.dart';
import 'package:pllcare/common/component/default_appbar.dart';

class TestScreen extends StatelessWidget {
  static String get routeName => 'test';

  TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [DefaultAppbar()];
          },
          body: CustomScrollView(slivers: [SliverToBoxAdapter(child: Text("AA"),)],),
        ),
      ),
    );
  }
}
