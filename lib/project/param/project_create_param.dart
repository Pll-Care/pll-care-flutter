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

part 'project_create_param.g.dart';

@JsonSerializable()
class ProjectCreateParam {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String imageUrl;

  ProjectCreateParam({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() =>_$ProjectCreateParamToJson(this);
}
