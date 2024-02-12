import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/profile/model/profile_apply_model.dart';

part 'profile_post_model.g.dart';

@JsonSerializable()
class ProfilePostModel extends ProfileApplyModel {
  final StateType state;

  ProfilePostModel({
    required super.postId,
    required super.title,
    required super.description,
    required this.state,
  });

  factory ProfilePostModel.fromJson(Map<String, dynamic> json) =>
      _$ProfilePostModelFromJson(json);
}

@JsonSerializable()
class ProfilePostList extends PaginationModel<ProfilePostModel> {
  @override
  @JsonKey(name: 'content')
  get data => super.data;

  ProfilePostList(
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

  factory ProfilePostList.fromJson(Map<String, dynamic> json) =>
      _$ProfilePostListFromJson(json);
}
