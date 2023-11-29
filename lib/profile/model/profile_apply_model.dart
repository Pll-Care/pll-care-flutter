import 'package:json_annotation/json_annotation.dart';
import '../../common/model/default_model.dart';
part 'profile_apply_model.g.dart';

@JsonSerializable()
class ProfileApplyList extends PaginationModel<ProfileApplyModel> {
  @override
  @JsonKey(name: 'content')
  get data => super.data;

  ProfileApplyList(
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

  factory ProfileApplyList.fromJson(Map<String, dynamic> json) =>
      _$ProfileApplyListFromJson(json);
}


@JsonSerializable()
class ProfileApplyModel {
  final int postId;
  final String title;
  final String description;

  ProfileApplyModel({
    required this.postId,
    required this.title,
    required this.description,
  });

  factory ProfileApplyModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileApplyModelFromJson(json);
}