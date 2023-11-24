import 'package:json_annotation/json_annotation.dart';

import '../../common/model/default_model.dart';
import '../../common/page/param/page_param.dart';

part 'param.g.dart';


@JsonSerializable()
class ProjectParams  extends PageParams{

  final List<StateType> state;

  ProjectParams({
    required super.page,
    required super.size,
    required super.direction,
    required this.state,
  });

  Map<String, dynamic> toJson() => _$ProjectParamsToJson(this);
}
