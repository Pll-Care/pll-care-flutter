import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel extends BaseModel {
  final String imageUrl;

  ImageModel({required this.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json)
  => _$ImageModelFromJson(json);
}
