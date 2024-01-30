import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/post/provider/post_provider.dart';
import 'package:pllcare/theme.dart';

import '../../management/model/team_member_model.dart';
import '../model/post_model.dart';

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
      return CircularProgressIndicator();
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
  final List<TechStack> techStackList;
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
      region: model.region.toString(),
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
                      ? NetworkImage(
                          widget.projectImageUrl,
                        )
                      : null,
                  radius: 20.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    widget.title,
                    style: m_Heading_05.copyWith(color: GREY_500),
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
                      style: m_Heading_03.copyWith(color: GREY_500),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '좋아요 ${widget.likeCount}개',
                      style: m_Heading_03.copyWith(color: GREY_500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // if(editable)
                    TextButton(onPressed: () {}, child: const Text('수정')),
                    SizedBox(width: 8.w),
                    // if(deletable)
                    TextButton(onPressed: () {}, child: const Text('삭제')),
                  ],
                ),
              ],
            ),
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
                    width: 45.w,
                    height: 45.w,
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: GREEN_200, width: 2.w)),
                    child: Icon(
                      Icons.share,
                      color: GREEN_200,
                      size: 32.w,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onTapLike() {
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
          style: m_Heading_01.copyWith(color: GREEN_400),
        ),
        Text(
          content,
          style:
              m_Body_01.copyWith(color: GREY_500, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PostPositionField extends StatelessWidget {
  final List<RecruitModel> recruitInfoList;

  const _PostPositionField({super.key, required this.recruitInfoList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '포지션',
          style: m_Heading_01.copyWith(color: GREEN_400),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...recruitInfoList
                  .where((e) => e.totalCnt != 0)
                  .map((e) => _PositionRecruitField.fromModel(model: e))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}

class _PositionRecruitField extends StatelessWidget {
  final String positionName;
  final int currentCnt;
  final int totalCnt;

  const _PositionRecruitField(
      {super.key,
      required this.positionName,
      required this.currentCnt,
      required this.totalCnt});

  factory _PositionRecruitField.fromModel({required RecruitModel model}) {
    return _PositionRecruitField(
      positionName: model.position.name,
      currentCnt: model.currentCnt,
      totalCnt: model.totalCnt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 85.w,
            child: Text(
              positionName,
              style: m_Body_01.copyWith(
                  color: GREY_500, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 60.w,
            child: Text(
              '$currentCnt / $totalCnt',
              style: m_Body_01.copyWith(
                  color: GREY_500, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          if (currentCnt != totalCnt)
            SizedBox(
              width: 60.w,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('지원'),
              ),
            ),
          if (currentCnt == totalCnt)
            SizedBox(
              width: 60.w,
              child: Text('모집완료',
                  style: m_Body_01.copyWith(
                      color: GREEN_400, fontWeight: FontWeight.w800)),
            )
        ],
      ),
    );
  }
}

class _TechStackField extends StatelessWidget {
  final List<TechStack> techStackList;

  const _TechStackField({super.key, required this.techStackList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '기술 스택',
          style: m_Heading_01.copyWith(color: GREEN_400),
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
                    (e) => Tooltip(
                      message: e.name,
                      textStyle: m_Body_01.copyWith(color: GREY_100),
                      showDuration: const Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.longPress,
                      child: CircleAvatar(
                        maxRadius: 16.r,
                        backgroundColor: Colors.transparent,
                        child: e.imageUrl.endsWith('.svg')
                            ? SvgPicture.network(e.imageUrl)
                            : Image.network(e.imageUrl, scale: 16.r),
                      ),
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
          style: m_Heading_01.copyWith(color: GREEN_400),
        ),
        SizedBox(height: 5.h),
        // if (isHtml) SingleChildScrollView(child: Html(data: content)),
        // if (!isHtml)
        Text(
          content,
          style:
              m_Body_01.copyWith(color: GREY_500, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
