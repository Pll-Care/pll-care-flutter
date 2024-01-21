import 'package:flutter/material.dart';

import '../../common/component/default_appbar.dart';
import '../component/post_body.dart';
import '../component/post_form.dart';

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

class PostFormScreen extends StatelessWidget {
  static String get routeName => 'postForm';
  final int postId;

  const PostFormScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
        ];
      },
      body: PostForm(
        postId: postId,
      ),
    );
  }
}
