import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';

import '../../auth/model/member_model.dart';
import '../../post/provider/post_provider.dart';
import '../../post/view/post_screen.dart';
import '../../theme.dart';
import '../model/profile_apply_model.dart';

typedef ProfilePostTap = void Function(BuildContext context, int postId);

class ProfilePostCard extends StatelessWidget {
  final int postId;
  final String title;
  final String desc;
  final ProfilePostTap onTap;
  final bool isApplyCard;

  const ProfilePostCard(
      {super.key,
      required this.postId,
      required this.title,
      required this.desc,
      required this.onTap,
      required this.isApplyCard});

  factory ProfilePostCard.fromModel(
      {required ProfileApplyModel model,
      required ProfilePostTap onTap,
      bool isApplyCard = false}) {
    return ProfilePostCard(
      postId: model.postId,
      title: model.title,
      desc: model.description,
      onTap: onTap,
      isApplyCard: isApplyCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context, postId),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: GREEN_200,
            width: 2.w,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isApplyCard)
                        SizedBox(
                          width: 8.w,
                        ),
                      if (isApplyCard)
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref,
                              Widget? child) {
                            return TextButton(
                                onPressed: () {
                                  final member =
                                      ref.read(memberProvider) as MemberModel;
                                  ref
                                      .read(postProvider(PostProviderParam(
                                              type: PostProviderType.applyCancel,
                                              postId: postId))
                                          .notifier)
                                      .applyCancelPost();
                                  ref
                                      .read(profilePostProvider(
                                              type: ProfileProviderType.apply,
                                              memberId: member.memberId)
                                          .notifier)
                                      .applyCancel(postId: postId);
                                },
                                child: Text('지원취소'));
                          },
                        )
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    desc,
                    style: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREEN_500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
