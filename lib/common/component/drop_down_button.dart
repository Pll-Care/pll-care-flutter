import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/theme.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  final List<T> items;
  final T initValue;
  final ValueChanged<T?> onChanged;

  const CustomDropDownButton(
      {super.key, required this.onChanged, required this.items, required this.initValue});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: BorderSide(
        color: GREEN_200,
        width: 2.w,
      ),
    );
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
        iconEnabledColor: GREEN_200,
        value: initValue,
        decoration: InputDecoration(
          constraints: BoxConstraints.loose(Size(120.w, 35.h)),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          border: border,
          focusedBorder: border,
          enabledBorder: border,
        ),
        isExpanded: true,
        borderRadius: BorderRadius.circular(15.r),
        items: [
          ...items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$e',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: GREEN_400),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
