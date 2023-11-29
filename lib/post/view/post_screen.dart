import 'package:flutter/material.dart';

import '../../common/component/default_appbar.dart';
import '../component/post_body.dart';

class PostScreen extends StatelessWidget {
  static String get routeName => 'post';

  const PostScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
        ];
      },
      body: const PostBody(),
    );
  }
}
