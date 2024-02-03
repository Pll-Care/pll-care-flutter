import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

enum FlashType { success, fail }

class DefaultFlash {
  static void showFlash(
      {required BuildContext context,
      required FlashType type,
      required String content}) {
    late Widget widget;
    late BorderSide side;
    switch (type) {
      case FlashType.success:
        widget = getSuccess(content: content);
        side = BorderSide(color: GREEN_200, width: 2.w);
        break;
      default:
        widget = getFail(content: content);
        side = BorderSide(color: TOMATO_500, width: 3.w);
        break;
    }
    context.showFlash(
        duration: const Duration(milliseconds: 1100),
        builder: (BuildContext context, FlashController controller) {
          return FlashBar(
            // position:  FlashPosition.top,
            behavior: FlashBehavior.floating,
            margin: EdgeInsets.only(bottom: 80.h, right: 50.w, left: 50.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20.r,
              ),
              side: side,
            ),
            controller: controller,
            content: widget,
          );
        });
  }

  static Widget getSuccess({required String content}) {
    return Text(
      content,
      style: Button_03.copyWith(color: GREY_500, fontWeight: FontWeight.w700),
    );
    return Container(
      width: 200.w,
      height: 60.h,
      child: Text(
        content,
        style: m_Body_01.copyWith(color: GREY_500),
      ),
    );
  }

  static Widget getFail({required String content}) {
    return Text(
      content,
      style: Button_03.copyWith(color: GREY_500, fontWeight: FontWeight.w700),
    );
    return Container(
      width: 200.w,
      height: 60.h,
      // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        content,
        style: Button_03.copyWith(color: GREY_500, fontWeight: FontWeight.w700),
      ),
    );
  }
}
