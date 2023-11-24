import 'package:flutter/material.dart';
import 'package:pllcare/project/component/project_body.dart';

import '../../common/component/default_appbar.dart';

class ProjectListScreen extends StatelessWidget {
  static String get routeName => 'project';

  const ProjectListScreen({
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
      body: ProjectBody(),

      // ProjectBody(),
    );
  }
}
