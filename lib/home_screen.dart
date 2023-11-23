import 'package:flutter/material.dart';

import 'common/component/default_appbar.dart';
import 'main/view/home.dart';

class HomeScreen extends StatelessWidget {
  static String get routeName => 'home';

  const HomeScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
        ];
      },
      body: const HomeBody(),
    );
  }
}
