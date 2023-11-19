import 'package:json_annotation/json_annotation.dart';

part 'param.g.dart';

enum ProjectListType { TBD, ONGOING, COMPLETE }

@JsonSerializable()
class ProjectParams {
  final int page;
  final int size;
  final String direction;

  final List<ProjectListType> state;

  ProjectParams({
    required this.page,
    required this.size,
    required this.direction,
    required this.state,
  });

  Map<String, dynamic> toJson() => _$ProjectParamsToJson(this);
}
