import 'package:json_annotation/json_annotation.dart';
part 'apply_param.g.dart';
@JsonSerializable()
class ApplyParam{
  final int applyId;

  ApplyParam({required this.applyId});

  Map<String, dynamic> toJson() => _$ApplyParamToJson(this);
}