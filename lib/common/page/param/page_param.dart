

import 'package:json_annotation/json_annotation.dart';
part 'page_param.g.dart';
@JsonSerializable()
class PageParams {
  final int page;
  final int size;
  final String direction;

  PageParams({
    required this.page,
    required this.size,
    required this.direction,
  });

  Map<String, dynamic> toJson() => _$PageParamsToJson(this);
}

