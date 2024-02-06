import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/team_member_model.dart';

part 'management_form_provider.g.dart';

enum TeamMemberUpdateType {
  position,
  ban,
  leader,
}

final teamMemberTypeProvider =
    StateProvider.autoDispose((ref) => TeamMemberUpdateType.position);

class TeamMemberUpdateModel {
  final TeamMemberModel? teamMember;
  final PositionType? position;

  TeamMemberUpdateModel({
    this.teamMember,
    this.position,
  });

  TeamMemberUpdateModel copyWith({
    final TeamMemberModel? teamMember,
    final PositionType? position,
  }) {
    return TeamMemberUpdateModel(
      teamMember: teamMember ?? this.teamMember,
      position: position ?? this.position,
    );
  }
}

@riverpod
class TeamMember extends _$TeamMember {
  @override
  TeamMemberUpdateModel build() {
    return TeamMemberUpdateModel();
  }

  void update({TeamMemberModel? teamMember, PositionType? position}) {
    state = state.copyWith(teamMember: teamMember, position: position);
  }
  void clear(){
    state = TeamMemberUpdateModel();
  }
}
