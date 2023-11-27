import 'package:json_annotation/json_annotation.dart';

import '../model/team_member_model.dart';

part 'management_param.g.dart';

@JsonSerializable()
class ManagementBaseParam {
  final int id;

  ManagementBaseParam({required this.id});

  Map<String, dynamic> toJson() => _$ManagementBaseParamToJson(this);
}

@JsonSerializable()
class ApplyParam extends ManagementBaseParam {
  ApplyParam({required super.id});

  @override
  @JsonKey(name: 'applyId')
  get id => super.id;

  @override
  Map<String, dynamic> toJson() => _$ApplyParamToJson(this);
}

@JsonSerializable()
class KickOutParam extends ManagementBaseParam {
  KickOutParam({required super.id});

  @override
  @JsonKey(name: 'memberId')
  get id => super.id;

  @override
  Map<String, dynamic> toJson() => _$KickOutParamToJson(this);
}

@JsonSerializable()
class ChangeLeaderParam extends ManagementBaseParam {
  ChangeLeaderParam({required super.id});

  @override
  @JsonKey(name: 'memberId')
  get id => super.id;

  @override
  Map<String, dynamic> toJson() => _$ChangeLeaderParamToJson(this);
}

@JsonSerializable()
class ChangePositionParam extends ManagementBaseParam {
  final PositionType position;

  ChangePositionParam({required super.id, required this.position});

  @override
  @JsonKey(name: 'memberId')
  get id => super.id;

  @override
  Map<String, dynamic> toJson() => _$ChangePositionParamToJson(this);
}
