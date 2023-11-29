import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'techstack_model.g.dart';

/*
  "stackList": [
    {
      "name": "string",
      "imageUrl": "string"
    }
  ]
 */
@JsonSerializable()
class TechStackList extends BaseModel{
  final List<TechStackModel>? stackList;

  TechStackList({
    required this.stackList,
  });

  factory TechStackList.fromJson(Map<String, dynamic> json) =>
      _$TechStackListFromJson(json);
}

@JsonSerializable()
class TechStackModel {
  final String name;
  final String imageUrl;

  TechStackModel({
    required this.name,
    required this.imageUrl,
  });

  factory TechStackModel.fromJson(Map<String, dynamic> json) =>
      _$TechStackModelFromJson(json);
}
