import 'dart:developer';

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

class PostFormScreen extends StatefulWidget {
  static String get routeName => 'postForm';
  final int? postId;

  const PostFormScreen({
    super.key,
    this.postId,
  });

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(removeFocus);
  }

  void removeFocus() {
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    _controller.removeListener(removeFocus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      /// controller 주입 시 scrollable.ensureVisible 가 자연스러워 짐
      controller: _controller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
        ];
      },
      body: CustomScrollView(
        slivers: [
          PostFormComponent(
            postId: widget.postId,
          )
        ],
      ),
    );
  }
}
