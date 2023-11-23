import 'package:flutter/material.dart';

class RecruitBody extends StatelessWidget {

  const RecruitBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("AA");


    return CustomScrollView(
      slivers: [
        SliverFillRemaining(child: Text("AA"),),
      ],
    );
  }
}
