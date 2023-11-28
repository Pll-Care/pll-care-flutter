import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/management/model/team_member_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel extends BaseModel {
  final int postId;
  final int projectId;
  final String projectTitle;
  final String projectImageUrl;
  final String author;
  final String authorImageUrl;
  final String title;
  final String description;
  final String recruitStartDate;
  final String recruitEndDate;
  final String reference;
  final String contact;
  final String region;
  final List<TechStack> techStackList;
  final PositionType applyPosition;
  final List<RecruitModel> recruitInfoList;
  final String createdDate;
  final String modifiedDate;
  final int likeCount;
  final bool liked;
  final bool editable;
  final bool deletable;

  PostModel({
    required this.postId,
    required this.projectId,
    required this.projectTitle,
    required this.projectImageUrl,
    required this.author,
    required this.authorImageUrl,
    required this.title,
    required this.description,
    required this.recruitStartDate,
    required this.recruitEndDate,
    required this.reference,
    required this.contact,
    required this.region,
    required this.techStackList,
    required this.applyPosition,
    required this.recruitInfoList,
    required this.createdDate,
    required this.modifiedDate,
    required this.likeCount,
    required this.liked,
    required this.editable,
    required this.deletable,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@JsonSerializable()
class TechStack {
  final String name;
  final String imageUrl;

  TechStack({
    required this.name,
    required this.imageUrl,
  });

  factory TechStack.fromJson(Map<String, dynamic> json) =>
      _$TechStackFromJson(json);
}

@JsonSerializable()
class RecruitModel {
  final PositionType position;
  final int currentCnt;
  final int totalCnt;

  RecruitModel({
    required this.position,
    required this.currentCnt,
    required this.totalCnt,
  });

  factory RecruitModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecruitModelToJson(this);
}

@JsonSerializable()
class PostListModel {
  final int postId;
  final String? projectName;
  final String? projectImageUrl;
  final String? title;
  final String? recruitStartDate;
  final String? recruitEndDate;
  final List<TechStack> techStackList;
  final List<RecruitModel> recruitInfoList;
  final String? createdDate;
  final String? modifiedDate;
  final int likeCount;
  final bool liked;

  PostListModel({
    required this.postId,
    required this.projectName,
    required this.projectImageUrl,
    required this.title,
    required this.recruitStartDate,
    required this.recruitEndDate,
    required this.techStackList,
    required this.recruitInfoList,
    required this.createdDate,
    required this.modifiedDate,
    required this.likeCount,
    required this.liked,
  });

  PostListModel copyWith({
    final int? postId,
    final String? projectName,
    final String? projectImageUrl,
    final String? title,
    final String? recruitStartDate,
    final String? recruitEndDate,
    final List<TechStack>? techStackList,
    final List<RecruitModel>? recruitInfoList,
    final String? createdDate,
    final String? modifiedDate,
    final int? likeCount,
    final bool? liked,
  }) {
    return PostListModel(
      postId: postId ?? this.postId,
      projectName: projectName ?? this.projectName,
      projectImageUrl: projectImageUrl ?? this.projectImageUrl,
      title: title ?? this.title,
      recruitStartDate: recruitStartDate ?? this.recruitStartDate,
      recruitEndDate: recruitEndDate ?? this.recruitEndDate,
      techStackList: techStackList ?? this.techStackList,
      recruitInfoList: recruitInfoList ?? this.recruitInfoList,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      likeCount: likeCount ?? this.likeCount,
      liked: liked ?? this.liked,
    );
  }

  factory PostListModel.fromJson(Map<String, dynamic> json) =>
      _$PostListModelFromJson(json);
}

@JsonSerializable()
class PostList extends PaginationModel<PostListModel> {
  @JsonKey(name: 'content')
  @override
  List<PostListModel>? get data => super.data;

  PostList(
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

  factory PostList.fromJson(Map<String, dynamic> json) =>
      _$PostListFromJson(json);
}
