import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';

part 'profile_eval_model.g.dart';

@JsonSerializable()
class ProfileEvalList extends PaginationModel<ProfileEvalListModel> {
  @override
  @JsonKey(name: 'content')
  List<ProfileEvalListModel>? get data => super.data;

  ProfileEvalList(
      {required super.data,
      required super.pageNumber,
      required super.totalElements,
      required super.totalPages,
      required super.last,
      required super.size,
      required super.sort,
      required super.numberOfElements,
      required super.first,
      required super.empty});

  factory ProfileEvalList.fromJson(Map<String, dynamic> json) =>
      _$ProfileEvalListFromJson(json);
}


@JsonSerializable()
class ProfileEvalListModel {
  final int projectId;
  final String? imageUrl;
  final String? title;
  final ScoreModel score;

  ProfileEvalListModel({
    required this.projectId,
    required this.imageUrl,
    required this.title,
    required this.score,
  });

  factory ProfileEvalListModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileEvalListModelFromJson(json);
}

@JsonSerializable()
class Badge {
  final String support;
  final int quantity1;
  final String leader;
  final int quantity2;
  final String participant;
  final int quantity3;
  final String bank;
  final int quantity4;

  Badge({
    required this.support,
    required this.quantity1,
    required this.leader,
    required this.quantity2,
    required this.participant,
    required this.quantity3,
    required this.bank,
    required this.quantity4,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

@JsonSerializable()
class FinalEval {
  final int memberId;
  final String name;
  final String imageUrl;
  final String content;
  final ScoreModel score;

  FinalEval({
    required this.memberId,
    required this.name,
    required this.imageUrl,
    required this.content,
    required this.score,
  });

  factory FinalEval.fromJson(Map<String, dynamic> json) =>
      _$FinalEvalFromJson(json);
}

@JsonSerializable()
class ProfileEvalModel extends BaseModel{
  final Badge badges;
  final List<FinalEval> finalEvals;

  ProfileEvalModel({
    required this.badges,
    required this.finalEvals,
  });

  factory ProfileEvalModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileEvalModelFromJson(json);
}
