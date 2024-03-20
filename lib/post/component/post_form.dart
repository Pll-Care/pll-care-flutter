import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pllcare/common/component/drop_down_button.dart';
import 'package:pllcare/post/provider/post_provider.dart';
import 'package:pllcare/post/provider/widget/post_form_provider.dart';
import 'package:pllcare/project/component/project_form.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';
import 'package:collection/collection.dart';
import 'package:pllcare/util/provider/util_provider.dart';
import '../../common/component/default_flash.dart';
import '../../common/component/tech_stack_icon.dart';
import '../../common/model/default_model.dart';
import '../../management/model/team_member_model.dart';
import '../../schedule/provider/date_range_provider.dart';
import '../../util/model/techstack_model.dart';
import '../model/post_model.dart';
import '../param/post_param.dart';

class PostFormComponent extends ConsumerStatefulWidget {
  final int? postId;

  const PostFormComponent({
    super.key,
    this.postId,
  });

  @override
  ConsumerState<PostFormComponent> createState() => _PostFormComponentState();
}

class _PostFormComponentState extends ConsumerState<PostFormComponent> {
  late final List<TextEditingController> textControllers = [];
  final formKey = GlobalKey<FormState>();
  late final List<FocusNode> focusNodes = [];
  late final List<GlobalKey> globalKeys = [];
  int? projectId;
  String projectTitle = '';
  String? regionInitValue;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 9; i++) {
      focusNodes.add(FocusNode());
      globalKeys.add(GlobalKey());
      textControllers.add(TextEditingController());
      focusNodes[i].addListener(() {
        onTapFocus(i);
      });
    }

    if (widget.postId != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final model = ref.read(postProvider(PostProviderParam(
            type: PostProviderType.get, postId: widget.postId))) as PostModel;
        ref.read(postFormProvider.notifier).updateFromPostModel(model: model);
        setDateRage(model);
        setTextForm(model);
        regionInitValue = model.region.name;
        projectTitle = model.projectTitle;
      });
    }
  }

  void setTextForm(PostModel model) {
    textControllers[0].text = model.title;
    textControllers[1].text = model.recruitInfoList
        .firstWhere((e) => e.position == PositionType.FRONTEND)
        .totalCnt
        .toString();
    textControllers[2].text = model.recruitInfoList
        .firstWhere((e) => e.position == PositionType.BACKEND)
        .totalCnt
        .toString();
    textControllers[3].text = model.recruitInfoList
        .firstWhere((e) => e.position == PositionType.DESIGN)
        .totalCnt
        .toString();
    textControllers[4].text = model.recruitInfoList
        .firstWhere((e) => e.position == PositionType.PLANNER)
        .totalCnt
        .toString();
    textControllers[5].text = model.description;
    textControllers[6].text = model.reference;
    textControllers[7].text = model.contact;
  }

  void setDateRage(PostModel model) {
    final startDate = DateTime.parse(model.recruitStartDate);
    final endDate = DateTime.parse(model.recruitEndDate);
    ref
        .read(dateRangeProvider.notifier)
        .updateDate(startDate: startDate, endDate: endDate);
  }

  /// 텍스트 폼 필드 클릭 시 해당 context에 화면 스크롤
  void onTapFocus(int i) {
    if (focusNodes[i].hasFocus) {
      Scrollable.ensureVisible(
        globalKeys[i].currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: .1,
      );
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 9; i++) {
      focusNodes[i].removeListener(() {
        onTapFocus(i);
      });
      focusNodes[i].dispose();
      textControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(postFormProvider);
    ref.listen(dateRangeProvider, (previous, next) {
      UpdatePostParam? form;
      final format = DateFormat('yyyy-MM-dd');
      if (previous?.startDate != next.startDate) {
        form = ref
            .read(postFormProvider)
            .copyWith(recruitStartDate: format.format(next.startDate!));
      } else {
        form = ref
            .read(postFormProvider)
            .copyWith(recruitEndDate: format.format(next.endDate!));
      }

      ref.read(postFormProvider.notifier).updateForm(form: form);
    });
    final divider = Divider(
      thickness: 2.h,
      color: GREY_400,
      height: 30.h,
    );
    return SliverToBoxAdapter(
      child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: 20.h + MediaQuery.of(context).viewInsets.bottom),

            /// 키보드에 가려진 부분만큼 padding 추가
            child: Column(
              children: [
                TextFormField(
                  key: globalKeys[0],
                  controller: textControllers[0],
                  focusNode: focusNodes[0],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: GREY_500),
                  validator: (String? val) {
                    if (val == null || val.isEmpty) {
                      return '제목은 필수사항입니다.';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '제목을 입력해주세요.',
                    hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: GREEN_400),
                  ),
                  onChanged: (value) {
                    final form =
                        ref.read(postFormProvider).copyWith(title: value);
                    ref.read(postFormProvider.notifier).updateForm(form: form);
                  },
                ),
                SizedBox(height: 12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.postId == null)
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref,
                              Widget? child) {
                            return ref.watch(projectSimpleProvider).when(
                                data: (model) {
                                  if (model.data.isNotEmpty) {
                                    return _PostFormField(
                                      fieldName: '프로젝트 선택',
                                      initValue: model.data.first.title ?? '',
                                      dropItems: model.data
                                          .map((e) => e.title ?? '')
                                          .toList(),
                                      onChanged: (String? value) {
                                        projectId = model.data
                                            .singleWhere(
                                                (e) => e.title == value)
                                            .projectId;
                                      },
                                    );
                                  }
                                  return const Text('모집가능한 프로젝트가 없습니다.');
                                },
                                error: (_, __) {
                                  return Text('error');
                                },
                                loading: () =>
                                    const CircularProgressIndicator());
                          },
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '프로젝트',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: GREEN_400),
                            ),
                            Text(
                              projectTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: GREEN_400),
                            )
                          ],
                        ),
                      SizedBox(height: 24.h),
                      const DateForm(
                        title: '모집 기간',
                      ),
                      if (!ref.watch(dateRangeProvider.notifier).isValidate())
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.h, left: 8.w),
                          child: Text(
                            "시작일자가 종료일자와 같거나 이후 일 수 없습니다.",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: TOMATO_500),
                          ),
                        ),
                      if (!ref
                              .watch(dateRangeProvider.notifier)
                              .isSaveValidate() &&
                          ref.watch(checkDateValidateProvider))
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.h, left: 8.w),
                          child: Text(
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: TOMATO_500),
                            "시작일자와 종료일자를 선택해주세요.",
                          ),
                        ),
                      SizedBox(height: 24.h),
                      _PostFormField(
                        fieldName: '지역',
                        initValue: regionInitValue ?? '서울',
                        dropItems: Region.values.map((e) => e.name).toList(),
                        onChanged: (String? value) {
                          final region = Region.stringToEnum(region: value!);
                          final form = ref
                              .read(postFormProvider)
                              .copyWith(region: region);
                          ref
                              .read(postFormProvider.notifier)
                              .updateForm(form: form);
                        },
                      ),
                      divider,
                      _PostPositionForm(
                        focusNodes: focusNodes.sublist(1, 6),
                        globalKeys: globalKeys.sublist(1, 6),
                        textControllers: textControllers.sublist(1, 5),
                      ),
                      divider,
                      _TechStackForm(
                        focusNode: focusNodes[5],
                        globalKey: globalKeys[5],
                        onNext: () {
                          onNextFieldScroll(idx: 6);
                        },
                      ),
                      divider,
                      _MultiTextForm(
                        title: '설명',
                        controller: textControllers[5],
                        focusNode: focusNodes[6],
                        globalKey: globalKeys[6],
                        onNext: () {
                          onNextFieldScroll(idx: 7);
                        },
                        onChanged: (String value) {
                          final form = ref
                              .read(postFormProvider)
                              .copyWith(description: value);
                          ref
                              .read(postFormProvider.notifier)
                              .updateForm(form: form);
                        },
                      ),
                      divider,
                      _MultiTextForm(
                        title: '레퍼런스',
                        focusNode: focusNodes[7],
                        globalKey: globalKeys[7],
                        controller: textControllers[6],
                        onNext: () {
                          onNextFieldScroll(idx: 8);
                        },
                        onChanged: (String value) {
                          final form = ref
                              .read(postFormProvider)
                              .copyWith(reference: value);
                          ref
                              .read(postFormProvider.notifier)
                              .updateForm(form: form);
                        },
                      ),
                      divider,
                      _MultiTextForm(
                        title: '컨택',
                        focusNode: focusNodes[8],
                        globalKey: globalKeys[8],
                        controller: textControllers[7],
                        onNext: () {
                          onNextFieldScroll(idx: 8, isLast: true);
                        },
                        onChanged: (String value) {
                          final form = ref
                              .read(postFormProvider)
                              .copyWith(contact: value);
                          ref
                              .read(postFormProvider.notifier)
                              .updateForm(form: form);
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () async {
                              ref.read(checkTechValidProvider.notifier).state =
                                  true;
                              ref
                                  .read(checkPositionValidProvider.notifier)
                                  .state = true;
                              ref
                                  .read(checkDateValidateProvider.notifier)
                                  .state = true;

                              if (formKey.currentState!.validate() &&
                                  ref
                                      .read(postFormProvider.notifier)
                                      .validate() &&
                                  ref
                                      .read(dateRangeProvider.notifier)
                                      .integrationValid()) {
                                projectId ??= ref
                                    .read(projectSimpleProvider)
                                    .value
                                    ?.data
                                    .first
                                    .projectId;
                                final form = ref.read(postFormProvider);
                                final param = CreatePostParam.fromUpdateParam(
                                    projectId: projectId!, param: form);
                                late BaseModel model;

                                model = widget.postId == null
                                    ? await ref
                                        .read(postProvider(
                                                const PostProviderParam(
                                                    type: PostProviderType
                                                        .create))
                                            .notifier)
                                        .createPost(param: param)
                                    : await ref
                                        .read(postProvider(PostProviderParam(
                                                type: PostProviderType.update,
                                                postId: widget.postId))
                                            .notifier)
                                        .updatePost(param: param);

                                if (model is CompletedModel &&
                                    context.mounted) {
                                  context.pop();
                                } else if (model is ErrorModel &&
                                    context.mounted) {
                                  DefaultFlash.showFlash(
                                      context: context,
                                      type: FlashType.fail,
                                      content: model.message);
                                }
                              }
                            },
                            child:
                                Text(widget.postId == null ? '작성하기' : '수정하기')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void onNextFieldScroll({required int idx, bool isLast = false}) {
    Scrollable.ensureVisible(
      globalKeys[idx].currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: .1,
    );
    isLast
        ? focusNodes[idx].unfocus()
        : FocusScope.of(context).requestFocus(focusNodes[idx]);
  }
}

class _PostFormField extends StatelessWidget {
  final String fieldName;
  final List<String> dropItems;
  final ValueChanged<String?> onChanged;
  final String initValue;

  const _PostFormField(
      {super.key,
      required this.fieldName,
      required this.dropItems,
      required this.onChanged,
      required this.initValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            fieldName,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: GREEN_400),
          ),
        ),
        CustomDropDownButton(
          onChanged: onChanged,
          items: dropItems,
          initValue: initValue,
        ),
      ],
    );
  }
}

class _PostPositionForm extends ConsumerStatefulWidget {
  final List<FocusNode> focusNodes;
  final List<GlobalKey> globalKeys;
  final List<TextEditingController> textControllers;

  const _PostPositionForm({
    super.key,
    required this.focusNodes,
    required this.globalKeys,
    required this.textControllers,
  });

  @override
  ConsumerState<_PostPositionForm> createState() => _PostPositionFormState();
}

class _PostPositionFormState extends ConsumerState<_PostPositionForm> {
  @override
  void initState() {
    super.initState();
    for (var controller in widget.textControllers) {
      if (controller.text.isEmpty) {
        controller.text = '0';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '포지션',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: GREEN_400),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...PositionType.values
                    .where((e) => e != PositionType.NONE)
                    .mapIndexed((index, e) {
                  return Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return _PositionTextForm(
                        title: e.name,
                        focusNode: widget.focusNodes[index],
                        globalKey: widget.globalKeys[index],
                        onAdd: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final position =
                              PositionType.stringToEnum(position: e.name);
                          final value = ref
                              .read(postFormProvider.notifier)
                              .addRecruitCnt(position: position);
                          widget.textControllers[index].text = value.toString();
                          setState(() {});
                        },
                        onSubtract: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final position =
                              PositionType.stringToEnum(position: e.name);
                          final value = ref
                              .read(postFormProvider.notifier)
                              .subtractRecruitCnt(position: position);
                          widget.textControllers[index].text = value.toString();
                          setState(() {});
                        },
                        controller: widget.textControllers[index],
                        onNext: () {
                          FocusScope.of(context)
                              .requestFocus(widget.focusNodes[index + 1]);
                        },
                      );
                    },
                  );
                }).toList()
              ],
            )
          ],
        ),
        if (!ref.watch(postFormProvider.notifier).getPositionValidate() &&
            ref.watch(checkPositionValidProvider))
          Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text('하나 이상 포지션을 모집해야합니다.', style: Theme.of(context).textTheme.labelSmall!.copyWith(color: TOMATO_500))),
      ],
    );
  }
}

class _PositionTextForm extends ConsumerStatefulWidget {
  final String title;
  final FocusNode focusNode;
  final GlobalKey globalKey;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;
  final VoidCallback onNext;
  final TextEditingController controller;

  const _PositionTextForm({
    super.key,
    required this.title,
    required this.focusNode,
    required this.onAdd,
    required this.onSubtract,
    required this.controller,
    required this.onNext,
    required this.globalKey,
  });

  @override
  ConsumerState<_PositionTextForm> createState() => _PositionTextFormState();
}

class _PositionTextFormState extends ConsumerState<_PositionTextForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(updateCnt);
  }

  void updateCnt() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '0';
    }
    final cnt = int.parse(widget.controller.text);
    final position = PositionType.stringToEnum(position: widget.title);
    ref
        .read(postFormProvider.notifier)
        .updateRecruitCnt(position: position, cnt: cnt);
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateCnt);
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(48.r),
      borderSide: BorderSide(color: GREEN_200, width: 2.w),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: GREEN_400),
            textAlign: TextAlign.left,
          ),
        ),
        IconButton(
            onPressed: widget.onSubtract,
            icon: const Icon(
              Icons.remove,
              color: GREEN_400,
            )),
        SizedBox(
          width: 60.w,
          child: TextFormField(
            key: widget.globalKey,
            focusNode: widget.focusNode,
            controller: widget.controller,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: GREEN_400),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            cursorColor: GREEN_200,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}$')),
            ],
            decoration: InputDecoration(
                border: border,
                focusedBorder: border,
                enabledBorder: border,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                constraints: BoxConstraints.loose(Size(60.w, 40.h))),
            textAlign: TextAlign.center,
            onEditingComplete: widget.onNext,
            onTap: () {
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
            },
            onChanged: (value) {
              if (value.isEmpty) {
                value = '0';
              }
              widget.controller.text = int.parse(value).toString();
              if (value.length > 2) {
                // 입력된 길이가 2를 초과하면 마지막 글자를 제외한 나머지를 취함
                widget.controller.value = widget.controller.value.copyWith(
                  text: value.substring(0, 2),
                  selection: const TextSelection.collapsed(offset: 2),
                );
              }
            },
          ),
        ),
        IconButton(
            onPressed: widget.onAdd,
            icon: const Icon(
              Icons.add,
              color: GREEN_400,
            ))
      ],
    );
  }
}

class _TechStackForm extends ConsumerStatefulWidget {
  final FocusNode focusNode;
  final VoidCallback onNext;
  final GlobalKey globalKey;

  const _TechStackForm({
    super.key,
    required this.focusNode,
    required this.onNext,
    required this.globalKey,
  });

  @override
  ConsumerState<_TechStackForm> createState() => _TechStackFormState();
}

class _TechStackFormState extends ConsumerState<_TechStackForm> {
  late final TextEditingController _controller;
  late final LayerLink _layerLink;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
    widget.focusNode.addListener(disposeResult);
    _controller = TextEditingController();
  }

  void disposeResult() {
    if (!widget.focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  @override
  void deactivate() {
    _removeOverlay();
    super.deactivate();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(disposeResult);
    _controller.dispose();
    super.dispose();
  }

  OverlayEntry _techResult() {
    return OverlayEntry(builder: (_) {
      final model = (ref.read(utilProvider) as TechStackList).stackList!;
      return CompositedTransformFollower(
        link: _layerLink,
        offset: Offset(0, 50.h),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints.loose(Size(200.w, 200.h)),
            decoration: BoxDecoration(
                color: GREY_100,
                border: Border.all(color: GREEN_200, width: 2.w),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 4.r,
                      offset: Offset(0, 4.h)),
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (model.isEmpty)
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            child: Text(
                              '찾는 기술이 없습니다!',
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: GREEN_400),
                            )),
                      ],
                    ),
                  ...model
                      .map((e) => Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: GREY_400, width: 1.w))),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  ref
                                      .read(postFormProvider.notifier)
                                      .updateTechStack(model: e);
                                  _removeOverlay();
                                  _controller.text = '';
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                child: Row(
                                  children: [
                                    TechStackIcon(
                                      name: e.name,
                                      imageUrl: e.imageUrl,
                                      radius: 12,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        e.name,
                                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                          color: GREEN_400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(utilProvider);
    ref.listen(utilProvider, (previous, next) {
      if (next is TechStackList) {
        setState(() {
          if (previous != next) {
            _removeOverlay();
          }
          if (_overlayEntry == null) {
            _overlayEntry = _techResult();
            Overlay.of(context).insert(_overlayEntry!);
          }
        });
      }
    });

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(48.r),
      borderSide: BorderSide(color: GREEN_200, width: 2.w),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '기술 스택',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: GREEN_400),
              ),
            ),
            CompositedTransformTarget(
              link: _layerLink,
              child: TextFormField(
                key: widget.globalKey,
                focusNode: widget.focusNode,
                controller: _controller,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: GREEN_400),
                textInputAction: TextInputAction.next,
                cursorColor: GREEN_200,
                decoration: InputDecoration(
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                  constraints: BoxConstraints.loose(Size(200.w, 40.h)),
                  hintText: '영어로 입력해주세요.',
                ),
                onEditingComplete: widget.onNext,
                onChanged: (value) {
                  ref.read(utilProvider.notifier).getTechStack(title: value);
                },
              ),
            )
          ],
        ),
        SizedBox(height: 12.h),
        if (!ref.watch(postFormProvider.notifier).getTechValidate() &&
            ref.watch(checkTechValidProvider))
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text('필수 사항입니다.', style: Theme.of(context).textTheme.labelSmall!.copyWith(color: TOMATO_500)),
          ),
        Wrap(
          spacing: 12.w,
          children: [
            ...ref.watch(postFormProvider).forWidgetTech.map((e) {
              log('name = ${e.name}');
              return Badge(
                padding: EdgeInsets.zero,
                alignment: Alignment.topRight,
                label: GestureDetector(
                    onTap: () {
                      setState(() {
                        ref
                            .read(postFormProvider.notifier)
                            .updateTechStack(model: e, isAdd: false);
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: TOMATO_500,
                    )),
                largeSize: 20.r,
                backgroundColor: Colors.transparent,
                child: TechStackIcon(
                  name: e.name,
                  imageUrl: e.imageUrl,
                  radius: 20,
                ),
              );
            }).toList(),
          ],
        )
      ],
    );
  }
}

class _MultiTextForm extends StatelessWidget {
  final String title;
  final FocusNode focusNode;
  final VoidCallback onNext;
  final GlobalKey globalKey;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const _MultiTextForm(
      {super.key,
      required this.title,
      required this.focusNode,
      required this.onNext,
      required this.globalKey,
      required this.onChanged,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: GREEN_400),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: TextFormField(
              key: globalKey,
              focusNode: focusNode,
              controller: controller,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: GREEN_400),
              textInputAction: TextInputAction.next,
              cursorColor: GREEN_200,
              maxLines: null,
              maxLength: 500,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: '내용을 입력해주세요.',
              ),
              onEditingComplete: onNext,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '필수사항입니다.';
                }
              },
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
