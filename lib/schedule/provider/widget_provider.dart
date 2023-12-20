// final scheduleFilterProvider =

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/management/provider/management_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../management/model/team_member_model.dart';

// part 'widget_provider.g.dart';

enum FilterType {
  ALL,
  PLAN,
  MEETING,
  PREVIOUS;

}

class ScheduleFilterModel extends Equatable{
  final FilterType filterType;
  final int? memberId;

  const ScheduleFilterModel({
    required this.filterType,
    required this.memberId,
  });

  ScheduleFilterModel copyWith({
    FilterType? filterType,
    int? memberId,
  }) {
    return ScheduleFilterModel(
      filterType: filterType ?? this.filterType,
      memberId: memberId ?? this.memberId,
    );
  }

  @override
  List<Object?> get props => [filterType, memberId];

  @override
  bool? get stringify => true;

}

// @Riverpod()
// class ScheduleFilter extends _$ScheduleFilter {
//   final int projectId;
//   ScheduleFilter({required this.projectId});
//
//   @override
//   ScheduleFilterModel build() {
//     final model = ref.read(managementProvider(projectId));
//
//     return ScheduleFilterModel(
//       filterType: FilterType.ALL,
//       memberId: null,
//     );
//   }
//
//   void selectFilter({FilterType? filterType, int? memberId}) {
//     state = state.copyWith(filterType: filterType, memberId: memberId);
//   }
// }

final scheduleFilterProvider = StateNotifierProvider.family
    .autoDispose<ScheduleFilterStateNotifier, ScheduleFilterModel, int>(
        (ref, projectId) {
  final state = ref.watch(managementProvider(projectId));
  if (state is ListModel<TeamMemberModel>) {
    return ScheduleFilterStateNotifier(memberId: state.data.first.memberId);
  }
  return ScheduleFilterStateNotifier(memberId: null);
});

class ScheduleFilterStateNotifier extends StateNotifier<ScheduleFilterModel> {
  final int? memberId;

  ScheduleFilterStateNotifier({this.memberId})
      : super(const ScheduleFilterModel(
          filterType: FilterType.ALL,
          memberId: null,
        ));

  void selectFilter({FilterType? filterType, int? memberId}) {
    state = state.copyWith(filterType: filterType, memberId: memberId);
  }
}
