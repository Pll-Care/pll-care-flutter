import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/management/model/team_member_model.dart';

part 'post_model.g.dart';

enum Region {
  @JsonValue('서울')
  seoul('서울'),
  @JsonValue('경기')
  gyeonggi('경기'),
  @JsonValue('인천')
  incheon('인천'),
  @JsonValue('대구')
  daegu('대구'),
  @JsonValue('부산')
  busan('부산'),
  @JsonValue('울산')
  ulsan('울산'),
  @JsonValue('광주')
  gwangju('광주'),
  @JsonValue('전주')
  jeonju('전주'),
  @JsonValue('대전')
  daejeon('대전'),
  @JsonValue('세종')
  sejong('세종'),
  @JsonValue('강원')
  gangwon('강원');
  const Region(this.name);
  final String name;
}

@JsonSerializable()
class PostModel extends BaseModel {
  final int postId;
  final int projectId;
  final String projectTitle;
  final String? projectImageUrl;
  final String author;
  final String authorImageUrl;
  final String title;
  final String description;
  final String recruitStartDate;
  final String recruitEndDate;
  final String reference;
  final String contact;
  final Region region;
  final List<TechStack> techStackList;
  final PositionType? applyPosition;
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

  PostModel copyWith({
    int? postId,
    int? projectId,
    String? projectTitle,
    String? projectImageUrl,
    String? author,
    String? authorImageUrl,
    String? title,
    String? description,
    String? recruitStartDate,
    String? recruitEndDate,
    String? reference,
    String? contact,
    Region? region,
    List<TechStack>? techStackList,
    PositionType? applyPosition,
    List<RecruitModel>? recruitInfoList,
    String? createdDate,
    String? modifiedDate,
    int? likeCount,
    bool? liked,
    bool? editable,
    bool? deletable,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      projectId: projectId ?? this.projectId,
      projectTitle: projectTitle ?? this.projectTitle,
      projectImageUrl: projectImageUrl ?? this.projectImageUrl,
      author: author ?? this.author,
      authorImageUrl: authorImageUrl ?? this.authorImageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      recruitStartDate: recruitStartDate ?? this.recruitStartDate,
      recruitEndDate: recruitEndDate ?? this.recruitEndDate,
      reference: reference ?? this.reference,
      contact: contact ?? this.contact,
      region: region ?? this.region,
      techStackList: techStackList ?? this.techStackList,
      applyPosition: applyPosition ?? this.applyPosition,
      recruitInfoList: recruitInfoList ?? this.recruitInfoList,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      likeCount: likeCount ?? this.likeCount,
      liked: liked ?? this.liked,
      editable: editable ?? this.editable,
      deletable: deletable ?? this.deletable,
    );
  }

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

  PostList copyWith({
    final List<PostListModel>? data,
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
    return PostList(
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

  factory PostList.fromJson(Map<String, dynamic> json) =>
      _$PostListFromJson(json);
}
