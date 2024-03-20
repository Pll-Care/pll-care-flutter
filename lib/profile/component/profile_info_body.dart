import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/auth/model/member_model.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/profile/param/profile_param.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

final contactFormKey = GlobalKey<FormState>();

class ProfileInfoBody extends StatelessWidget {
  final int memberId;

  const ProfileInfoBody({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          sliver: SliverMainAxisGroup(slivers: [
            SliverToBoxAdapter(
              child: Text(
                '개인정보',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20.sp,
                  color: GREEN_500,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 14.h)),
            _ContactForm(),
            SliverToBoxAdapter(
              child: Container(),
            ),
          ]),
        ),
      ],
    );
  }
}

class _ContactForm extends ConsumerWidget {
  const _ContactForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: GREEN_200, width: 2.w));
    final padding = EdgeInsets.symmetric(vertical: 13.h, horizontal: 12.w);
    final formPadding = EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w);
    final formDecoration = InputDecoration(
      contentPadding: formPadding,
      constraints: BoxConstraints.loose(Size(100.w, 40.h)),
    );
    return SliverToBoxAdapter(
      child: Form(
        key: contactFormKey,
        child: Container(
          padding: padding,
          decoration: decoration,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '연락처',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 20.sp,
                      color: GREEN_500,
                    ),
                  ),
                  TextButton(
                    onPressed: ()  async {
                      final memberId =
                          (ref.read(memberProvider) as MemberModel).memberId;
                      final contact =
                          Contact(email: '', github: '', websiteUrl: '');
                      final PatchProfileParam param =
                          PatchProfileParam(contact: contact);
                      final result = await ref.read(
                          profileEditProvider(memberId: memberId, param: param)
                              .future);
                    },
                    child: const Text(
                      '수정하기',
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 70.w,
                    child: Text(
                      'E-mail',
                      style: Theme.of(context)
                .textTheme
                .headlineMedium!,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: TextFormField(
                    decoration: formDecoration,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                    },
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      '@',
                      style: Theme.of(context)
                .textTheme
                .headlineMedium!,
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                    decoration: formDecoration,
                    textInputAction: TextInputAction.next,
                  )),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(
                    width: 70.w,
                    child: Text(
                      'GitHub',
                      style: Theme.of(context)
                .textTheme
                .headlineMedium!,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: formDecoration,
                  )),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(
                    width: 70.w,
                    child: Text(
                      'WebSite',
                      style: Theme.of(context)
                .textTheme
                .headlineMedium!,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: TextFormField(
                    decoration: formDecoration,
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
