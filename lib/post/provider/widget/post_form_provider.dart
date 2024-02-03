import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/management/model/team_member_model.dart';
import 'package:pllcare/post/param/post_param.dart';
import 'package:pllcare/util/model/techstack_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/post_model.dart';

part 'post_form_provider.g.dart';

final checkTechValidProvider = StateProvider.autoDispose((ref) => false);
final checkPositionValidProvider = StateProvider.autoDispose((ref) => false);

@Riverpod(keepAlive: false)
class PostForm extends _$PostForm {
  @override
  UpdatePostParam build() {
    return UpdatePostParam(
        title: '',
        description: '',
        recruitStartDate: '',
        recruitEndDate: '',
        reference: '',
        contact: '',
        region: Region.seoul,
        techStack: [],
        recruitInfo: [
          RecruitModel(
              position: PositionType.BACKEND, currentCnt: 0, totalCnt: 0),
          RecruitModel(
              position: PositionType.FRONTEND, currentCnt: 0, totalCnt: 0),
          RecruitModel(
              position: PositionType.PLANNER, currentCnt: 0, totalCnt: 0),
          RecruitModel(
              position: PositionType.DESIGN, currentCnt: 0, totalCnt: 0),
        ],
        forWidgetTech: []);
  }

  void updateFromPostModel({required PostModel model}) {
    final techStack = model.techStackList.map((e) => e.name).toList();
    state = UpdatePostParam(
      title: model.title,
      description: model.description,
      recruitStartDate: model.recruitStartDate,
      recruitEndDate: model.recruitEndDate,
      reference: model.reference,
      contact: model.contact,
      region: model.region,
      techStack: techStack,
      recruitInfo: model.recruitInfoList,
      forWidgetTech: model.techStackList,
    );
  }

  void updateForm({required UpdatePostParam form}) {
    state = form;
  }

  void updateRecruitCnt({required PositionType position, required int cnt}) {
    final recruitInfo = state.recruitInfo;
    final updateRecruit = recruitInfo
        .singleWhere((e) => e.position == position)
        .copyWith(totalCnt: cnt);
    recruitInfo[recruitInfo.indexWhere((e) => e.position == position)] =
        updateRecruit;
    state.copyWith(recruitInfo: recruitInfo);
  }

  int subtractRecruitCnt({required PositionType position}) {
    final recruitInfo = state.recruitInfo;
    final totalCnt =
        recruitInfo.singleWhere((e) => e.position == position).totalCnt;
    if (totalCnt == 0) {
      return totalCnt;
    }
    updateRecruitCnt(position: position, cnt: totalCnt - 1);
    return totalCnt - 1;
  }

  int addRecruitCnt({required PositionType position}) {
    final recruitInfo = state.recruitInfo;
    final totalCnt =
        recruitInfo.singleWhere((e) => e.position == position).totalCnt;
    updateRecruitCnt(position: position, cnt: totalCnt + 1);
    return totalCnt + 1;
  }

  void updateTechStack({required TechStackModel model, bool isAdd = true}) {
    if (!state.techStack.contains(model.name) && isAdd) {
      state.techStack.add(model.name);
      state.forWidgetTech.add(model);
    } else if (state.techStack.contains(model.name) && !isAdd) {
      state.techStack.remove(model.name);
      state.forWidgetTech.remove(model);
    }
  }

  bool getPositionValidate() {
    return state.recruitInfo.where((e) => e.totalCnt == 0).length != 4;
  }

  bool getTechValidate() {
    return state.techStack.isNotEmpty;
  }

  bool validate() {
    final recruitValid = getPositionValidate();
    final techValid = getTechValidate();
    return recruitValid && techValid ? true : false;
  }
}
