import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/common/component/default_flash.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';
import 'package:pllcare/evaluation/provider/finalterm_provider.dart';
import 'package:pllcare/util/custom_dialog.dart';

import '../../common/model/default_model.dart';
import '../../theme.dart';
import '../model/finalterm_model.dart';
import '../model/midterm_model.dart';
import '../provider/widget_provider.dart';

final finalFormKey = GlobalKey<FormState>();

class FinalDialog extends ConsumerWidget {
  final int memberId;
  final String name;
  final List<BadgeModel> badges;
  final int projectId;
  final int? finalEvalId;
  late String evalContent;
  FinalTermModel? model;

  FinalDialog(
      {super.key,
      required this.memberId,
      required this.badges,
      required this.name,
      required this.finalEvalId,
      required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (finalEvalId != null) {
      final bModel = ref.watch(finalEvalProvider(FinalEvalProviderParam(
          projectId: projectId,
          type: FinalProviderType.getEval,
          evaluationId: finalEvalId)));
      if (bModel is LoadingModel) {
        return Container();
      } else if (bModel is ErrorModel) {
      } else {
        model = bModel as FinalTermModel;
      }
    }

    return Dialog(
      backgroundColor: GREEN_200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Form(
                key: finalFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    Text(
                      '\'$name\' ${finalEvalId == null ? '평가하기' : '평가보기'}',
                      style: m_Heading_05.copyWith(color: GREY_100),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54.withOpacity(0.1),
                                blurStyle: BlurStyle.outer,
                                blurRadius: 30,
                              )
                            ],
                            color: GREY_100),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _ScoreComponent(
                                  scoreModel: model?.score,
                                ),
                                _BadgeComponent(
                                  badges: badges,
                                ),
                                _FinalTextFormComponent(
                                  onSaved: onSaved,
                                  evalContent: model?.content,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (finalEvalId == null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            finalFormKey.currentState!.save();
                            if (finalFormKey.currentState!.validate()) {
                              onCreateEval(ref, context);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: GREY_100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                side: const BorderSide(
                                    color: GREEN_200, width: 1)),
                          ),
                          child: Text(
                            "작성완료",
                            style: m_Button_00.copyWith(color: GREEN_200),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onCreateEval(WidgetRef ref, BuildContext context) async {
    {
      CustomDialog.showCustomDialog(
          context: context,
          backgroundColor: GREEN_200,
          content: Text(
            "작성 완료한 평가는 수정 또는 삭제할 수 없습니다.\n작성 완료 하시겠습니까?",
            style: Heading_06.copyWith(
              color: GREY_100,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final result = await ref
                    .read(finalEvalProvider(FinalEvalProviderParam(
                            projectId: projectId,
                            type: FinalProviderType.create))
                        .notifier)
                    .createEval(
                        param: CreateFinalTermParam(
                            projectId: projectId,
                            evaluatedId: memberId,
                            score: ref.read(scoreProvider),
                            content: evalContent));

                if (result is CompletedModel) {
                  int count = 0;
                  if (context.mounted) {
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  }
                } else if (result is ErrorModel && context.mounted) {
                  DefaultFlash.showFlash(
                      context: context,
                      type: FlashType.fail,
                      content: result.message);
                }
              },
              style: CustomDialog.textButtonStyle,
              child: Text(
                "네",
                style: Button_03.copyWith(color: GREEN_400),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              style: CustomDialog.textButtonStyle,
              child: Text(
                "아니오",
                style: Button_03.copyWith(color: GREEN_400),
              ),
            )
          ]);
    }
  }

  void onSaved(String? newValue) {
    evalContent = newValue!;
  }
}

class _ScoreComponent extends StatelessWidget {
  final ScoreModel? scoreModel;

  const _ScoreComponent({super.key, required this.scoreModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 12.h,
        ),
        Text(
          '평가 작성',
          style: m_Heading_02.copyWith(color: GREEN_400),
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ScoreModel? score;
            if (scoreModel == null) {
              score = ref.watch(scoreProvider);
            }
            return _ScoreCard(
              title: '성실도',
              onChanged: (int? value) {
                if (value != null) {
                  ref.watch(scoreProvider.notifier).update(
                      (state) => state.copyWith(sincerity: value.toDouble()));
                }
              },
              selectedValue: score?.sincerity.toInt(),
              scoreModel: scoreModel,
            );
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ScoreModel? score;
            if (scoreModel == null) {
              score = ref.watch(scoreProvider);
            }
            return _ScoreCard(
              title: '시간 엄수',
              onChanged: (int? value) {
                if (value != null) {
                  ref.watch(scoreProvider.notifier).update(
                      (state) => state.copyWith(punctuality: value.toDouble()));
                }
              },
              selectedValue: score?.punctuality.toInt(),
              scoreModel: scoreModel,
            );
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ScoreModel? score;
            if (scoreModel == null) {
              score = ref.watch(scoreProvider);
            }
            return _ScoreCard(
              title: '업무 수행 능력',
              onChanged: (int? value) {
                if (value != null) {
                  ref.watch(scoreProvider.notifier).update((state) =>
                      state.copyWith(jobPerformance: value.toDouble()));
                }
              },
              selectedValue: score?.jobPerformance.toInt(),
              scoreModel: scoreModel,
            );
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            ScoreModel? score;
            if (scoreModel == null) {
              score = ref.watch(scoreProvider);
            }
            return _ScoreCard(
              title: '의사 소통',
              onChanged: (int? value) {
                if (value != null) {
                  ref.watch(scoreProvider.notifier).update((state) =>
                      state.copyWith(communication: value.toDouble()));
                }
              },
              selectedValue: score?.communication.toInt(),
              scoreModel: scoreModel,
            );
          },
        ),
        SizedBox(
          height: 25.h,
        ),
        Divider(
          color: GREY_400,
          indent: 6.w,
          endIndent: 6.w,
          thickness: 2.h,
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final int? selectedValue;
  final ValueChanged<int?>? onChanged;
  final ScoreModel? scoreModel;

  const _ScoreCard({
    super.key,
    required this.title,
    required this.onChanged,
    required this.selectedValue,
    required this.scoreModel,
  });

  @override
  Widget build(BuildContext context) {
    final evalDropItem = [0, 1, 2, 3, 4, 5];
    num score = 0;
    score = setScore(score);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 25.w,
        vertical: 5.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: m_Heading_03.copyWith(color: GREY_500),
            ),
          ),
          if (scoreModel != null)
            Text(
              "$score점",
              style: m_Heading_03.copyWith(color: GREY_500),
            ),
          if (scoreModel == null)
            ButtonTheme(
              alignedDropdown: true,
              child: InputDecorator(
                // expands: true,
                decoration: InputDecoration(
                    constraints: BoxConstraints.tight(Size(60.w, 25.h)),
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: const BorderSide(color: GREEN_200)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: GREEN_200)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(color: GREEN_200))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      style: m_Heading_03.copyWith(
                        color: GREEN_400,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                      iconEnabledColor: GREEN_200,
                      iconDisabledColor: GREEN_200,
                      isDense: true,
                      isExpanded: true,
                      underline: null,
                      items: [
                        ...evalDropItem
                            .map((e) => DropdownMenuItem<int>(
                                  value: e,
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text('$e'))),
                                ))
                            .toList()
                      ],
                      value: selectedValue,
                      onChanged: onChanged),
                ),
              ),
            )
        ],
      ),
    );
  }

  num setScore(num score) {
    if (scoreModel != null) {
      switch (title) {
        case '성실도':
          score = scoreModel!.sincerity;
          break;
        case '시간 엄수':
          score = scoreModel!.punctuality;
          break;
        case '업무 수행 능력':
          score = scoreModel!.jobPerformance;
          break;
        default:
          score = scoreModel!.communication;
          break;
      }
    }
    return score;
  }
}

class _BadgeComponent extends StatelessWidget {
  final List<BadgeModel> badges;

  const _BadgeComponent({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "누적 뱃지",
          style: m_Heading_02.copyWith(color: GREEN_400),
        ),
        SizedBox(
          height: 14.h,
        ),
        ...badges.map((e) => _BadgeCard(model: e)).toList(),
        SizedBox(
          height: 25.h,
        ),
        Divider(
          color: GREY_400,
          indent: 6.w,
          endIndent: 6.w,
          thickness: 2.h,
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeModel model;

  const _BadgeCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
        child: Row(
          children: [
            getBadgeIcon(badge: model),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
                child: Text(
              model.evaluationBadge.name,
              style: m_Heading_03.copyWith(color: GREY_500),
            )),
            Text(
              "${model.quantity ?? 0}개",
              style: m_Heading_03.copyWith(color: GREY_500),
            )
          ],
        ));
  }

  Widget getBadgeIcon({required BadgeModel badge}) {
    final IconData icon;
    switch (badge.evaluationBadge) {
      case BadgeType.PASSIONATE:
        icon = Icons.local_fire_department;
        break;
      case BadgeType.BANK:
        icon = Icons.lightbulb;
        break;
      case BadgeType.LEADER:
        icon = Icons.people;
        break;
      case BadgeType.SUPPORTER:
        icon = Icons.handshake;
        break;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: GREEN_200)),
            child: Icon(
              icon,
              size: 20,
            ),
          ),
        ),
        // Text(
        //   ' · 4',
        //   style: m_Body_01.copyWith(color: GREY_500),
        // )
      ],
    );
  }
}

final FocusNode textFocus = FocusNode();
final textFieldGlobalKey = GlobalKey();

class _FinalTextFormComponent extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String? evalContent;

  const _FinalTextFormComponent({
    super.key,
    required this.onSaved,
    required this.evalContent,
  });

  @override
  Widget build(BuildContext context) {
    final inputFormBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(color: GREEN_200, width: 2.0),
    );
    return SizedBox(
      height: 250.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "최종 의견",
            style: m_Heading_02.copyWith(color: GREEN_400),
          ),
          SizedBox(
            height: 14.h,
          ),
          if (evalContent != null)
            Expanded(
              child: Text(
                evalContent!,
                style: m_Heading_03.copyWith(color: GREY_500),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (evalContent == null)
            Expanded(
              child: TextFormField(
                key: textFieldGlobalKey,
                focusNode: textFocus,
                onTap: () {
                  Scrollable.ensureVisible(textFieldGlobalKey.currentContext!);
                  textFocus.requestFocus();
                },
                onSaved: onSaved,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Scrollable.ensureVisible(
                        textFieldGlobalKey.currentContext!);
                    return '평가 내용은 필수 사항입니다.';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.top,
                cursorColor: GREEN_400,
                maxLines: null,
                maxLength: 500,
                expands: true,
                decoration: InputDecoration(
                  border: inputFormBorder,
                  focusedBorder: inputFormBorder,
                  enabledBorder: inputFormBorder,
                ),
              ),
            ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
