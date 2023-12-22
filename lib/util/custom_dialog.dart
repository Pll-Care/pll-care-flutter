import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class CustomDialog{
  static final textButtonStyle = TextButton.styleFrom(
    backgroundColor: GREY_100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(48.r),
    ),
  );
  static void showCustomDialog({
    required BuildContext context,
    required Color backgroundColor,
    Widget? content,
    List<Widget>? actions,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            backgroundColor: backgroundColor,
            content: content,
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsPadding: const EdgeInsets.only(bottom: 24),
            actions: actions,
          );
        });
  }
}