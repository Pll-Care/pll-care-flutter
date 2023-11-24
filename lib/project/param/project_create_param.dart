/*
{
  "title": "string",
  "description": "string",
  "startDate": "2023-11-24",
  "endDate": "2023-11-24",
  "imageUrl": "string"
}
 */
import 'package:json_annotation/json_annotation.dart';

import '../../common/model/default_model.dart';

part 'project_create_param.g.dart';

@JsonSerializable()
class CreateProjectFormParam {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String imageUrl;

  CreateProjectFormParam({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => _$CreateProjectFormParamToJson(this);
}

@JsonSerializable()
class UpdateProjectFormParam extends CreateProjectFormParam {
  final StateType state;
  UpdateProjectFormParam({
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.imageUrl,
    this.state = StateType.ONGOING,
  });

  @override
  Map<String, dynamic> toJson() => _$UpdateProjectFormParamToJson(this);
}
