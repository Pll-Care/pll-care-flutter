import 'package:flutter/material.dart';
import 'package:pllcare/recruit/component/recruit_body.dart';

import '../../common/component/default_appbar.dart';

class RecruitScreen extends StatelessWidget {
  static String get routeName => 'recruit';


  const RecruitScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const DefaultAppbar(),
        ];
      },
      body:  const RecruitBody(),
    );
  }
}
