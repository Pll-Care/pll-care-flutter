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

  ProfileApplyList copyWith({
    final List<ProfileApplyModel>? data,
    final int? pageNumber,
    final int? totalElements,
    final int? totalPages,
    final bool? last,
    final int? size,
    final PaginationSort? sort,
    final int? numberOfElements,
    final bool? first,
    final bool? empty,
  }) {
    return ProfileApplyList(
      data: data ?? this.data,
      pageNumber: pageNumber ?? this.pageNumber,
      totalElements: totalElements ?? this.totalElements,
      totalPages: totalPages ?? this.totalPages,
      last: last ?? this.last,
      size: size ?? this.size,
      sort: sort ?? this.sort,
      numberOfElements: numberOfElements ?? this.numberOfElements,
      first: first ?? this.first,
      empty: empty ?? this.empty,
    );
  }
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
