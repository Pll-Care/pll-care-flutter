import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/common/component/default_flash.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/common/component/tech_stack_icon.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/post/component/skeleton/post_detail_skeleton.dart';
import 'package:pllcare/post/param/post_param.dart';
import 'package:pllcare/post/provider/post_provider.dart';
import 'package:pllcare/theme.dart';

import '../../auth/provider/auth_provider.dart';
import '../../management/model/team_member_model.dart';
import '../../util/model/techstack_model.dart';
import '../model/post_model.dart';
import '../view/post_screen.dart';

class PostDetailBody extends ConsumerWidget {
  final int postId;

  const PostDetailBody({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(postProvider(
        PostProviderParam(type: PostProviderType.get, postId: postId)));
    if (model is LoadingModel) {
      return const CustomSkeleton(skeleton: PostDetailSkeleton());
    }
    model as PostModel;
    return CustomScrollView(
      slivers: [PostDetailComponent.fromModel(model: model)],
    );
  }
}

class PostDetailComponent extends ConsumerStatefulWidget {
  final int postId;
  final int projectId;
  final String projectTitle;
  final String projectImageUrl;
  final String author;
  final String authorImageUrl;
  final String title;
  final String description;
  final String recruitStartDate;
  final String recruitEndDate;
  final String reference;
  final String contact;
  final String region;
  final List<TechStackModel> techStackList;
  final PositionType? applyPosition;
  final List<RecruitModel> recruitInfoList;
  final String writeDate;
  final int likeCount;
  final bool liked;
  final bool editable;
  final bool deletable;

  const PostDetailComponent({
    super.key,
    required this.postId,
    required this.projectId,
    required this.projectTitle,
    required this.projectImageUrl,
    required this.author,
    required this.authorImageUrl,
    required this.title,
    required this.description,
    required this.recruitStartDate,
    required this.recruitEndDate,
    required this.reference,
    required this.contact,
    required this.region,
    required this.techStackList,
    required this.applyPosition,
    required this.recruitInfoList,
    required this.writeDate,
    required this.likeCount,
    required this.liked,
    required this.editable,
    required this.deletable,
  });

  factory PostDetailComponent.fromModel({required PostModel model}) {
    final format = DateFormat('yyyy.MM.dd HH:mm');
    late final String writeDate;
    if (model.createdDate == model.modifiedDate) {
      writeDate = '${format.format(DateTime.parse(model.createdDate))} 작성';
    } else {
      writeDate = '${format.format(DateTime.parse(model.modifiedDate))} (수정)';
    }
    return PostDetailComponent(
      postId: model.postId,
      projectId: model.projectId,
      projectTitle: model.projectTitle,
      projectImageUrl: model.projectImageUrl ?? '',
      author: model.author,
      authorImageUrl: model.authorImageUrl,
      title: model.title,
      description: model.description,
      recruitStartDate: model.recruitStartDate,
      recruitEndDate: model.recruitEndDate,
      reference: model.reference,
      contact: model.contact,
      region: model.region.name,
      techStackList: model.techStackList,
      applyPosition: model.applyPosition,
      recruitInfoList: model.recruitInfoList,
      writeDate: writeDate,
      likeCount: model.likeCount,
      liked: model.liked,
      editable: model.editable,
      deletable: model.deletable,
    );
  }

  @override
  ConsumerState<PostDetailComponent> createState() =>
      _PostDetailComponentState();
}

class _PostDetailComponentState extends ConsumerState<PostDetailComponent> {
  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      thickness: 2.h,
      color: GREY_400,
      height: 30.h,
    );
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.projectImageUrl.isNotEmpty
                      ? NetworkImage(widget.projectImageUrl)
                      : const AssetImage('assets/main/main1.png')
                          as ImageProvider,
                  radius: 20.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                      color: GREY_500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.writeDate,
                      style: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_500),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '좋아요 ${widget.likeCount}개',
                      style: Theme.of(context)
                  .textTheme
                  .headlineSmall!.copyWith(color: GREY_500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.editable)
                      TextButton(
                          onPressed: () {
                            Map<String, String> queryParameters = {
                              'postId': widget.postId.toString()
                            };
                            context.pushNamed(PostFormScreen.routeName,
                                queryParameters: queryParameters);
                          },
                          child: const Text('수정')),
                    SizedBox(width: 8.w),
                    if (widget.deletable)
                      TextButton(
                          onPressed: () async {
                            final model = await ref
                                .read(postProvider(PostProviderParam(
                                        type: PostProviderType.delete,
                                        postId: widget.postId))
                                    .notifier)
                                .deletePost();
                            if (model is CompletedModel && context.mounted) {
                              context.pop();
                            } else if (model is ErrorModel && context.mounted) {
                              DefaultFlash.showFlash(
                                  context: context,
                                  type: FlashType.fail,
                                  content: model.message);
                            }
                          },
                          child: const Text('삭제')),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: GREEN_200, width: 2.w),
                  color: GREY_100,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.1),
                        blurRadius: 30.r,
                        offset: Offset(0, 10.h)),
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
              child: Column(
                children: [
                  _PostField(
                    fieldName: '모집글 작성자',
                    content: widget.author,
                  ),
                  SizedBox(height: 9.h),
                  _PostField(
                    fieldName: '모집 기간',
                    content:
                        '${widget.recruitStartDate} ~ ${widget.recruitEndDate}',
                  ),
                  SizedBox(height: 9.h),
                  _PostField(
                    fieldName: '모집 지역',
                    content: widget.region,
                  ),
                  divider,
                  _PostPositionField(
                    recruitInfoList: widget.recruitInfoList,
                    postId: widget.postId,
                    applyPosition: widget.applyPosition,
                  ),
                  SizedBox(height: 9.h),
                  _TechStackField(
                    techStackList: widget.techStackList,
                  ),
                  divider,
                  _ContentField(
                    fieldName: '설명',
                    content: widget.description,
                    isHtml: true,
                  ),
                  SizedBox(height: 9.h),
                  _ContentField(
                    fieldName: '레퍼런스',
                    content: widget.reference,
                  ),
                  divider,
                  _ContentField(
                    fieldName: '컨택',
                    content: widget.contact,
                  ),
                ],
              ),
            ),
            SizedBox(height: 13.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onTapLike,
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: GREEN_200, width: 2.w)),
                    child: Icon(
                      widget.liked ? Icons.favorite : Icons.favorite_border,
                      color: GREEN_200,
                      size: 32.w,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     width: 45.w,
                //     height: 45.w,
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(color: GREEN_200, width: 2.w)),
                //     child: Icon(
                //       Icons.share,
                //       color: GREEN_200,
                //       size: 32.w,
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onTapLike() {
    final isLogin = ref.read(memberProvider.notifier).checkLogin(context);
    if (!isLogin) {
      return;
    }
    ref
        .read(postProvider(PostProviderParam(
                type: PostProviderType.get, postId: widget.postId))
            .notifier)
        .likePost(postId: widget.postId, refreshList: false);
  }
}

class _PostField extends StatelessWidget {
  final String fieldName;
  final String content;

  const _PostField({super.key, required this.fieldName, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          fieldName,
          style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_400),
        ),
        Text(
          content,
          style:
              Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_500, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PostPositionField extends StatelessWidget {
  final int postId;
  final List<RecruitModel> recruitInfoList;
  final PositionType? applyPosition;

  const _PostPositionField(
      {super.key,
      required this.recruitInfoList,
      required this.postId,
      this.applyPosition});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '포지션',
          style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_400),
        ),
        SizedBox(width: 70.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...recruitInfoList
                  .where((e) => e.totalCnt != 0)
                  .map((e) => _PositionRecruitField.fromModel(
                        model: e,
                        postId: postId,
                        applyPosition: applyPosition,
                      ))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}

class _PositionRecruitField extends ConsumerWidget {
  final int postId;
  final PositionType position;
  final int currentCnt;
  final int totalCnt;
  final PositionType? applyPosition;

  const _PositionRecruitField({
    super.key,
    required this.postId,
    required this.position,
    required this.currentCnt,
    required this.totalCnt,
    required this.applyPosition,
  });

  factory _PositionRecruitField.fromModel(
      {required RecruitModel model,
      required int postId,
      required PositionType? applyPosition}) {
    return _PositionRecruitField(
      postId: postId,
      position: model.position,
      currentCnt: model.currentCnt,
      totalCnt: model.totalCnt,
      applyPosition: applyPosition,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 85.w,
            height: 40.h,
            child: Center(
              child: Text(
                position.name,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: GREY_500, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 60.w,
            child: Text(
              '$currentCnt / $totalCnt',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: GREY_500, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          if (currentCnt != totalCnt && applyPosition == null)
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 80.w,
                  height: 40.h,
                  child: OutlinedButton(
                    onPressed: () async {
                      final isLogin =
                          ref.read(memberProvider.notifier).checkLogin(context);
                      if (!isLogin) {
                        return;
                      }

                      final param = ApplyPostParam(position: position);
                      final model = await ref
                          .read(postProvider(PostProviderParam(
                                  type: PostProviderType.get, postId: postId))
                              .notifier)
                          .applyPost(param: param);
                      if (model is CompletedModel && context.mounted) {
                        DefaultFlash.showFlash(
                            context: context,
                            type: FlashType.success,
                            content: '${position.name}에 지원하였습니다.');
                      } else if (model is ErrorModel && context.mounted) {
                        DefaultFlash.showFlash(
                            context: context,
                            type: FlashType.fail,
                            content: model.message);
                      }
                    },
                    child: const Text('지원'),
                  ),
                ),
              ),
            ),
          if (currentCnt != totalCnt &&
              applyPosition != null &&
              position == applyPosition)
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 100.w,
                  height: 40.h,
                  child: OutlinedButton(
                    onPressed: () async {
                      ref
                          .read(postProvider(PostProviderParam(
                                  type: PostProviderType.get, postId: postId))
                              .notifier)
                          .applyCancelPost();
                    },
                    child: const Text('지원취소'),
                  ),
                ),
              ),
            ),
          if (currentCnt == totalCnt)
            Expanded(
              child: Center(
                child: Text('모집완료',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: GREEN_400, fontWeight: FontWeight.w800)),
              ),
            )
        ],
      ),
    );
  }
}

class _TechStackField extends StatelessWidget {
  final List<TechStackModel> techStackList;

  const _TechStackField({super.key, required this.techStackList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '기술 스택',
          style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_400),
        ),
        SizedBox(
          width: 16.w,
        ),
        Expanded(
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            alignment: WrapAlignment.end,
            children: [
              ...techStackList
                  .map(
                    (e) => TechStackIcon(
                      name: e.name,
                      imageUrl: e.imageUrl,
                      radius: 16,
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentField extends StatelessWidget {
  final String fieldName;
  final String content;
  final bool isHtml;

  const _ContentField({
    super.key,
    required this.fieldName,
    required this.content,
    this.isHtml = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          fieldName,
          style: Theme.of(context)
                .textTheme
                .headlineMedium!.copyWith(color: GREEN_400),
        ),
        SizedBox(height: 5.h),
        // if (isHtml) SingleChildScrollView(child: Html(data: content)),
        // if (!isHtml)
        Text(
          content,
          style:
              Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_500, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
