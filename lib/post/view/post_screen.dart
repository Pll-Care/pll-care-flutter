import 'package:flutter/material.dart';
import 'package:pllcare/post/component/post_form.dart';

import '../../common/component/default_appbar.dart';
import '../component/post_body.dart';
import '../component/post_detail.dart';

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

class PostDetailScreen extends StatelessWidget {
  static String get routeName => 'postDetail';
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
        ];
      },
      body: PostDetailBody(
        postId: postId,
      ),
    );
  }
}

class PostFormScreen extends StatelessWidget {
  static String get routeName => 'postForm';

  const PostFormScreen({
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
      body: CustomScrollView(
        slivers: [PostFormComponent()],
      ),
    );
  }
}
