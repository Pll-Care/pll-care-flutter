/*
{
  "content": [
    {
      "postId": 0,
      "title": "string",
      "description": "string",
      "state": "TBD"
    }
  ],
  "pageNumber": 0,
  "totalElements": 0,
  "totalPages": 0,
  "last": true,
  "size": 0,
  "sort": {
    "empty": true,
    "sorted": true,
    "unsorted": true
  },
  "numberOfElements": 0,
  "first": true,
  "empty": true
}
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';

part 'profile_post_model.g.dart';

@JsonSerializable()
class ProfilePostModel {
  final int postId;
  final String title;
  final String description;
  final StateType state;

  ProfilePostModel({
    required this.postId,
    required this.title,
    required this.description,
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
